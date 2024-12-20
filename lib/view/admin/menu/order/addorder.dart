import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quickrun/view/admin/menu/order/OrderSummary.dart';

class AddOrder extends StatefulWidget {
  final String userId;

  const AddOrder({Key? key, required this.userId}) : super(key: key);

  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  String? selectedRestaurantName;
  String? postalCode;
  String? address;

  List<String> selectedParcels = []; // List to store selected parcels
  List<Map<String, dynamic>> selectedParcelDetails =
      []; // Store details of selected parcels

  List<Map<String, dynamic>> restaurantList = [];
  List<Map<String, dynamic>> parcelList = [];

  @override
  void initState() {
    super.initState();
    fetchRestaurantData();
    fetchParcelData();
  }

  Future<Map<String, double>?> _getCoordinates(String address) async {
    const String apiKey =
        'AIzaSyA2VIqHhmUfHEht98ie7cHLi5tqhAtAsUg'; // Replace with your API key
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final location = data['results'][0]['geometry']['location'];
          return {
            'latitude': location['lat'],
            'longitude': location['lng'],
          };
        } else {
          print('Geocoding API error: ${data['status']}');
        }
      }
    } catch (e) {
      print('Error getting coordinates: $e');
    }
    return null;
  }

// Your existing fetchRestaurantData function with modifications
  Future<void> fetchRestaurantData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Restaurant_address')
          .get();

      List<Map<String, dynamic>> updatedRestaurants = [];

      for (var doc in snapshot.docs) {
        final address = doc['address'];
        final coords = await _getCoordinates(address);

        updatedRestaurants.add({
          'name': doc['name'],
          'postal_code': doc['postal_code'],
          'address': address,
          'latitude': coords?['latitude'] ?? 'N/A',
          'longitude': coords?['longitude'] ?? 'N/A',
        });
      }

      setState(() {
        restaurantList = updatedRestaurants;
      });
    } catch (e) {
      print('Error fetching restaurant data: $e');
    }
  }

  Future<void> fetchParcelData() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('pending_add_order')
          .get();

      setState(() {
        parcelList = snapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  'name': doc['name'],
                  'mobile_number': doc['mobile_number'],
                  'address': doc['address'],
                  'postal_code': doc['postal_code'],
                  'payment_method': doc['payment_method'],
                  'cash_amount': doc['cash_amount'],
                  'status': doc['status'],
                })
            .toList();
      });
    } catch (e) {
      print('Error fetching parcel data: $e');
    }
  }

  void onRestaurantChanged(String? newValue) {
    if (newValue != null) {
      final selectedRestaurant = restaurantList.firstWhere(
        (restaurant) => restaurant['name'] == newValue,
      );
      setState(() {
        selectedRestaurantName = newValue;
        postalCode = selectedRestaurant['postal_code'];
        address = selectedRestaurant['address'];
      });
    }
  }

  void toggleParcelSelection(String parcelName) async {
    final selectedParcel = parcelList.firstWhere(
      (parcel) => parcel['name'] == parcelName,
    );

    if (selectedParcels.contains(parcelName)) {
      // If already selected, remove
      setState(() {
        selectedParcels.remove(parcelName);
        selectedParcelDetails
            .removeWhere((parcel) => parcel['name'] == parcelName);
      });
    } else {
      // Fetch coordinates for the parcel's address
      final coords = await _getCoordinates(selectedParcel['address']);

      final parcelWithCoords = {
        ...selectedParcel,
        'latitude': coords?['latitude'] ?? 'N/A',
        'longitude': coords?['longitude'] ?? 'N/A',
      };

      setState(() {
        selectedParcels.add(parcelName);
        selectedParcelDetails.add(parcelWithCoords);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'User ID:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                widget.userId,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text(
                'Select Restaurant:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: selectedRestaurantName,
                hint: const Text('Select a restaurant'),
                items: restaurantList.map((restaurant) {
                  return DropdownMenuItem<String>(
                    value: restaurant['name'],
                    child: Text(restaurant['name']),
                  );
                }).toList(),
                onChanged: onRestaurantChanged,
              ),
              const SizedBox(height: 24),
              if (selectedRestaurantName != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Postal Code: $postalCode',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Address: $address',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Coordinates: Lat ${restaurantList.firstWhere((restaurant) => restaurant['name'] == selectedRestaurantName)['latitude']}, '
                      'Long ${restaurantList.firstWhere((restaurant) => restaurant['name'] == selectedRestaurantName)['longitude']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              const SizedBox(height: 24),
              const Text(
                'Select Parcel:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: parcelList.map((parcel) {
                  return FilterChip(
                    label: Text(parcel['name']),
                    selected: selectedParcels.contains(parcel['name']),
                    onSelected: (_) => toggleParcelSelection(parcel['name']),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              if (selectedParcelDetails.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selected Parcel Details:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ...selectedParcelDetails.map((parcel) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name: ${parcel['name']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Mobile Number: ${parcel['mobile_number']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Address: ${parcel['address']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Postal Code: ${parcel['postal_code']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Payment Method: ${parcel['payment_method']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Cash Amount: ${parcel['cash_amount']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Status: ${parcel['status']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Coordinates: Lat ${parcel['latitude']}, Long ${parcel['longitude']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            ElevatedButton(
                              onPressed: selectedRestaurantName != null ||
                                      selectedParcelDetails.isNotEmpty
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SummaryPage(
                                            userId: widget.userId,
                                            restaurantDetails:
                                                restaurantList.firstWhere(
                                              (restaurant) =>
                                                  restaurant['name'] ==
                                                  selectedRestaurantName,
                                              orElse: () => {},
                                            ),
                                            parcelDetails:
                                                selectedParcelDetails,
                                          ),
                                        ),
                                      );
                                    }
                                  : null, // Disable button if no details selected
                              child: const Text('View Summary'),
                            ),
                            const Divider(),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
