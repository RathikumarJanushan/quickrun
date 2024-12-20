// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;

// class FinalConfirmationPage extends StatefulWidget {
//   final String userId;
//   final Map<String, dynamic>? restaurant;
//   final List<Map<String, dynamic>> parcels;

//   const FinalConfirmationPage({
//     Key? key,
//     required this.userId,
//     required this.restaurant,
//     required this.parcels,
//   }) : super(key: key);

//   @override
//   _FinalConfirmationPageState createState() => _FinalConfirmationPageState();
// }

// class _FinalConfirmationPageState extends State<FinalConfirmationPage> {
//   final Set<Marker> markers = {};
//   final Set<Polyline> polylines = {};
//   double totalDistance = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     _initializeMarkersAndRoute();
//   }

//   // Function to fetch directions from Google Directions API
//   Future<void> _fetchRoute(LatLng start, LatLng end) async {
//     const String apiKey =
//         'AIzaSyA2VIqHhmUfHEht98ie7cHLi5tqhAtAsUg'; // Your API key
//     final String url =
//         'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$apiKey';

//     final response = await http.get(Uri.parse(url));

//     // Print the response body to debug
//     print('Response: ${response.body}');

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data['status'] == 'OK') {
//         final route = data['routes'][0]['legs'][0];
//         final List<LatLng> polylinePoints =
//             _decodePolyline(route['overview_polyline']['points']);
//         final double distanceInKm =
//             route['distance']['value'] / 1000; // Convert meters to kilometers

//         setState(() {
//           polylines.add(Polyline(
//             polylineId: const PolylineId('route'),
//             points: polylinePoints,
//             color: Colors.blue,
//             width: 4,
//           ));
//           totalDistance = distanceInKm;
//         });
//       } else {
//         print('API Error: ${data['status']}');
//       }
//     } else {
//       print('Failed to load directions, status: ${response.statusCode}');
//     }
//   }

//   // Decode polyline points into LatLng list
//   List<LatLng> _decodePolyline(String polyline) {
//     List<LatLng> points = [];
//     int index = 0;
//     int len = polyline.length;
//     int lat = 0;
//     int lng = 0;
//     while (index < len) {
//       int b, shift = 0, result = 0;
//       do {
//         b = polyline.codeUnitAt(index) - 63;
//         result |= (b & 0x1f) << shift;
//         shift += 5;
//         index++;
//       } while (b >= 0x20);
//       int dlat = (result & 0x1) != 0 ? ~(result >> 1) : (result >> 1);
//       lat += dlat;

//       shift = 0;
//       result = 0;
//       do {
//         b = polyline.codeUnitAt(index) - 63;
//         result |= (b & 0x1f) << shift;
//         shift += 5;
//         index++;
//       } while (b >= 0x20);
//       int dlng = (result & 0x1) != 0 ? ~(result >> 1) : (result >> 1);
//       lng += dlng;

//       points.add(LatLng(lat / 1E5, lng / 1E5));
//     }
//     return points;
//   }

//   void _initializeMarkersAndRoute() {
//     final List<LatLng> routePoints = [];

//     // Add restaurant marker and starting point for the route
//     if (widget.restaurant != null &&
//         widget.restaurant!['coordinates'] != null) {
//       final coordinates = widget.restaurant!['coordinates'];
//       if (coordinates != null &&
//           coordinates['latitude'] != null &&
//           coordinates['longitude'] != null) {
//         final restaurantLatLng = LatLng(
//           coordinates['latitude'],
//           coordinates['longitude'],
//         );
//         markers.add(
//           Marker(
//             markerId: const MarkerId('restaurant'),
//             position: restaurantLatLng,
//             infoWindow: InfoWindow(title: widget.restaurant!['name']),
//           ),
//         );
//         routePoints.add(restaurantLatLng);
//       }
//     }

//     // Add parcel markers
//     for (var parcel in widget.parcels) {
//       if (parcel['coordinates'] != null) {
//         final parcelLatLng = LatLng(
//           parcel['coordinates']['latitude'],
//           parcel['coordinates']['longitude'],
//         );
//         markers.add(
//           Marker(
//             markerId: MarkerId('parcel_${parcel['name']}'),
//             position: parcelLatLng,
//             infoWindow: InfoWindow(title: parcel['name']),
//           ),
//         );
//         routePoints.add(parcelLatLng);
//       }
//     }

//     // Get directions between the restaurant and the first parcel (or other selected locations)
//     if (routePoints.isNotEmpty && routePoints.length > 1) {
//       _fetchRoute(routePoints.first, routePoints[1]);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Final Confirmation'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 2,
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // User ID
//                   Text(
//                     'User ID: ${widget.userId}',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // Restaurant Details
//                   if (widget.restaurant != null) ...[
//                     Text(
//                       'Restaurant: ${widget.restaurant!['name']}',
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     Text(
//                       'Coordinates: Lat ${widget.restaurant!['coordinates']['latitude']}, '
//                       'Long ${widget.restaurant!['coordinates']['longitude']}',
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(height: 16),
//                   ],

//                   // Parcel Details
//                   const Text(
//                     'Parcels:',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   for (var parcel in widget.parcels) ...[
//                     const Divider(),
//                     Text(
//                       'Parcel: ${parcel['name']}',
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     Text(
//                       'Coordinates: Lat ${parcel['coordinates']['latitude']}, '
//                       'Long ${parcel['coordinates']['longitude']}',
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(height: 8),
//                   ],

//                   // Total Distance
//                   const Divider(),
//                   Text(
//                     'Total Distance: ${totalDistance.toStringAsFixed(2)} km',
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const Divider(),

//           // Google Map
//           Expanded(
//             flex: 3,
//             child: GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: widget.restaurant != null
//                     ? LatLng(
//                         widget.restaurant!['coordinates']['latitude'],
//                         widget.restaurant!['coordinates']['longitude'],
//                       )
//                     : const LatLng(
//                         0, 0), // Default location if restaurant is null
//                 zoom: 12.0,
//               ),
//               markers: markers,
//               polylines: polylines,
//               myLocationEnabled: true,
//               myLocationButtonEnabled: true,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
