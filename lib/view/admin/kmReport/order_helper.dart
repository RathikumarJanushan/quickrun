import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderHelper {
  static Future<void> editOrder(
      BuildContext context, String orderId, Map<String, dynamic> data) async {
    final parcelNamesController = TextEditingController(
      text: (data['parcelDetails'] as List<dynamic>?)
              ?.map((parcel) => parcel['name'])
              .join(', ') ??
          '',
    );

    final totalPathDistanceController = TextEditingController(
      text: data['totalPathDistance']?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Order'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Parcel Names:'),
                TextField(
                  controller: parcelNamesController,
                  decoration: const InputDecoration(
                    hintText: 'Enter parcel names separated by commas',
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Total Path Distance:'),
                TextField(
                  controller: totalPathDistanceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter total path distance',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Parse updated parcel names
                  final updatedParcelNames = parcelNamesController.text
                      .split(',')
                      .map((name) => name.trim())
                      .toList();

                  // Preserve other fields in parcelDetails
                  final existingParcels =
                      data['parcelDetails'] as List<dynamic>? ?? [];
                  final updatedParcels = existingParcels.map((parcel) {
                    final name = parcel['name'];
                    return {
                      ...parcel,
                      'name': updatedParcelNames.contains(name)
                          ? name
                          : name, // Ensure existing fields are preserved
                    };
                  }).toList();

                  // Add any new parcel names not already present
                  updatedParcelNames.forEach((name) {
                    if (!existingParcels
                        .any((parcel) => parcel['name'] == name)) {
                      updatedParcels.add({'name': name});
                    }
                  });

                  // Parse updated total path distance
                  final updatedTotalPathDistance =
                      double.tryParse(totalPathDistanceController.text) ?? 0.0;

                  // Update Firestore document
                  await FirebaseFirestore.instance
                      .collection('finished_order_details')
                      .doc(orderId)
                      .update({
                    'parcelDetails': updatedParcels,
                    'totalPathDistance': updatedTotalPathDistance,
                  });

                  Navigator.pop(context);
                } catch (e) {
                  // Handle update error
                  print('Error updating order: $e');
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  static Future<String> getUserName(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('usersdetails')
          .doc(userId)
          .get();
      return userDoc.exists
          ? (userDoc.data()?['name'] ?? 'Unknown')
          : 'Unknown';
    } catch (e) {
      return 'Unknown';
    }
  }
}
