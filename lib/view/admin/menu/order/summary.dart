// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:quickrun/view/admin/menu/adminhome_screen.dart';
// import 'package:quickrun/view/admin/menu/order/final_confomation.dart';
// import 'package:http/http.dart' as http;

// class SummaryPage extends StatelessWidget {
//   final String userId;
//   final Map<String, dynamic>? selectedRestaurant;
//   final List<Map<String, String>> parcels;

//   const SummaryPage({
//     Key? key,
//     required this.userId,
//     this.selectedRestaurant,
//     required this.parcels,
//   }) : super(key: key);

//   Future<Map<String, double>?> _getCoordinates(String address) async {
//     const String apiKey =
//         'AIzaSyA2VIqHhmUfHEht98ie7cHLi5tqhAtAsUg'; // Replace with your API key
//     final String url =
//         'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$apiKey';

//     try {
//       final response = await http.get(Uri.parse(url));
//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.body}');

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['status'] == 'OK') {
//           final location = data['results'][0]['geometry']['location'];
//           return {
//             'latitude': location['lat'],
//             'longitude': location['lng'],
//           };
//         } else {
//           print('Geocoding API error: ${data['status']}');
//         }
//       }
//     } catch (e) {
//       print('Error getting coordinates: $e');
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Summary'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // User ID
//               Text(
//                 'User ID: $userId',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // Restaurant Details
//               if (selectedRestaurant != null) ...[
//                 FutureBuilder<Map<String, double>?>(
//                   // Restaurant coordinates
//                   future: _getCoordinates(
//                     '${selectedRestaurant!['postal_code']}, ${selectedRestaurant!['address']}',
//                   ),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const CircularProgressIndicator();
//                     } else if (snapshot.hasError || snapshot.data == null) {
//                       return const Text('Error fetching coordinates');
//                     }

//                     final coords = snapshot.data!;
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Restaurant: ${selectedRestaurant!['name']}',
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                         Text(
//                           'Address: ${selectedRestaurant!['postal_code']}, ${selectedRestaurant!['address']}',
//                           style: const TextStyle(fontSize: 16),
//                         ),
//                         Text(
//                           'Coordinates: Lat ${coords['latitude']}, Long ${coords['longitude']}',
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                       ],
//                     );
//                   },
//                 ),
//               ],

//               // Parcel Names
//               const Text(
//                 'Parcels:',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               for (int i = 0; i < parcels.length; i++)
//                 Text(
//                   '${i + 1}. parcel - ${parcels[i]['name']}',
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               const SizedBox(height: 24),

//               // Delivery Parcel Details
//               const Text(
//                 'Delivery Parcels:',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               for (var parcel in parcels) ...[
//                 const Divider(),
//                 Text(
//                   'Parcel: ${parcel['name']}',
//                   style: const TextStyle(fontSize: 16),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Address: ${parcel['postal_code']}, ${parcel['address']}',
//                   style: const TextStyle(fontSize: 16),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Mobile Number: ${parcel['mobile_number']}',
//                   style: const TextStyle(fontSize: 16),
//                 ),
//                 const SizedBox(height: 8),
//                 FutureBuilder<Map<String, double>?>(
//                   // Parcel coordinates
//                   future: _getCoordinates(
//                     '${parcel['postal_code']}, ${parcel['address']}',
//                   ),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const CircularProgressIndicator();
//                     } else if (snapshot.hasError || snapshot.data == null) {
//                       return const Text('Error fetching coordinates');
//                     }

//                     final coords = snapshot.data!;
//                     return Text(
//                       'Coordinates: Lat ${coords['latitude']}, Long ${coords['longitude']}',
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 16),
//               ],

//               // Order Button
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     try {
//                       // Get restaurant coordinates
//                       Map<String, double>? restaurantCoords;
//                       if (selectedRestaurant != null) {
//                         restaurantCoords = await _getCoordinates(
//                           '${selectedRestaurant!['postal_code']}, ${selectedRestaurant!['address']}',
//                         );
//                       }

//                       // Get parcel coordinates
//                       List<Map<String, dynamic>> resolvedParcels = [];
//                       for (var parcel in parcels) {
//                         Map<String, double>? parcelCoords =
//                             await _getCoordinates(
//                           '${parcel['postal_code']}, ${parcel['address']}',
//                         );
//                         resolvedParcels.add({
//                           'name': parcel['name'],
//                           'address': parcel['address'],
//                           'postal_code': parcel['postal_code'],
//                           'mobile_number': parcel['mobile_number'],
//                           'coordinates': parcelCoords,
//                           'status': 'pending',
//                         });
//                       }

//                       // Create the order data
//                       final orderData = {
//                         'userId': userId,
//                         'restaurant': selectedRestaurant != null
//                             ? {
//                                 'name': selectedRestaurant!['name'],
//                                 'address': selectedRestaurant!['address'],
//                                 'coordinates': restaurantCoords,
//                                 'status': 'pending',
//                               }
//                             : null,
//                         'parcels': resolvedParcels,
//                         'timestamp': FieldValue.serverTimestamp(),
//                       };

//                       // Save to Firestore
//                       final docRef = await FirebaseFirestore.instance
//                           .collection('live_order_details')
//                           .add(orderData);

//                       // Update the user's status to "busy" in the `available` collection
//                       await FirebaseFirestore.instance
//                           .collection('available')
//                           .doc(userId)
//                           .update({'available': 'busy'});

//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               AdminhomeScreen(), // Replace with your AdminPage widget
//                         ),
//                       );

//                       // Navigate to Final Confirmation Page
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(
//                       //     builder: (context) => FinalConfirmationPage(
//                       //       userId: userId,
//                       //       restaurant: selectedRestaurant != null
//                       //           ? {
//                       //               'name': selectedRestaurant!['name'],
//                       //               'coordinates': restaurantCoords,
//                       //             }
//                       //           : null,
//                       //       parcels: resolvedParcels,
//                       //     ),
//                       //   ),
//                       // );
//                     } catch (e) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Error: $e')),
//                       );
//                     }
//                   },
//                   child: const Text('Place Order'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
