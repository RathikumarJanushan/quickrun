import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickrun/common/color_extension.dart';

class AddRestaurantPage extends StatefulWidget {
  @override
  _AddRestaurantPageState createState() => _AddRestaurantPageState();
}

class _AddRestaurantPageState extends State<AddRestaurantPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _saveRestaurant() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('Restaurant_address').add({
          'name': _nameController.text,
          'postal_code': _postalCodeController.text,
          'address': _addressController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Restaurant details added successfully!",
                style: TextStyle(color: TColor.primaryText)),
            backgroundColor: TColor.primary,
          ),
        );
        _nameController.clear();
        _postalCodeController.clear();
        _addressController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to add restaurant: $e",
                style: TextStyle(color: TColor.primaryText)),
            backgroundColor: TColor.placeholder,
          ),
        );
      }
    }
  }

  void _deleteRestaurant(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('Restaurant_address')
          .doc(id)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Restaurant deleted successfully!",
              style: TextStyle(color: TColor.primaryText)),
          backgroundColor: TColor.primary,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete restaurant: $e",
              style: TextStyle(color: TColor.primaryText)),
          backgroundColor: TColor.placeholder,
        ),
      );
    }
  }

  void _editRestaurant(
      String id, String name, String postalCode, String address) {
    _nameController.text = name;
    _postalCodeController.text = postalCode;
    _addressController.text = address;

    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(
              controller: _nameController,
              hint: "Restaurant Name",
              validator: (value) =>
                  value!.isEmpty ? "Please enter the restaurant name" : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _postalCodeController,
              hint: "Postal Code",
              validator: (value) =>
                  value!.isEmpty ? "Please enter the postal code" : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _addressController,
              hint: "Address",
              validator: (value) =>
                  value!.isEmpty ? "Please enter the address" : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('Restaurant_address')
                      .doc(id)
                      .update({
                    'name': _nameController.text,
                    'postal_code': _postalCodeController.text,
                    'address': _addressController.text,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Restaurant updated successfully!",
                          style: TextStyle(color: TColor.primaryText)),
                      backgroundColor: TColor.primary,
                    ),
                  );
                  _nameController.clear();
                  _postalCodeController.clear();
                  _addressController.clear();
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Failed to update restaurant: $e",
                          style: TextStyle(color: TColor.primaryText)),
                      backgroundColor: TColor.placeholder,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColor.primary,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
                "Update Restaurant",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.background,
      appBar: AppBar(
        title: Text(
          "Add Restaurant",
          style: TextStyle(color: TColor.primaryText),
        ),
        backgroundColor: TColor.primary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildForm(),
            const SizedBox(height: 24),
            Expanded(child: _buildDataList()),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Add Restaurant Details",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: TColor.primary,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _nameController,
              hint: "Restaurant Name",
              validator: (value) =>
                  value!.isEmpty ? "Please enter the restaurant name" : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _postalCodeController,
              hint: "Postal Code",
              validator: (value) =>
                  value!.isEmpty ? "Please enter the postal code" : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _addressController,
              hint: "Address",
              validator: (value) =>
                  value!.isEmpty ? "Please enter the address" : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveRestaurant,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColor.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  "Save Restaurant",
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataList() {
    return Container(
      decoration: BoxDecoration(
        color: TColor.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Restaurant_address')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error loading data"));
          }
          final data = snapshot.data?.docs ?? [];
          if (data.isEmpty) {
            return Center(
              child: Text(
                "No restaurant data available.",
                style: TextStyle(color: TColor.secondaryText, fontSize: 16),
              ),
            );
          }
          return ListView.separated(
            itemCount: data.length,
            separatorBuilder: (context, index) => Divider(
              color: TColor.placeholder,
              thickness: 1,
            ),
            itemBuilder: (context, index) {
              final item = data[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                title: Text(
                  item['name'],
                  style: TextStyle(
                    color: TColor.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "Postal Code: ${item['postal_code']}\nAddress: ${item['address']}",
                  style: TextStyle(color: TColor.secondaryText),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: TColor.primary),
                      onPressed: () => _editRestaurant(
                        item.id,
                        item['name'],
                        item['postal_code'],
                        item['address'],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: TColor.placeholder),
                      onPressed: () => _deleteRestaurant(item.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: TextStyle(fontSize: 16, color: TColor.secondaryText),
      decoration: InputDecoration(
        hintText: hint,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: TColor.placeholder),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: TColor.primary),
          borderRadius: BorderRadius.circular(8.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
