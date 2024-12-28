import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SummaryPage extends StatelessWidget {
  final String userId;
  final Map<String, dynamic>? restaurantDetails;
  final List<Map<String, dynamic>> parcelDetails;

  const SummaryPage({
    Key? key,
    required this.userId,
    required this.restaurantDetails,
    required this.parcelDetails,
  }) : super(key: key);

  Future<void> saveOrderToFirestore(BuildContext context) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Create the order data
      Map<String, dynamic> orderData = {
        'userId': userId,
        'restaurantDetails': restaurantDetails,
        'parcelDetails': parcelDetails,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Save to the live_order_details collection
      await firestore.collection('live_order_details').add(orderData);
      print("Order saved to live_order_details collection");

      // Deleting selected parcels from pending_add_order collection
      if (parcelDetails.isNotEmpty) {
        WriteBatch batch = firestore.batch();
        for (var parcel in parcelDetails) {
          // Check if parcel name exists and is not empty
          if (parcel['name'] != null && parcel['name'].isNotEmpty) {
            print("Deleting parcel with name: ${parcel['name']}");

            // Query the pending_add_order collection by name
            var parcelQuerySnapshot = await firestore
                .collection('pending_add_order')
                .where('name', isEqualTo: parcel['name'])
                .get();

            // Check if the query returns any matching documents
            if (parcelQuerySnapshot.docs.isNotEmpty) {
              // Get the first document (in case there are multiple with the same name)
              var docRef = parcelQuerySnapshot.docs.first.reference;
              batch.delete(docRef);
            } else {
              print("No parcel found with the name: ${parcel['name']}");
            }
          } else {
            print("Parcel name is missing or invalid for: ${parcel['name']}");
          }
        }

        // Commit the batch for deleting parcels
        await batch.commit();
        print(
            "Batch commit successful, parcels deleted from pending_add_order");
      } else {
        print("No parcels to delete.");
      }

      // Update the availability status to "busy"
      await firestore.collection('available').doc(userId).update({
        'available': 'busy', // Assuming the field name is 'status'
      });
      print("User availability updated to 'busy'");

      // Save update to the updates collection with userId as the document ID
      Map<String, dynamic> updateData = {
        'body': 'new order',
        'timestamp': FieldValue.serverTimestamp(),
        'title': 'open app and check',
        'userid': userId,
      };

      await firestore.collection('updates').doc(userId).set(updateData);
      print(
          "Update saved to updates collection with userId as the document ID");

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Order saved, parcels removed, availability updated to busy, and update added!')),
      );

      // Navigate to /adminhome
      Navigator.pushReplacementNamed(context, '/adminhome');
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save order: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Marker> markers = [];

    // Add restaurant marker
    if (restaurantDetails != null &&
        restaurantDetails!['latitude'] != 'N/A' &&
        restaurantDetails!['longitude'] != 'N/A') {
      markers.add(
        Marker(
          markerId: const MarkerId('restaurant'),
          position: LatLng(
            restaurantDetails!['latitude'],
            restaurantDetails!['longitude'],
          ),
          infoWindow: InfoWindow(
            title: restaurantDetails!['name'],
            snippet: 'Restaurant Location',
          ),
        ),
      );
    }

    // Add parcel markers
    for (var parcel in parcelDetails) {
      if (parcel['latitude'] != 'N/A' && parcel['longitude'] != 'N/A') {
        markers.add(
          Marker(
            markerId: MarkerId(parcel['name']),
            position: LatLng(
              parcel['latitude'],
              parcel['longitude'],
            ),
            infoWindow: InfoWindow(
              title: parcel['name'],
              snippet: 'Parcel Location',
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: Row(
              children: [
                // Summary details
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'User ID:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            userId,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 24),
                          if (restaurantDetails != null) ...[
                            const Text(
                              'Selected Restaurant:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Name: ${restaurantDetails!['name']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Address: ${restaurantDetails!['address']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Postal Code: ${restaurantDetails!['postal_code']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Coordinates: Lat ${restaurantDetails!['latitude']}, Long ${restaurantDetails!['longitude']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Divider(),
                          ],
                          if (parcelDetails.isNotEmpty) ...[
                            const Text(
                              'Selected Parcels:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            ...parcelDetails.map((parcel) {
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
                                    const Divider(),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                // Google Map
                Expanded(
                  flex: 1,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: markers.isNotEmpty
                          ? markers[0].position
                          : const LatLng(
                              0, 0), // Default to (0, 0) if no markers
                      zoom: 12,
                    ),
                    markers: markers.toSet(),
                  ),
                ),
              ],
            ),
          ),
          // Add Order button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => saveOrderToFirestore(context),
              child: const Text('Add Order'),
            ),
          ),
        ],
      ),
    );
  }
}
