import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:quickrun/view/admin/kmReport/finish_order_view.dart';

class SelectFiltersPage extends StatefulWidget {
  const SelectFiltersPage({Key? key}) : super(key: key);

  @override
  State<SelectFiltersPage> createState() => _SelectFiltersPageState();
}

class _SelectFiltersPageState extends State<SelectFiltersPage> {
  String? selectedMonth;
  String? selectedRestaurant;
  DateTime? selectedDate;
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  List<String> restaurantNames = [];

  void fetchRestaurants(String selectedMonth) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('finished_order_details')
        .get();

    final restaurants = snapshot.docs
        .where((doc) {
          final timestamp = doc['timestamp']?.toDate();
          final month =
              timestamp != null ? DateFormat.MMMM().format(timestamp) : null;
          return month == selectedMonth;
        })
        .map((doc) {
          final restaurant =
              (doc['restaurant'] as Map<String, dynamic>?)?['name'];
          return restaurant ?? 'Unknown';
        })
        .toSet()
        .toList();

    setState(() {
      restaurantNames = restaurants.cast<String>();
      selectedRestaurant = null; // Reset restaurant selection
    });
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Filters')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: DropdownButtonFormField<String>(
              value: selectedMonth,
              decoration: const InputDecoration(
                labelText: 'Select Month',
                border: OutlineInputBorder(),
              ),
              items: months.map((month) {
                return DropdownMenuItem<String>(
                  value: month,
                  child: Text(month),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedMonth = value;
                  selectedRestaurant = null;
                  selectedDate = null;
                  restaurantNames.clear();
                });

                if (value != null) {
                  fetchRestaurants(value);
                }
              },
            ),
          ),
          if (restaurantNames.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: DropdownButtonFormField<String>(
                value: selectedRestaurant,
                decoration: const InputDecoration(
                  labelText: 'Select Restaurant',
                  border: OutlineInputBorder(),
                ),
                items: restaurantNames.map((restaurant) {
                  return DropdownMenuItem<String>(
                    value: restaurant,
                    child: Text(restaurant),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRestaurant = value;
                  });
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: selectedDate != null
                    ? DateFormat.yMMMd().format(selectedDate!)
                    : 'Select Date (Optional)',
                border: const OutlineInputBorder(),
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              onTap: _pickDate,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedMonth != null && selectedRestaurant != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FinishedOrdersPage(
                      selectedMonth: selectedMonth!,
                      selectedRestaurant: selectedRestaurant!,
                      selectedDate: selectedDate,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Please select both a month and a restaurant.'),
                  ),
                );
              }
            },
            child: const Text('View Orders'),
          ),
        ],
      ),
    );
  }
}
