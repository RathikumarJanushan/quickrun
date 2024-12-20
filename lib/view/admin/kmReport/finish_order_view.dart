import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

class FinishedOrdersPage extends StatefulWidget {
  final String selectedMonth;
  final String selectedRestaurant;

  const FinishedOrdersPage({
    Key? key,
    required this.selectedMonth,
    required this.selectedRestaurant,
    DateTime? selectedDate,
  }) : super(key: key);

  @override
  State<FinishedOrdersPage> createState() => _FinishedOrdersPageState();
}

class _FinishedOrdersPageState extends State<FinishedOrdersPage> {
  DateTime? selectedDate;

  Future<void> generatePDF(List<QueryDocumentSnapshot> orders) async {
    final pdf = pw.Document();

    // Calculate the total distance
    double totalDistance = orders.fold(0.0, (sum, order) {
      final orderData = order.data() as Map<String, dynamic>;
      return sum + (orderData['totalDistance'] as num? ?? 0).toDouble();
    });

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header row: Finished Orders + Total Distance
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Finished Orders for ${widget.selectedRestaurant} (${widget.selectedMonth})',
                      style: pw.TextStyle(
                          fontSize: 18, fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Total Distance: ${totalDistance.toStringAsFixed(2)} x 2 = ${(totalDistance * 2).toStringAsFixed(2)} km',
                      style: pw.TextStyle(fontSize: 14),
                    ),
                  ],
                ),

                pw.SizedBox(height: 10),
                if (selectedDate != null)
                  pw.Text(
                    'Date: ${DateFormat.yMMMd().format(selectedDate!)}',
                    style: pw.TextStyle(fontSize: 14),
                  ),
                pw.SizedBox(height: 10),
              ],
            ),
            pw.Table.fromTextArray(
              headers: ['Order ID', 'Parcels', 'Timestamp', 'Total Distance'],
              data: orders.map((order) {
                final orderData = order.data() as Map<String, dynamic>;
                final orderId = order.id;
                final timestamp = orderData['timestamp']?.toDate();
                final parcels = orderData['parcels'] as List<dynamic>? ?? [];
                final parcelNames = parcels
                    .map((parcel) =>
                        (parcel as Map<String, dynamic>?)?['name'] ?? 'Unknown')
                    .join(', ');
                final totalDistance =
                    (orderData['totalDistance'] as num?)?.toDouble() ?? 0.0;

                return [
                  orderId,
                  parcelNames,
                  timestamp != null
                      ? DateFormat.yMMMd().add_jm().format(timestamp)
                      : 'N/A',
                  '${totalDistance.toStringAsFixed(2)} km',
                ];
              }).toList(),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  Future<void> _deleteOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('finished_order_details')
          .doc(orderId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order deleted successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete order.')),
      );
    }
  }

  Future<void> _editOrder(
      String orderId, Map<String, dynamic> orderData) async {
    final TextEditingController timestampController = TextEditingController(
      text: orderData['timestamp'] != null
          ? DateFormat.yMMMd().add_jm().format(orderData['timestamp'].toDate())
          : '',
    );

    final TextEditingController totalDistanceController =
        TextEditingController(text: '${orderData['totalDistance'] ?? 0.0}');

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Order'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: timestampController,
                decoration: const InputDecoration(labelText: 'Timestamp'),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      final combined = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                      timestampController.text =
                          DateFormat.yMMMd().add_jm().format(combined);
                    }
                  }
                },
              ),
              TextField(
                controller: totalDistanceController,
                decoration:
                    const InputDecoration(labelText: 'Total Distance (km)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final updatedTimestamp =
                    DateFormat.yMMMd().add_jm().parse(timestampController.text);
                final updatedDistance =
                    double.tryParse(totalDistanceController.text) ?? 0.0;

                try {
                  await FirebaseFirestore.instance
                      .collection('finished_order_details')
                      .doc(orderId)
                      .update({
                    'timestamp': Timestamp.fromDate(updatedTimestamp),
                    'totalDistance': updatedDistance,
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Order updated successfully.')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to update order.')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finished Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: selectDate,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              final snapshot = await FirebaseFirestore.instance
                  .collection('finished_order_details')
                  .orderBy('timestamp', descending: true)
                  .get();

              final filteredOrders = snapshot.docs.where((doc) {
                final timestamp = doc['timestamp']?.toDate();
                final month = timestamp != null
                    ? DateFormat.MMMM().format(timestamp)
                    : null;
                final restaurant =
                    (doc['restaurant'] as Map<String, dynamic>?)?['name'];

                final isMatchingMonthAndRestaurant =
                    month == widget.selectedMonth &&
                        restaurant == widget.selectedRestaurant;

                if (selectedDate != null) {
                  return isMatchingMonthAndRestaurant &&
                      timestamp != null &&
                      DateFormat.yMMMd().format(timestamp) ==
                          DateFormat.yMMMd().format(selectedDate!);
                }

                return isMatchingMonthAndRestaurant;
              }).toList();

              if (filteredOrders.isNotEmpty) {
                await generatePDF(filteredOrders);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No orders to download as PDF.'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
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
              child: Text(
                'No finished orders.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final orders = snapshot.data!.docs.where((doc) {
            final timestamp = doc['timestamp']?.toDate();
            final month =
                timestamp != null ? DateFormat.MMMM().format(timestamp) : null;
            final restaurant =
                (doc['restaurant'] as Map<String, dynamic>?)?['name'];

            final isMatchingMonthAndRestaurant =
                month == widget.selectedMonth &&
                    restaurant == widget.selectedRestaurant;

            if (selectedDate != null) {
              return isMatchingMonthAndRestaurant &&
                  timestamp != null &&
                  DateFormat.yMMMd().format(timestamp) ==
                      DateFormat.yMMMd().format(selectedDate!);
            }

            return isMatchingMonthAndRestaurant;
          }).toList();

          double totalDistance = orders.fold(0.0, (sum, order) {
            final orderData = order.data() as Map<String, dynamic>;
            return sum + (orderData['totalDistance'] as num? ?? 0).toDouble();
          });

          if (orders.isEmpty) {
            return const Center(
              child: Text(
                'No orders found for the selected filters.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Total Distance: ${totalDistance.toStringAsFixed(2)} km',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      // Inside the DataTable widget
                      columns: const [
                        DataColumn(label: Text('Order ID')),
                        DataColumn(label: Text('Parcels (Name)')),
                        DataColumn(label: Text('Timestamp')),
                        DataColumn(label: Text('Total Distance')),
                        DataColumn(
                            label: Text('Actions')), // New column for actions
                      ],
                      rows: orders.map((order) {
                        final orderData = order.data() as Map<String, dynamic>;
                        final orderId = order.id;
                        final timestamp = orderData['timestamp']?.toDate();
                        final totalDistance =
                            (orderData['totalDistance'] as num? ?? 0)
                                .toDouble();
                        final parcels =
                            orderData['parcels'] as List<dynamic>? ?? [];
                        final parcelNames = parcels
                            .map((parcel) =>
                                (parcel as Map<String, dynamic>?)?['name'] ??
                                'Unknown')
                            .join(', ');

                        return DataRow(cells: [
                          DataCell(Text(orderId)),
                          DataCell(Text(parcelNames.isNotEmpty
                              ? parcelNames
                              : 'No parcels')),
                          DataCell(Text(timestamp != null
                              ? DateFormat.yMMMd().add_jm().format(timestamp)
                              : 'N/A')),
                          DataCell(
                              Text('${totalDistance.toStringAsFixed(2)} km')),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () async {
                                    await _editOrder(order.id, orderData);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () async {
                                    await _deleteOrder(order.id);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
