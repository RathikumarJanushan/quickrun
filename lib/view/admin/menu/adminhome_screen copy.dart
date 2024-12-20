// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:quickrun/auth/auth_service.dart';
// import 'package:quickrun/common/color_extension.dart';
// import 'package:quickrun/view/wellcomeview/welcome_view.dart';
// import 'package:quickrun/widgets/button.dart';
// import 'package:quickrun/view/admin/menu/order/addorder.dart';
// import 'menu.dart';

// class AdminhomeScreen extends StatefulWidget {
//   const AdminhomeScreen({Key? key}) : super(key: key);

//   @override
//   _AdminhomeScreenState createState() => _AdminhomeScreenState();
// }

// class _AdminhomeScreenState extends State<AdminhomeScreen> {
//   final AuthService auth = AuthService();
//   final Map<MarkerId, Marker> _markers = {};
//   final Map<String, List<Map<String, String>>> _usersByStatus = {
//     'end': [],
//     'start': [],
//     'busy': []
//   };

//   @override
//   void initState() {
//     super.initState();
//     _loadUserLocations();
//   }

//   // Load user locations and update markers and user lists
//   void _loadUserLocations() {
//     FirebaseFirestore.instance
//         .collection('user_locations')
//         .snapshots()
//         .listen((snapshot) async {
//       _usersByStatus['end']?.clear();
//       _usersByStatus['start']?.clear();
//       _usersByStatus['busy']?.clear();

//       for (var doc in snapshot.docs) {
//         final userId = doc['userId'];
//         final latitude = doc['latitude'];
//         final longitude = doc['longitude'];

//         // Fetch the user's name from the `userdetails` collection
//         final userDetailsDoc = await FirebaseFirestore.instance
//             .collection('usersdetails')
//             .doc(userId)
//             .get();
//         final userName =
//             userDetailsDoc.exists ? userDetailsDoc['name'] : 'Unknown';

//         FirebaseFirestore.instance
//             .collection('available')
//             .doc(userId)
//             .snapshots()
//             .listen((availableSnapshot) async {
//           String availableStatus = 'end'; // Default status
//           if (availableSnapshot.exists) {
//             availableStatus = availableSnapshot['available'] ?? 'end';
//           }

//           // Categorize users by availability status
//           _usersByStatus[availableStatus]?.add({
//             'userId': userId,
//             'userName': userName,
//           });

//           // Get the updated marker icon
//           BitmapDescriptor markerIcon = await _getMarkerIcon(availableStatus);

//           final markerId = MarkerId(userId);

//           // Update or add marker
//           final newMarker = Marker(
//             markerId: markerId,
//             position: LatLng(latitude, longitude),
//             infoWindow: InfoWindow(
//               title: "User: $userName ($userId)",
//               onTap: () {
//                 // Navigate to AddOrder page
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => AddOrder(userId: userId),
//                   ),
//                 );
//               },
//             ),
//             icon: markerIcon,
//           );
//           setState(() {
//             _markers[markerId] = newMarker;
//           });
//         });
//       }
//     });
//   }

//   Future<BitmapDescriptor> _getMarkerIcon(String availableStatus) async {
//     String assetPath = 'assets/img/end.png'; // Default icon

//     if (availableStatus == 'start') {
//       assetPath = 'assets/img/start.png';
//     } else if (availableStatus == 'busy') {
//       assetPath = 'assets/img/busy.png';
//     }

//     return await BitmapDescriptor.fromAssetImage(
//       const ImageConfiguration(size: Size(48, 48)),
//       assetPath,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: TColor.background,
//       appBar: AppBar(title: const Text('Admin')),
//       drawer: MenuDrawer(auth: auth),
//       body: Row(
//         children: [
//           // Left side: User statuses
//           Expanded(
//             flex: 1, // Takes 1/3 of the screen
//             child: Container(
//               padding: const EdgeInsets.all(8.0),
//               color: Colors.grey[200],
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Available Users',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   ...['end', 'start', 'busy'].map((status) {
//                     return Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             status.toUpperCase(),
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           ..._usersByStatus[status]!.map((user) {
//                             return Text(
//                               '${user['userName']} (${user['userId']})',
//                               style: const TextStyle(fontSize: 14),
//                             );
//                           }).toList(),
//                           const Divider(),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 ],
//               ),
//             ),
//           ),

//           // Right side: Google Map
//           Expanded(
//             flex: 2, // Takes 2/3 of the screen
//             child: GoogleMap(
//               initialCameraPosition: const CameraPosition(
//                 target: LatLng(46.9495084, 7.440615),
//                 zoom: 10,
//               ),
//               onMapCreated: (GoogleMapController controller) {},
//               markers: Set<Marker>.of(_markers.values),
//               mapType: MapType.normal,
//               myLocationEnabled: true,
//               myLocationButtonEnabled: true,
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () async {
//           await auth.signout();
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => WelcomeView()),
//           );
//         },
//         label: const Text('Sign Out'),
//         icon: const Icon(Icons.logout),
//       ),
//     );
//   }
// }
