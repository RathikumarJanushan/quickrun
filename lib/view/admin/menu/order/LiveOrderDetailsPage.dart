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
      if (userDoc.exists) {
        return userDoc.data()?['name'] ?? 'Unknown';
      } else {
        return 'Unknown';
      }
    } catch (e) {
      return 'Error fetching name';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Order Details'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
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
                child: Text(
                  'No live orders available.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            final orders = snapshot.data!.docs;

            final pendingOrders = orders.where((doc) {
              final restaurant =
                  (doc.data() as Map<String, dynamic>)['restaurant'];
              return restaurant != null && restaurant['status'] == 'pending';
            }).toList();

            final okOrders = orders.where((doc) {
              final restaurant =
                  (doc.data() as Map<String, dynamic>)['restaurant'];
              return restaurant != null && restaurant['status'] == 'ok';
            }).toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (pendingOrders.isNotEmpty) ...[
                    const Text(
                      'Pending Orders',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildOrderGrid(context, pendingOrders),
                  ],
                  if (okOrders.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    const Text(
                      'Completed Orders',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildOrderGrid(context, okOrders),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderGrid(
      BuildContext context, List<QueryDocumentSnapshot> orders) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 3 / 2,
      ),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final orderData = orders[index].data() as Map<String, dynamic>;
        orderData['id'] = orders[index].id; // Add Firestore document ID
        return _buildOrderCard(context, orderData);
      },
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> orderData) {
    final userId = orderData['userId'];
    final restaurant = orderData['restaurant'] ?? {};
    final parcels = orderData['parcels'] as List<dynamic>? ?? [];
    final timestamp = (orderData['timestamp'] as Timestamp?)?.toDate();

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder<String>(
                  future: _getUserName(userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                        'Fetching user...',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      );
                    }
                    return Text(
                      snapshot.data ?? 'Unknown User',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
                GestureDetector(
                  onTap: () {
                    _confirmDelete(context, orderData['id']);
                  },
                  child: const Icon(Icons.delete, color: Colors.red, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Restaurant: ${restaurant['name'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 4),
            Text(
              'Status: ${restaurant['status'] ?? 'N/A'}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: restaurant['status'] == 'pending'
                    ? Colors.orange
                    : Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            if (timestamp != null)
              Text(
                'Placed: ${timestamp.toLocal()}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            const Divider(),
            const Text(
              'Parcels:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            for (var parcel in parcels)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${parcel['name'] ?? 'N/A'}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Address: ${parcel['address'] ?? 'N/A'}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Postal Code: ${parcel['postal_code'] ?? 'N/A'}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Mobile: ${parcel['mobile_number'] ?? 'N/A'}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    if (parcel['coordinates'] != null)
                      Text(
                        'Coordinates: ${parcel['coordinates']['latitude']}, ${parcel['coordinates']['longitude']}',
                        style: const TextStyle(fontSize: 12),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Order'),
          content: const Text('Are you sure you want to delete this order?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteOrder(context, orderId);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteOrder(BuildContext context, String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('live_order_details')
          .doc(orderId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete order: $e')),
      );
    }
  }
}
