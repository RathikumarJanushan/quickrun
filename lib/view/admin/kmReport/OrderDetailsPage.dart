import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailsPage extends StatelessWidget {
  final String orderId;
  final Map<String, dynamic> orderData;

  const OrderDetailsPage({
    Key? key,
    required this.orderId,
    required this.orderData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final restaurantDetails =
        orderData['restaurantDetails'] as Map<String, dynamic>?;
    final parcelDetails = orderData['parcelDetails'] as List<dynamic>?;

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details: $orderId'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Restaurant Details:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (restaurantDetails != null) ...[
                Text('Name: ${restaurantDetails['name']}'),
                Text('Address: ${restaurantDetails['address']}'),
                Text('Postal Code: ${restaurantDetails['postal_code']}'),
                Text(
                    'Coordinates: Lat ${restaurantDetails['latitude']}, Long ${restaurantDetails['longitude']}'),
              ] else ...[
                const Text('No restaurant details available.'),
              ],
              const SizedBox(height: 16),
              const Text(
                'Parcel Details:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (parcelDetails != null && parcelDetails.isNotEmpty)
                ...parcelDetails.map((parcel) {
                  final parcelMap = parcel as Map<String, dynamic>;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${parcelMap['name']}'),
                      Text('Mobile Number: ${parcelMap['mobile_number']}'),
                      Text('Address: ${parcelMap['address']}'),
                      Text('Postal Code: ${parcelMap['postal_code']}'),
                      Text('Payment Method: ${parcelMap['payment_method']}'),
                      Text('Cash Amount: ${parcelMap['cash_amount']}'),
                      Text('Status: ${parcelMap['status']}'),
                      Text(
                          'Coordinates: Lat ${parcelMap['latitude']}, Long ${parcelMap['longitude']}'),
                      const Divider(),
                    ],
                  );
                }).toList()
              else
                const Text('No parcel details available.'),
            ],
          ),
        ),
      ),
    );
  }
}
