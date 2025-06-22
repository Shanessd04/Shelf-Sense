import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/local_storage_service.dart';
import '../widgets/product_card.dart';

class SavedScansScreen extends StatefulWidget {
  const SavedScansScreen({super.key});

  @override
  State<SavedScansScreen> createState() => _SavedScansScreenState();
}

class _SavedScansScreenState extends State<SavedScansScreen> {
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await LocalStorageService.getAllProducts();
    setState(() {
      _products = products;
    });
  }

  Future<void> _deleteProduct(String id) async {
    await LocalStorageService.deleteProduct(id);
    await _loadProducts();
  }

  Future<void> _editProduct(String id, String oldName, String oldExpiry) async {
    final nameController = TextEditingController(text: oldName);
    DateTime selectedDate = DateTime.tryParse(oldExpiry) ?? DateTime.now();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: Text(
                  DateFormat('yyyy-MM-dd').format(selectedDate),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await LocalStorageService.editProduct(id, {
                  'id': id,
                  'name': nameController.text,
                  'expiry': DateFormat('yyyy-MM-dd').format(selectedDate),
                });
                if (context.mounted) Navigator.pop(context);
                await _loadProducts();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  String _getStatus(String expiry) {
    final expiryDate = DateTime.tryParse(expiry);
    if (expiryDate == null) return 'Unknown';

    final now = DateTime.now();
    if (expiryDate.isBefore(now)) return 'Expired';
    if (expiryDate.difference(now).inDays <= 3) return 'Expiring Soon';
    return 'Fresh';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        title: const Text('Saved Scans', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
        backgroundColor: Colors.green.shade200,
        foregroundColor: Colors.black87,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Your Saved Products',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          Expanded(
            child: _products.isEmpty
                ? const Center(child: Text('No products saved yet.'))
                : ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final item = _products[index];
                      final status = _getStatus(item['expiry']);
                      return ProductCard(
                        productName: item['name'],
                        expiryDate: item['expiry'],
                        status: status,
                        onEdit: () => _editProduct(item['id'], item['name'], item['expiry']),
                        onDelete: () => _deleteProduct(item['id']),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}