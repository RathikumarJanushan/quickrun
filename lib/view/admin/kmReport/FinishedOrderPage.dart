import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  void _pickDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finished Order Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _pickDateRange(context),
          ),
        ],
      ),
      body: Column(
        children: [
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
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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

                // Filter orders based on selected date range and restaurant
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

                return SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('No')),
                      DataColumn(label: Text('Timestamp')),
                      DataColumn(label: Text('User Name')),
                      DataColumn(label: Text('Restaurant')),
                      DataColumn(label: Text('Parcel Names')),
                      DataColumn(label: Text('Total Path Distance')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: orders.asMap().entries.map((entry) {
                      final index = entry.key + 1; // Row number starts from 1
                      final order = entry.value;
                      final data = order.data() as Map<String, dynamic>;
                      final restaurantDetails =
                          data['restaurantDetails'] as Map<String, dynamic>?;
                      final timestamp = data['timestamp'] != null
                          ? (data['timestamp'] as Timestamp).toDate().toString()
                          : 'N/A';
                      final userId = data['userId'] ?? 'N/A';
                      final totalPathDistance =
                          data['totalPathDistance']?.toString() ?? 'N/A';

                      return DataRow(cells: [
                        DataCell(Text(index.toString())), // Row number
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
                        DataCell(
                          Text(restaurantDetails?['name'] ?? 'N/A'),
                        ),
                        DataCell(
                          Text(
                            (data['parcelDetails'] as List<dynamic>?)
                                    ?.map((parcel) => parcel['name'])
                                    .join(', ') ??
                                'No parcel names',
                          ),
                        ),
                        DataCell(Text(totalPathDistance)),
                        DataCell(
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OrderDetailsPage(
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
                                        .collection('finished_order_details')
                                        .doc(order.id)
                                        .delete();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Order deleted successfully!')),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
