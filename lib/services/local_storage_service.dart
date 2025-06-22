import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class LocalStorageService {
  static const _productsKey = 'products';

  static Future<void> addProduct(Map<String, dynamic> product) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_productsKey) ?? [];

    // Ensure product has unique ID
    product['id'] ??= const Uuid().v4();

    existing.add(jsonEncode(product));
    await prefs.setStringList(_productsKey, existing);
  }

  static Future<List<Map<String, dynamic>>> getAllProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_productsKey) ?? [];
    return data.map((item) => jsonDecode(item) as Map<String, dynamic>).toList();
  }

  static Future<void> deleteProduct(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final products = await getAllProducts();
    final updated = products.where((p) => p['id'] != id).toList();
    await prefs.setStringList(_productsKey, updated.map(jsonEncode).toList());
  }

  static Future<void> editProduct(String id, Map<String, dynamic> newData) async {
    final prefs = await SharedPreferences.getInstance();
    final products = await getAllProducts();
    final updated = products.map((p) {
      if (p['id'] == id) {
        return {
          'id': id,
          'name': newData['name'],
          'expiry': newData['expiry'],
        };
      }
      return p;
    }).toList();
    await prefs.setStringList(_productsKey, updated.map(jsonEncode).toList());
  }
}