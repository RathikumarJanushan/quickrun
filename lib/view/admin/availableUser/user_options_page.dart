// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:quickrun/view/admin/oderpage.dart';
// import 'package:quickrun/view/admin/brakeUser.dart';
// import 'package:quickrun/view/admin/cal2.dart';

// class UserOptionsPage extends StatelessWidget {
//   final String userName;
//   final String userId;
//   final String userEmail;
//   final String docId;

//   const UserOptionsPage({
//     Key? key,
//     required this.userName,
//     required this.userId,
//     required this.userEmail,
//     required this.docId,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(userName),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => OrderPage(
//                       userName: userName,
//                       userId: userId,
//                       userEmail: userEmail,
//                       docId: docId,
//                     ),
//                   ),
//                 );
//               },
//               child: Text('Add Order'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 await _updateAvailability(userId, 'break', userEmail);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => Calculation(
//                       userName: userName,
//                       userId: userId,
//                       userEmail: userEmail,
//                       docId: docId,
//                     ),
//                   ),
//                 );
//               },
//               child: Text('Break'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 await _updateAvailability(userId, 'end', userEmail);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => Calculation(
//                       userName: userName,
//                       userId: userId,
//                       userEmail: userEmail,
//                       docId: docId,
//                     ),
//                   ),
//                 );
//               },
//               child: Text('End'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _updateAvailability(
//       String userId, String availability, String userEmail) async {
//     try {
//       final userRef =
//           FirebaseFirestore.instance.collection('available').doc(userId);
//       await userRef.set({
//         'available': availability,
//         'email': userEmail,
//       });
//     } catch (e) {
//       print('Error updating availability: $e');
//     }
//   }
// }
