import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  static const _apiKey = ''; // Replace with your actual key
  static const _url =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$_apiKey';

  static Future<Map<String, String>> extractEntities(String ocrText) async {
    try {
      final prompt = '''
Extract the product name and expiry date from the following text:
"$ocrText"

Respond in JSON format:
{
  "product": "Product Name",
  "expiry": "YYYY-MM-DD"
}
''';

      final response = await http.post(
        Uri.parse(_url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final candidates = data['candidates'] ?? [];
        if (candidates.isNotEmpty) {
          String text = candidates[0]['content']['parts'][0]['text'];

          // Cleanup formatting issues
          text = text.trim().replaceAll('```json', '').replaceAll('```', '');

          final Map<String, dynamic> json = jsonDecode(text);

          if (json.containsKey('product') && json.containsKey('expiry')) {
            return {
              'product': json['product'],
              'expiry': json['expiry'],
            };
          }
        }
      }

      throw Exception('Failed to extract valid entities');
    } catch (e) {
      print('❌ GeminiService Error: $e');
      throw Exception('Failed to extract valid entities');
    }
  }

  static Future<List<String>> suggestIndianRecipes(String ingredients) async {
  try {
    final prompt = '''
Suggest 5 Indian dishes I can make using the following expiring ingredients:
"$ingredients"

Respond in JSON array format:
[
  "Dish 1",
  "Dish 2",
  ...
]
''';

    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final candidates = data['candidates'];
      if (candidates != null && candidates.isNotEmpty) {
        String text = candidates[0]['content']['parts'][0]['text'];

        // Clean up formatting
        text = text.trim().replaceAll('```json', '').replaceAll('```', '');

        final parsed = jsonDecode(text);
        if (parsed is List) {
          return parsed.map<String>((e) => e.toString()).toList();
        } else {
          throw Exception('Invalid response format');
        }
      }
    }

    throw Exception('Failed to get recipes');
  } catch (e) {
    debugPrint('❌ GeminiService Error: $e');
    throw Exception('Failed to get recipes');
  }
}
}