// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class FinishedOrdersPage extends StatelessWidget {
//   const FinishedOrdersPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Finished Orders'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance
//             .collection('finished_order_details')
//             .orderBy('timestamp', descending: true)
//             .snapshots(),
//         builder: (context, snapshot) {
//           // Display loading indicator while waiting for data
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           // Handle case where there are no finished orders
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return const Center(
//               child: Text(
//                 'No finished orders.',
//                 style: TextStyle(fontSize: 18),
//               ),
//             );
//           }

//           final orders = snapshot.data!.docs;

//           // Build a list of orders
//           return ListView.builder(
//             itemCount: orders.length,
//             itemBuilder: (context, index) {
//               final orderData = orders[index].data() as Map<String, dynamic>;
//               final orderId = orders[index].id;
//               final userId = orderData['userId'] ?? 'Unknown'; // Fetch userId
//               final timestamp = orderData['timestamp']?.toDate();
//               final totalDistance =
//                   orderData['totalDistance']?.toDouble() ?? 0.0;
//               final parcels = orderData['parcels'] as List<dynamic>? ?? [];
//               final restaurant =
//                   orderData['restaurant'] as Map<String, dynamic>?;

//               return Card(
//                 margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Order ID: $orderId',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'User ID: $userId', // Display the userId
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Total Distance: ${totalDistance.toStringAsFixed(2)} km',
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                       const SizedBox(height: 8),
//                       if (restaurant != null) ...[
//                         Text(
//                           'Restaurant: ${restaurant['name']}',
//                           style: const TextStyle(fontSize: 14),
//                         ),
//                         Text(
//                           'Address: ${restaurant['address']}',
//                           style: const TextStyle(fontSize: 14),
//                         ),
//                         Text(
//                           'Coordinates: ${restaurant['coordinates']}',
//                           style: const TextStyle(fontSize: 14),
//                         ),
//                       ],
//                       const SizedBox(height: 12),
//                       const Text(
//                         'Parcels:',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       ...parcels.map((parcel) {
//                         final parcelMap = parcel as Map<String, dynamic>;
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('Name: ${parcelMap['name']}'),
//                             Text('Address: ${parcelMap['address']}'),
//                             Text('Postal Code: ${parcelMap['postal_code']}'),
//                             Text(
//                                 'Mobile Number: ${parcelMap['mobile_number']}'),
//                             Text('Coordinates: ${parcelMap['coordinates']}'),
//                             Text('Status: ${parcelMap['status']}'),
//                             const Divider(),
//                           ],
//                         );
//                       }).toList(),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Timestamp: ${timestamp != null ? timestamp.toString() : 'N/A'}',
//                         style: const TextStyle(fontSize: 14),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
