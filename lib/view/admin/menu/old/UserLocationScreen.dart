import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pickup_section.dart';
import 'delivery_section.dart';

class UserLocationScreen extends StatefulWidget {
  final String userId;

  const UserLocationScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _UserLocationScreenState createState() => _UserLocationScreenState();
}

class _UserLocationScreenState extends State<UserLocationScreen> {
  final List<Map<String, dynamic>> _pickupData = [];
  final List<Map<String, dynamic>> _deliveryData = [];

  // Save Data to Firestore and update availability
  void _saveData() async {
    final data = {
      'userId': widget.userId,
      'pickupData': _pickupData,
      'deliveryData': _deliveryData,
      'status': 'pending',
      'timestamp': Timestamp.now(),
    };

    try {
      // Save user location data
      await FirebaseFirestore.instance
          .collection('order_details')
          .doc(widget.userId)
          .set(data);

      // Update the available path
      await FirebaseFirestore.instance
          .collection('available')
          .doc(widget.userId)
          .set({'available': 'busy'}, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data saved and available updated!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Information'),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User ID: ${widget.userId}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Pickup Section
            PickupSection(
              pickupData: _pickupData,
            ),
            const Divider(thickness: 2, height: 32),

            // Delivery Section
            DeliverySection(
              deliveryData: _deliveryData,
            ),

            // Save Data Button
            Center(
              child: ElevatedButton(
                onPressed: _saveData,
                child: const Text('Save Data'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
