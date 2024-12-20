import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For formatting dates
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class UserKm extends StatefulWidget {
  const UserKm({Key? key}) : super(key: key);

  @override
  State<UserKm> createState() => _UserKmState();
}

class _UserKmState extends State<UserKm> {
  String? selectedUserId;
  DateTime? selectedDate;
  List<String> userIds = [];
  Map<String, String> userIdToNameMap = {};
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('usersdetails').get();

    setState(() {
      userIdToNameMap = {
        for (var doc in snapshot.docs)
          doc['userId']?.toString() ?? 'Unknown':
              doc['name']?.toString() ?? 'Unknown'
      };
      userIds = userIdToNameMap.keys.toList();
    });
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _generatePdf(
      List<Map<String, dynamic>> orders, double totalDistance) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'User KM Report',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 16),
            pw.Text('User: ${userIdToNameMap[selectedUserId] ?? "Unknown"}'),
            pw.Text(
              'Date: ${DateFormat.yMMMd().format(selectedDate!)}',
            ),
            pw.SizedBox(height: 16),
            pw.Text(
              'Total Distance: ${totalDistance.toStringAsFixed(2)} km',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 16),
            pw.Table.fromTextArray(
              headers: [
                'NO',
                'Restaurant',
                'Parcels',
                'Timestamp',
                'Total Distance'
              ],
              data: List<List<String>>.generate(
                orders.length,
                (index) {
                  final order = orders[index];
                  return [
                    '${index + 1}',
                    order['restaurant'] ?? 'Unknown',
                    order['parcels'] ?? 'None',
                    order['timestamp'] ?? 'N/A',
                    '${order['totalDistance']} km'
                  ];
                },
              ),
            ),
          ],
        ),
      ),
    );

    await Printing.sharePdf(
        bytes: await pdf.save(), filename: 'User_KM_Report.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User KM'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedUserId,
              hint: const Text('Select User'),
              isExpanded: true,
              items: userIds
                  .map((userId) => DropdownMenuItem(
                        value: userId,
                        child: Text(userIdToNameMap[userId] ?? 'Unknown'),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedUserId = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  selectedDate != null
                      ? 'Selected Date: ${DateFormat.yMMMd().format(selectedDate!)}'
                      : 'Select a Date',
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _pickDate,
                  child: const Text('Pick a Date'),
                ),
              ],
            ),
          ),
          if (selectedUserId != null && selectedDate != null)
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
                      child: Text(
                        'No data available.',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  final orders = snapshot.data!.docs.where((doc) {
                    final orderData = doc.data() as Map<String, dynamic>;
                    final timestamp = orderData['timestamp']?.toDate();
                    final isSameDate = timestamp != null &&
                        selectedDate != null &&
                        timestamp.year == selectedDate!.year &&
                        timestamp.month == selectedDate!.month &&
                        timestamp.day == selectedDate!.day;

                    return orderData['userId'] == selectedUserId && isSameDate;
                  }).toList();

                  if (orders.isEmpty) {
                    return const Center(
                      child: Text(
                        'No orders for this User and Date.',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  final totalDistance = orders.fold<double>(0.0, (sum, doc) {
                    final orderData = doc.data() as Map<String, dynamic>;
                    return sum +
                        (orderData['totalDistance']?.toDouble() ?? 0.0);
                  });

                  final orderDetails = orders.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return {
                      'restaurant': data['restaurant']?['name'] ?? 'Unknown',
                      'parcels': (data['parcels'] as List<dynamic>?)
                              ?.map((parcel) =>
                                  (parcel as Map<String, dynamic>)['name'] ??
                                  'Unknown')
                              .join(', ') ??
                          'None',
                      'timestamp': data['timestamp'] != null
                          ? DateFormat.yMMMd()
                              .add_jm()
                              .format(data['timestamp'].toDate())
                          : 'N/A',
                      'totalDistance':
                          '${data['totalDistance']?.toDouble().toStringAsFixed(2) ?? "0.00"} km',
                    };
                  }).toList();

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'Total Distance: ${totalDistance.toStringAsFixed(2)} km',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () =>
                                  _generatePdf(orderDetails, totalDistance),
                              child: const Text('Download PDF'),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Scrollbar(
                          controller: _verticalScrollController,
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            controller: _verticalScrollController,
                            child: SingleChildScrollView(
                              controller: _horizontalScrollController,
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columns: const [
                                  DataColumn(label: Text('NO')),
                                  DataColumn(label: Text('Restaurant')),
                                  DataColumn(label: Text('Parcels')),
                                  DataColumn(label: Text('Timestamp')),
                                  DataColumn(label: Text('Total Distance')),
                                ],
                                rows: List<DataRow>.generate(
                                  orders.length,
                                  (index) {
                                    final order = orderDetails[index];
                                    return DataRow(
                                      cells: [
                                        DataCell(Text('${index + 1}')),
                                        DataCell(Text(order['restaurant'])),
                                        DataCell(Text(order['parcels'])),
                                        DataCell(Text(order['timestamp'])),
                                        DataCell(Text(order['totalDistance'])),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
