// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'dart:math' as math;

// class GoogleMapRoutePage extends StatefulWidget {
//   @override
//   _GoogleMapRoutePageState createState() => _GoogleMapRoutePageState();
// }

// class _GoogleMapRoutePageState extends State<GoogleMapRoutePage> {
//   late GoogleMapController mapController;

//   final LatLng _startLocation = LatLng(9.319984, 80.727467);
//   final LatLng _endLocation = LatLng(9.329172, 80.746282);

//   final List<LatLng> _polylineCoordinates = [];
//   late PolylinePoints polylinePoints;
//   final Set<Polyline> _polylines = {};

//   double _distance = 0.0; // Total distance in kilometers

//   @override
//   void initState() {
//     super.initState();
//     polylinePoints = PolylinePoints();
//     _getPolyline();
//   }

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

// Future<void> _getPolyline() async {
//   const String googleAPIKey = "AIzaSyA2VIqHhmUfHEht98ie7cHLi5tqhAtAsUg";

//   // Create the PolylineRequest with the required parameters
//   PolylineRequest request = PolylineRequest(
//     origin: PointLatLng(_startLocation.latitude, _startLocation.longitude),
//     destination: PointLatLng(_endLocation.latitude, _endLocation.longitude),
//     mode: TravelMode.driving, // Specify travel mode
//     headers: {
//       'X-Goog-Api-Key': googleAPIKey,
//     }, // Pass the API key in headers
//   );

//   // Fetch the polyline points
//   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//     request: request,
//   );

//   if (result.points.isNotEmpty) {
//     _polylineCoordinates.clear();
//     result.points.forEach((PointLatLng point) {
//       _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//     });

//     setState(() {
//       _polylines.add(Polyline(
//         polylineId: PolylineId("route"),
//         color: Colors.blue,
//         width: 5,
//         points: _polylineCoordinates,
//       ));

//       _distance = _calculateDistance(_polylineCoordinates);
//     });
//   } else {
//     print("Error fetching polyline: ${result.errorMessage}");
//   }
// }


//   double _calculateDistance(List<LatLng> coordinates) {
//     double totalDistance = 0.0;

//     for (int i = 0; i < coordinates.length - 1; i++) {
//       totalDistance += _coordinateDistance(
//         coordinates[i].latitude,
//         coordinates[i].longitude,
//         coordinates[i + 1].latitude,
//         coordinates[i + 1].longitude,
//       );
//     }
//     return totalDistance;
//   }

//   double _coordinateDistance(lat1, lon1, lat2, lon2) {
//     const double radius = 6371; // Earth's radius in kilometers

//     final double dLat = _degToRad(lat2 - lat1);
//     final double dLon = _degToRad(lon2 - lon1);

//     final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
//         math.cos(_degToRad(lat1)) *
//             math.cos(_degToRad(lat2)) *
//             math.sin(dLon / 2) *
//             math.sin(dLon / 2);

//     final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
//     return radius * c;
//   }

//   double _degToRad(deg) {
//     return deg * (math.pi / 180);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Route with Distance"),
//       ),
//       body: Stack(
//         children: [
//           GoogleMap(
//             onMapCreated: _onMapCreated,
//             initialCameraPosition: CameraPosition(
//               target: _startLocation,
//               zoom: 14.0,
//             ),
//             markers: {
//               Marker(
//                 markerId: MarkerId("start"),
//                 position: _startLocation,
//                 infoWindow: InfoWindow(title: "Start Location"),
//               ),
//               Marker(
//                 markerId: MarkerId("end"),
//                 position: _endLocation,
//                 infoWindow: InfoWindow(title: "End Location"),
//               ),
//             },
//             polylines: _polylines,
//           ),
//           Positioned(
//             bottom: 20,
//             left: 20,
//             child: Container(
//               padding: EdgeInsets.all(10),
//               color: Colors.white,
//               child: Text(
//                 "Distance: ${_distance.toStringAsFixed(2)} km",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
