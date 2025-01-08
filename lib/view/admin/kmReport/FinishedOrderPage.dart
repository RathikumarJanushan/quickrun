import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickrun/view/admin/kmReport/OrderDetailsPage.dart';
import 'package:quickrun/view/admin/kmReport/order_summary_helper.dart';
import 'package:quickrun/view/admin/menu/order/LiveOrderDetailsPage.dart';
import 'order_helper.dart';

class FinishedOrderPage extends StatefulWidget {
  const FinishedOrderPage({Key? key}) : super(key: key);

  @override
  State<FinishedOrderPage> createState() => _FinishedOrderPageState();
}

class _FinishedOrderPageState extends State<FinishedOrderPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedRestaurant;

  Future<List<String>> _fetchRestaurantNames() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('finished_order_details')
        .get();
    final restaurants = snapshot.docs
        .map((doc) =>
            (doc.data()['restaurantDetails']?['name'] ?? 'Unknown').toString())
        .toSet()
        .toList();
    return restaurants;
  }

  void _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  void _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finished Order Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: _startDate != null
                            ? '${_startDate!.year}-${_startDate!.month}-${_startDate!.day}'
                            : 'Select Start Date',
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      onTap: () => _selectStartDate(context),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: _endDate != null
                            ? '${_endDate!.year}-${_endDate!.month}-${_endDate!.day}'
                            : 'Select End Date',
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      onTap: () => _selectEndDate(context),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<String>>(
                future: _fetchRestaurantNames(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No restaurants available.');
                  }

                  final restaurants = snapshot.data!;
                  return DropdownButton<String>(
                    hint: const Text('Select Restaurant'),
                    value: _selectedRestaurant,
                    items: restaurants
                        .map((name) => DropdownMenuItem<String>(
                              value: name,
                              child: Text(name),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRestaurant = value;
                      });
                    },
                  );
                },
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('finished_order_details')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No orders available.'),
                  );
                }

                final orders = snapshot.data!.docs.where((order) {
                  final data = order.data() as Map<String, dynamic>;
                  final restaurantDetails =
                      data['restaurantDetails'] as Map<String, dynamic>?;
                  final restaurantName =
                      restaurantDetails?['name'] ?? 'Unknown';
                  final timestamp = (data['timestamp'] as Timestamp).toDate();

                  final matchesDate = _startDate != null && _endDate != null
                      ? timestamp.isAfter(_startDate!) &&
                          timestamp
                              .isBefore(_endDate!.add(const Duration(days: 1)))
                      : true;

                  final matchesRestaurant = _selectedRestaurant != null
                      ? restaurantName == _selectedRestaurant
                      : true;

                  return matchesDate && matchesRestaurant;
                }).toList();

                if (orders.isEmpty) {
                  return const Center(
                    child: Text(
                      'No orders available for the selected filters.',
                    ),
                  );
                }

                double totalKm = 0;
                double totalAmount = 0;
                int totalParcelCount = 0;
                final parcelCountDistribution = <int, int>{};

                for (final order in orders) {
                  final data = order.data() as Map<String, dynamic>;
                  totalKm += (data['totalPathDistance'] ?? 0).toDouble();
                  final parcelDetails =
                      data['parcelDetails'] as List<dynamic>? ?? [];
                  totalParcelCount += parcelDetails.length;
                  totalAmount += parcelDetails.fold<double>(0, (sum, parcel) {
                    final cashAmount = parcel['cash_amount'];
                    return sum +
                        (double.tryParse(cashAmount?.toString() ?? '0') ?? 0);
                  });
                  final parcelCount = parcelDetails.length;
                  parcelCountDistribution[parcelCount] =
                      (parcelCountDistribution[parcelCount] ?? 0) + 1;
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SummaryTable(
                        totalKm: totalKm,
                        totalParcelCount: totalParcelCount,
                        totalAmount: totalAmount,
                        totalOrders: orders.length,
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         'Total KM: ${totalKm.toStringAsFixed(2)} * 2 = ${(totalKm * 2).toStringAsFixed(2)}',
                    //       ),
                    //       Text(
                    //         'Total Parcel Count: $totalParcelCount * 5 = ${totalParcelCount * 5}',
                    //       ),
                    //       Text(
                    //         'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
                    //       ),
                    //       const SizedBox(height: 8),
                    //       Text('Total Rows: ${orders.length}'),
                    //       Text(
                    //         'Pickup Parcels 1: ${orders.length} * 5 = ${(orders.length * 5).toStringAsFixed(2)}',
                    //       ),
                    //       Text(
                    //         'Pickup Parcels 2: ($totalParcelCount - ${orders.length}) * 2.5 = ${((totalParcelCount - orders.length) * 2.5).toStringAsFixed(2)}',
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('No')),
                          DataColumn(label: Text('Timestamp')),
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Restaurant')),
                          DataColumn(label: Text('Parcel Names')),
                          DataColumn(label: Text('Parcel Count')),
                          DataColumn(label: Text('Amount')),
                          DataColumn(label: Text('Total km')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: orders.asMap().entries.map((entry) {
                          final index = entry.key + 1;
                          final order = entry.value;
                          final data = order.data() as Map<String, dynamic>;
                          final restaurantDetails = data['restaurantDetails']
                              as Map<String, dynamic>?;
                          final timestamp = data['timestamp'] != null
                              ? (data['timestamp'] as Timestamp)
                                  .toDate()
                                  .toString()
                              : 'N/A';
                          final userId = data['userId'] ?? 'N/A';
                          final totalPathDistance =
                              data['totalPathDistance']?.toString() ?? 'N/A';
                          final parcelDetails =
                              data['parcelDetails'] as List<dynamic>? ?? [];
                          final parcelCount = parcelDetails.length;

                          final cashAmountSum =
                              parcelDetails.fold<double>(0.0, (sum, parcel) {
                            final cashAmount = parcel['cash_amount'];
                            return sum +
                                (double.tryParse(
                                        cashAmount?.toString() ?? '0') ??
                                    0);
                          });

                          return DataRow(cells: [
                            DataCell(Text(index.toString())),
                            DataCell(Text(timestamp)),
                            DataCell(
                              FutureBuilder<String>(
                                future: OrderHelper.getUserName(userId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text('Loading...');
                                  }
                                  return Text(snapshot.data ?? 'Unknown');
                                },
                              ),
                            ),
                            DataCell(Text(restaurantDetails?['name'] ?? 'N/A')),
                            DataCell(
                              Text(
                                parcelDetails
                                    .map((parcel) =>
                                        '${parcel['name']} (${parcel['cash_amount'] ?? 'N/A'})')
                                    .join(', '),
                              ),
                            ),
                            DataCell(Text(parcelCount.toString())),
                            DataCell(Text(cashAmountSum.toStringAsFixed(2))),
                            DataCell(Text(totalPathDistance)),
                            DataCell(
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OrderDetails(
                                            orderId: order.id,
                                            orderData: data,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('View'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue),
                                    onPressed: () {
                                      OrderHelper.editOrder(
                                          context, order.id, data);
                                    },
                                    child: const Text('Edit'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    onPressed: () async {
                                      try {
                                        await FirebaseFirestore.instance
                                            .collection(
                                                'finished_order_details')
                                            .doc(order.id)
                                            .delete();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Order deleted successfully!')),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Failed to delete order: $e')),
                                        );
                                      }
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
