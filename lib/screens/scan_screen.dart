import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/ocr_service.dart';
import '../services/gemini_service.dart';
import '../services/local_storage_service.dart';
import '../widgets/product_card.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File? _image;
  String _productName = '';
  String _expiryDate = '';
  String _status = '';
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _productName = '';
        _expiryDate = '';
        _status = '';
        _isLoading = true;
      });

      try {
        final ocrText = await OcrService.extractTextFromImage(_image!);
        final result = await GeminiService.extractEntities(ocrText);

        if (result.containsKey('product') && result.containsKey('expiry')) {
          final product = result['product']!;
          final expiry = result['expiry']!;
          final status = _getFoodStatus(expiry);

          setState(() {
            _productName = product;
            _expiryDate = expiry;
            _status = status;
          });

          await LocalStorageService.addProduct({
            'name': product,
            'expiry': expiry,
          });
        } else {
          throw Exception('Failed to extract valid entities');
        }
      } catch (e) {
        debugPrint('❌ Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to process image.')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getFoodStatus(String expiryDate) {
    try {
      final expiry = DateTime.parse(expiryDate);
      final now = DateTime.now();
      final diff = expiry.difference(now).inDays;

      if (diff < 0) return 'Expired';
      if (diff <= 3) return 'Expiring Soon';
      return 'Fresh';
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        title: const Text(
          'Scan Product',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade200,
        centerTitle: true,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.camera_alt),
                label: const Text(
                  'Scan Product Label',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 24),
              if (_isLoading) const CircularProgressIndicator(),
              if (_image != null && !_isLoading) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _image!,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                if (_productName.isNotEmpty && _expiryDate.isNotEmpty)
                  ProductCard(
                    productName: _productName,
                    expiryDate: _expiryDate,
                    status: _status,
                    onEdit: () {}, // Disabled in Scan Screen
                    onDelete: () {}, // Disabled in Scan Screen
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}