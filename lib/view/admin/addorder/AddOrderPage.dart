import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddOrderPage extends StatefulWidget {
  const AddOrderPage({Key? key}) : super(key: key);

  @override
  _AddOrderPageState createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _cashAmountController = TextEditingController();

  String? _selectedPaymentMethod;

  void _saveOrder(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final orderData = {
        'name': _nameController.text,
        'mobile_number': _mobileNumberController.text,
        'address': _addressController.text,
        'postal_code': _postalCodeController.text,
        'payment_method': _selectedPaymentMethod,
        'cash_amount': _selectedPaymentMethod == 'Cash'
            ? _cashAmountController.text
            : null,
        'timestamp': Timestamp.now(),
        'status': 'pending',
      };

      try {
        await FirebaseFirestore.instance
            .collection('pending_add_order')
            .add(orderData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order added successfully!')),
        );
        _formKey.currentState!.reset();
        _cashAmountController.clear();
        setState(() {
          _selectedPaymentMethod = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add order: $e')),
        );
      }
    }
  }

  void _editOrderDialog(
      BuildContext context, String orderId, Map<String, dynamic> data) {
    final nameController = TextEditingController(text: data['name']);
    final mobileNumberController =
        TextEditingController(text: data['mobile_number']);
    final addressController = TextEditingController(text: data['address']);
    final postalCodeController =
        TextEditingController(text: data['postal_code']);
    final cashAmountController =
        TextEditingController(text: data['cash_amount']?.toString() ?? '');
    String? selectedPaymentMethod = data['payment_method'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Order'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextFormField(
                  controller: mobileNumberController,
                  decoration: const InputDecoration(labelText: 'Mobile Number'),
                  keyboardType: TextInputType.phone,
                ),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                TextFormField(
                  controller: postalCodeController,
                  decoration: const InputDecoration(labelText: 'Postal Code'),
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField<String>(
                  value: selectedPaymentMethod,
                  decoration:
                      const InputDecoration(labelText: 'Payment Method'),
                  items: ['Online', 'Cash']
                      .map((method) => DropdownMenuItem(
                            value: method,
                            child: Text(method),
                          ))
                      .toList(),
                  onChanged: (value) {
                    selectedPaymentMethod = value;
                  },
                ),
                if (selectedPaymentMethod == 'Cash')
                  TextFormField(
                    controller: cashAmountController,
                    decoration: const InputDecoration(labelText: 'Cash Amount'),
                    keyboardType: TextInputType.number,
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedData = {
                  'name': nameController.text,
                  'mobile_number': mobileNumberController.text,
                  'address': addressController.text,
                  'postal_code': postalCodeController.text,
                  'payment_method': selectedPaymentMethod,
                  'cash_amount': selectedPaymentMethod == 'Cash'
                      ? cashAmountController.text
                      : null,
                };

                try {
                  await FirebaseFirestore.instance
                      .collection('pending_add_order')
                      .doc(orderId)
                      .update(updatedData);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Order updated successfully!')),
                  );
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update order: $e')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteOrder(BuildContext context, String orderId) async {
    try {
      await FirebaseFirestore.instance
          .collection('pending_add_order')
          .doc(orderId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete order: $e')),
      );
    }
  }

  Widget _buildOrderList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('pending_add_order')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final orders = snapshot.data!.docs;

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            final data = order.data() as Map<String, dynamic>;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(data['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mobile: ${data['mobile_number']}'),
                    Text('Address: ${data['address']}'),
                    Text('Postal Code: ${data['postal_code']}'),
                    Text('Payment: ${data['payment_method']}'),
                    if (data['cash_amount'] != null)
                      Text('Cash Amount: ${data['cash_amount']}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _editOrderDialog(context, order.id, data);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _showDeleteConfirmationDialog(context, order.id);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Order'),
          content: const Text('Are you sure you want to delete this order?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteOrder(context, orderId);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Orders'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _mobileNumberController,
                        decoration:
                            const InputDecoration(labelText: 'Mobile Number'),
                        keyboardType: TextInputType.phone,
                      ),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(labelText: 'Address'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an address';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _postalCodeController,
                        decoration:
                            const InputDecoration(labelText: 'Postal Code'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a postal code';
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField<String>(
                        value: _selectedPaymentMethod,
                        decoration:
                            const InputDecoration(labelText: 'Payment Method'),
                        items: ['Online', 'Cash']
                            .map((method) => DropdownMenuItem(
                                  value: method,
                                  child: Text(method),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPaymentMethod = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a payment method';
                          }
                          return null;
                        },
                      ),
                      if (_selectedPaymentMethod == 'Cash')
                        TextFormField(
                          controller: _cashAmountController,
                          decoration:
                              const InputDecoration(labelText: 'Cash Amount'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the cash amount';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _saveOrder(context),
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildOrderList(),
            ),
          ),
        ],
      ),
    );
  }
}
