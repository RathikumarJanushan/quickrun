import 'package:flutter/material.dart';
import 'package:quickrun/auth/auth_service.dart';
import 'package:quickrun/view/admin/Delete_month.dart';
import 'package:quickrun/view/admin/addTime.dart';
import 'package:quickrun/view/admin/addorder/AddOrderPage.dart';
import 'package:quickrun/view/admin/deletuser.dart';

import 'package:quickrun/view/admin/availableUser/availableUser.dart';
import 'package:quickrun/view/admin/google/map.dart';
import 'package:quickrun/view/admin/kmReport/SelectFiltersPage.dart';
import 'package:quickrun/view/admin/kmReport/finish_order_view.dart';
import 'package:quickrun/view/admin/menu/add_hotel.dart';
import 'package:quickrun/view/admin/menu/order/LiveOrderDetailsPage.dart';

import 'package:quickrun/view/admin/report.dart';
import 'package:quickrun/view/admin/report2.dart';
import 'package:quickrun/view/admin/userkmReport/UserKm.dart';
import 'package:quickrun/view/wellcomeview/welcome_view.dart';

class MenuDrawer extends StatelessWidget {
  final AuthService auth;

  const MenuDrawer({Key? key, required this.auth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(206, 45, 175, 219),
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Live Order'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LiveOrderDetailsPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Add Order'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddOrderPage()),
              );
            },
          ),
          // ListTile(
          //   title: const Text('map'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => GoogleMapRoutePage()),
          //     );
          //   },
          // ),
          // ListTile(
          //   title: const Text('Available User'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => AvailableUser()),
          //     );
          //   },
          // ),
          // ListTile(
          //   title: const Text('View Report'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => AllUsersScreen()),
          //     );
          //   },
          // ),
          // ListTile(
          //   title: const Text('Add Time'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => AddtimeUsersScreen()),
          //     );
          //   },
          // ),
          // ListTile(
          //   title: const Text('Summary Report'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => Report2()),
          //     );
          //   },
          // ),
          // ListTile(
          //   title: const Text('Delete month report'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => DeleteMonth()),
          //     );
          //   },
          // ),
          ListTile(
            title: const Text('Delete User'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DeleteUser()),
              );
            },
          ),
          ListTile(
            title: const Text('add hotel address'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddRestaurantPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Hotal Km Report'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SelectFiltersPage()),
              );
            },
          ),
          ListTile(
            title: const Text('User Km Report'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserKm()),
              );
            },
          ),
          ListTile(
            title: const Text('Sign Out'),
            onTap: () async {
              await auth.signout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => WelcomeView()),
              );
            },
          ),
        ],
      ),
    );
  }
}
