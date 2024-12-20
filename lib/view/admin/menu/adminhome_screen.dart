import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickrun/auth/auth_service.dart';
import 'package:quickrun/view/admin/menu/order/addorder.dart';
import 'package:quickrun/view/wellcomeview/welcome_view.dart';
import 'menu.dart';

class AdminhomeScreen extends StatefulWidget {
  const AdminhomeScreen({Key? key}) : super(key: key);

  @override
  _AdminhomeScreenState createState() => _AdminhomeScreenState();
}

class _AdminhomeScreenState extends State<AdminhomeScreen> {
  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: ElevatedButton(
              onPressed: () async {
                await auth.signout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeView()),
                );
              },
              child: const Text("Sign Out"),
            ),
          ),
        ],
      ),
      drawer: MenuDrawer(auth: auth),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('available').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No user data available."));
              }

              final docs = snapshot.data!.docs;
              final Map<String, List<Map<String, dynamic>>> categorizedData = {
                'start': [],
                'brake': [],
                'end': [],
                'busy': []
              };

              // Categorize data based on status
              for (var doc in docs) {
                final userId = doc.id;
                final status = doc['available'] ?? 'end';
                categorizedData[status]?.add({'userId': userId});
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ['start', 'brake', 'end', 'busy']
                    .map(
                      (status) => Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              status.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...categorizedData[status]!.map(
                              (user) => FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('usersdetails')
                                    .doc(user['userId'])
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  final userName =
                                      snapshot.hasData && snapshot.data!.exists
                                          ? snapshot.data!['name'] ??
                                              'Name not found'
                                          : 'Name not found';
                                  return Card(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.person,
                                        color: _getStatusColor(status),
                                      ),
                                      title: Text(
                                        "Name: $userName", // Name in uppercase
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "User ID: ${user['userId']}", // User ID in lowercase
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddOrder(
                                              userId: user['userId'],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );

                                  // return Card(
                                  //   margin:
                                  //       const EdgeInsets.symmetric(vertical: 8),
                                  //   child: ListTile(
                                  //     leading: Icon(
                                  //       Icons.person,
                                  //       color: _getStatusColor(status),
                                  //     ),
                                  //     title: GestureDetector(
                                  //       onTap: () {
                                  //         Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //             builder: (context) => AddOrder(
                                  //               userId: user['userId'],
                                  //             ),
                                  //           ),
                                  //         );
                                  //       },
                                  //       child: Text(
                                  //         "User ID: ${user['userId']}",
                                  //         style: const TextStyle(
                                  //           fontSize: 10,
                                  //           color: Colors.blue,
                                  //           decoration:
                                  //               TextDecoration.underline,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     subtitle: Text(
                                  //       "Name: $userName",
                                  //       style: const TextStyle(
                                  //         fontSize: 14,
                                  //         color: Colors.black87,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
      ),
    );
  }

  // Helper function to get color based on the status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'start':
        return Colors.green;
      case 'brake':
        return Colors.orange;
      case 'busy':
        return Colors.red;
      default: // 'end' or unknown
        return Colors.grey;
    }
  }
}
