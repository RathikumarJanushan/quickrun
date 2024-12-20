import 'package:flutter/material.dart';

class OrderSave extends StatelessWidget {
  final String userId;
  final String restaurantName;
  final String restaurantPostalCode;
  final String restaurantAddress;
  final List<Map<String, String>> parcels;

  const OrderSave({
    Key? key,
    required this.userId,
    required this.restaurantName,
    required this.restaurantPostalCode,
    required this.restaurantAddress,
    required this.parcels,
    String? address,
    String? postalCode,
    String? selectedName,
    required List<String> parcelNames,
    required List<Map<String, String>> deliveryAddresses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
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
                userId,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text(
                'Restaurant Details:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Name: $restaurantName',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Postal Code: $restaurantPostalCode',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Address: $restaurantAddress',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text(
                'Parcel Details:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: parcels.length,
                itemBuilder: (context, index) {
                  final parcel = parcels[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '- Parcel Name: ${parcel['name']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        '  Postal Code: ${parcel['postal_code']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        '  Address: ${parcel['address']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
