import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiveOrderDetailsPage extends StatelessWidget {
  const LiveOrderDetailsPage({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Order Details'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('live_order_details')
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

          final orders = snapshot.data!.docs;

          return SingleChildScrollView(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Order ID')),
                DataColumn(label: Text('User Name')),
                DataColumn(label: Text('Restaurant & Parcel Names')),
                DataColumn(label: Text('Timestamp')),
                DataColumn(label: Text('Actions')),
              ],
              rows: orders.map((order) {
                final data = order.data() as Map<String, dynamic>;
                final restaurantDetails =
                    data['restaurantDetails'] as Map<String, dynamic>?;
                final timestamp = data['timestamp'] != null
                    ? (data['timestamp'] as Timestamp).toDate().toString()
                    : 'N/A';
                final userId = data['userId'] ?? 'N/A';

                return DataRow(cells: [
                  DataCell(Text(order.id)),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(restaurantDetails?['name'] ?? 'N/A'),
                        Text(
                          (data['parcelDetails'] as List<dynamic>?)
                                  ?.map((parcel) => parcel['name'])
                                  .join(', ') ??
                              'No parcel names',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  DataCell(Text(timestamp)),
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
                              backgroundColor: Colors.red),
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('live_order_details')
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
    );
  }
}

class OrderDetailsPage extends StatelessWidget {
  final String orderId;
  final Map<String, dynamic> orderData;

  const OrderDetailsPage({
    Key? key,
    required this.orderId,
    required this.orderData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final restaurantDetails =
        orderData['restaurantDetails'] as Map<String, dynamic>?;
    final parcelDetails = orderData['parcelDetails'] as List<dynamic>?;

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details: $orderId'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Restaurant Details:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (restaurantDetails != null) ...[
                Text('Name: ${restaurantDetails['name']}'),
                Text('Address: ${restaurantDetails['address']}'),
                Text('Postal Code: ${restaurantDetails['postal_code']}'),
                Text(
                    'Coordinates: Lat ${restaurantDetails['latitude']}, Long ${restaurantDetails['longitude']}'),
              ] else ...[
                const Text('No restaurant details available.'),
              ],
              const SizedBox(height: 16),
              const Text(
                'Parcel Details:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (parcelDetails != null && parcelDetails.isNotEmpty)
                ...parcelDetails.map((parcel) {
                  final parcelMap = parcel as Map<String, dynamic>;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${parcelMap['name']}'),
                      Text('Mobile Number: ${parcelMap['mobile_number']}'),
                      Text('Address: ${parcelMap['address']}'),
                      Text('Postal Code: ${parcelMap['postal_code']}'),
                      Text('Payment Method: ${parcelMap['payment_method']}'),
                      Text('Cash Amount: ${parcelMap['cash_amount']}'),
                      Text('Status: ${parcelMap['status']}'),
                      Text(
                          'Coordinates: Lat ${parcelMap['latitude']}, Long ${parcelMap['longitude']}'),
                      const Divider(),
                    ],
                  );
                }).toList()
              else
                const Text('No parcel details available.'),
            ],
          ),
        ),
      ),
    );
  }
}
