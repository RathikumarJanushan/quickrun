import 'package:flutter/material.dart';

class DeliverySection extends StatefulWidget {
  final List<Map<String, dynamic>> deliveryData;

  const DeliverySection({
    Key? key,
    required this.deliveryData,
  }) : super(key: key);

  @override
  State<DeliverySection> createState() => _DeliverySectionState();
}

class _DeliverySectionState extends State<DeliverySection> {
  final TextEditingController _deliveryAddressController =
      TextEditingController();
  final TextEditingController _deliveryNameController = TextEditingController();
  final TextEditingController _deliveryPhoneController =
      TextEditingController();
  int _selectedDeliveryIndex = -1;

  void _addDeliveryAddress() {
    if (_deliveryAddressController.text.isNotEmpty) {
      setState(() {
        widget.deliveryData.add({
          'address': _deliveryAddressController.text,
          'deliveryDetails': <Map<String, String>>[],
        });
        _deliveryAddressController.clear();
        _selectedDeliveryIndex = widget.deliveryData.length - 1;
      });
    }
  }

  void _addDeliveryDetails() {
    if (_deliveryNameController.text.isNotEmpty &&
        _deliveryPhoneController.text.isNotEmpty &&
        _selectedDeliveryIndex != -1) {
      setState(() {
        (widget.deliveryData[_selectedDeliveryIndex]['deliveryDetails']
                as List<Map<String, String>>)
            .add({
          'name': _deliveryNameController.text,
          'phone': _deliveryPhoneController.text,
        });
        _deliveryNameController.clear();
        _deliveryPhoneController.clear();
      });
    }
  }

  @override
  void dispose() {
    _deliveryAddressController.dispose();
    _deliveryNameController.dispose();
    _deliveryPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _deliveryAddressController,
                decoration: const InputDecoration(
                  labelText: 'Delivery Address',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _addDeliveryAddress,
              child: const Text('+ Add Address'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.deliveryData.length,
          itemBuilder: (context, index) {
            final address = widget.deliveryData[index]['address'];
            final details = (widget.deliveryData[index]['deliveryDetails']
                as List<Map<String, String>>);
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text('Address ${index + 1}: $address'),
                      trailing: _selectedDeliveryIndex == index
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedDeliveryIndex = index;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    if (_selectedDeliveryIndex == index)
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _deliveryNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Name',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _deliveryPhoneController,
                                  decoration: const InputDecoration(
                                    labelText: 'Phone Number',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _addDeliveryDetails,
                                child: const Text('+ Add Details'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (details.isNotEmpty)
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: details.length,
                              itemBuilder: (context, detailIndex) {
                                final detail = details[detailIndex];
                                return ListTile(
                                  title: Text(
                                      'Name: ${detail['name']} | Phone: ${detail['phone']}'),
                                );
                              },
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
