// import 'package:flutter/material.dart';

// class UserCard extends StatelessWidget {
//   final String userName;
//   final String userEmail;
//   final String status;
//   final VoidCallback onTap;

//   const UserCard({
//     Key? key,
//     required this.userName,
//     required this.userEmail,
//     required this.status,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       elevation: 4.0,
//       color: status == 'start'
//           ? Colors.green.withOpacity(0.8)
//           : status == 'end'
//               ? Colors.red.withOpacity(0.8)
//               : Colors.orange.withOpacity(0.8),
//       child: ListTile(
//         contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//         title: Text(
//           userName,
//           style: TextStyle(
//             fontSize: 18.0,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 8.0),
//             Text(
//               'Email: $userEmail',
//               style: TextStyle(fontSize: 14.0, color: Colors.white),
//             ),
//             SizedBox(height: 4.0),
//             Text(
//               'Status: ${status == 'start' ? 'Available' : status == 'end' ? 'Unavailable' : 'Brake'}',
//               style: TextStyle(
//                 fontSize: 14.0,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//         onTap: onTap,
//       ),
//     );
//   }
// }
