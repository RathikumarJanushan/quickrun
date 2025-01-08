import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:quickrun/view/admin/userkmReport/o_details.dart';

class UserKM extends StatefulWidget {
  const UserKM({Key? key}) : super(key: key);

  @override
  _UserKMState createState() => _UserKMState();
}

class _UserKMState extends State<UserKM> {
  String? selectedUserId; // To store the selected user ID
  List<Map<String, dynamic>> users = []; // List of users for the dropdown
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    _loadUsers(); // Load users from Firestore
  }

  Future<void> _loadUsers() async {
    try {
      final userDocs =
          await FirebaseFirestore.instance.collection('usersdetails').get();
      setState(() {
        users = userDocs.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'id': doc.id,
            'name': data['name'] ?? 'Unknown',
          };
        }).toList();
      });
    } catch (e) {
      print('Error loading users: $e');
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          startDate = selectedDate;
        } else {
          endDate = selectedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finished Order Details'),
      ),
      body: Column(
        children: [
          // Date pickers and dropdown for filtering
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context, true),
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: startDate != null
                              ? DateFormat('yyyy-MM-dd').format(startDate!)
                              : 'Select start date',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context, false),
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: endDate != null
                              ? DateFormat('yyyy-MM-dd').format(endDate!)
                              : 'Select end date',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text('Filter by User:'),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedUserId,
                    hint: const Text('Select User'),
                    isExpanded: true,
                    items: users.map((user) {
                      return DropdownMenuItem<String>(
                        value: user['id'],
                        child: Text(user['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedUserId = value;
                      });
                    },
                  ),
                ),
              ],
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

                // Filter orders by userId and date range
                final orders = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final timestamp = (data['timestamp'] as Timestamp).toDate();

                  final isUserMatch = selectedUserId == null ||
                      data['userId'] == selectedUserId;

                  final isWithinDateRange =
                      (startDate == null || timestamp.isAfter(startDate!)) &&
                          (endDate == null || timestamp.isBefore(endDate!));

                  return isUserMatch && isWithinDateRange;
                }).toList();

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
                      final index = entry.key + 1;
                      final order = entry.value;
                      final data = order.data() as Map<String, dynamic>;
                      final restaurantDetails =
                          data['restaurantDetails'] as Map<String, dynamic>?;
                      final timestamp =
                          (data['timestamp'] as Timestamp).toDate().toString();
                      final userId = data['userId'] ?? 'N/A';
                      final totalPathDistance =
                          data['totalPathDistance']?.toString() ?? 'N/A';

                      return DataRow(cells: [
                        DataCell(Text(index.toString())),
                        DataCell(Text(timestamp)),
                        DataCell(
                          FutureBuilder<String>(
                            future: _getUserName(userId),
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
                                      builder: (context) => OFullDetails(
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
                                    backgroundColor: Colors.red),
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('finished_order_details')
                                      .doc(order.id)
                                      .delete();
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

  Future<String> _getUserName(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('usersdetails')
          .doc(userId)
          .get();
      return userDoc.exists
          ? (userDoc.data()?['name'] ?? 'Unknown')
          : 'Unknown';
    } catch (e) {
      return 'Unknown';
    }
  }
}
