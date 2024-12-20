import 'package:flutter/material.dart';

class PickupSection extends StatefulWidget {
  final List<Map<String, dynamic>> pickupData;

  const PickupSection({
    Key? key,
    required this.pickupData,
  }) : super(key: key);

  @override
  State<PickupSection> createState() => _PickupSectionState();
}

class _PickupSectionState extends State<PickupSection> {
  final TextEditingController _pickupAddressController =
      TextEditingController();
  final TextEditingController _parcelNameController = TextEditingController();
  int _selectedPickupIndex = -1;

  void _addPickupAddress() {
    if (_pickupAddressController.text.isNotEmpty) {
      setState(() {
        widget.pickupData.add({
          'address': _pickupAddressController.text,
          'parcels': <String>[],
        });
        _pickupAddressController.clear();
        _selectedPickupIndex = widget.pickupData.length - 1;
      });
    }
  }

  void _addParcelName() {
    if (_parcelNameController.text.isNotEmpty && _selectedPickupIndex != -1) {
      setState(() {
        (widget.pickupData[_selectedPickupIndex]['parcels'] as List<String>)
            .add(_parcelNameController.text);
        _parcelNameController.clear();
      });
    }
  }

  @override
  void dispose() {
    _pickupAddressController.dispose();
    _parcelNameController.dispose();
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
                controller: _pickupAddressController,
                decoration: const InputDecoration(
                  labelText: 'Pickup Address',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _addPickupAddress,
              child: const Text('+ Add Address'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.pickupData.length,
          itemBuilder: (context, index) {
            final address = widget.pickupData[index]['address'];
            final parcels =
                (widget.pickupData[index]['parcels'] as List<String>);
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text('Address ${index + 1}: $address'),
                      trailing: _selectedPickupIndex == index
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedPickupIndex = index;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    if (_selectedPickupIndex == index)
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _parcelNameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Parcel Name',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _addParcelName,
                                child: const Text('+ Add Parcel'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (parcels.isNotEmpty)
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: parcels.length,
                              itemBuilder: (context, parcelIndex) {
                                return ListTile(
                                  title: Text(
                                      'Parcel ${parcelIndex + 1}: ${parcels[parcelIndex]}'),
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
