import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';
import '../services/gemini_service.dart';

class RecipeSuggestionsScreen extends StatefulWidget {
  const RecipeSuggestionsScreen({super.key});

  @override
  State<RecipeSuggestionsScreen> createState() => _RecipeSuggestionsScreenState();
}

class _RecipeSuggestionsScreenState extends State<RecipeSuggestionsScreen> {
  List<String> _recipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSuggestions();
  }

  Future<void> _fetchSuggestions() async {
    final products = await LocalStorageService.getAllProducts();
    final now = DateTime.now();

    final expiringSoon = products.where((product) {
      final expiry = DateTime.tryParse(product['expiry'] ?? '');
      return expiry != null &&
          expiry.isAfter(now) &&
          expiry.isBefore(now.add(const Duration(days: 5)));
    }).toList();

    if (expiringSoon.isEmpty) {
      setState(() {
        _recipes = [];
        _isLoading = false;
      });
      return;
    }

    final ingredients = expiringSoon.map((p) => p['name']).join(', ');

    try {
      final suggestions = await GeminiService.suggestIndianRecipes(ingredients);
      if (mounted) {
        setState(() {
          _recipes = suggestions;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Recipe suggestion error: $e');
      if (mounted) {
        setState(() {
          _recipes = [];
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
        title: const Text(
          'Recipe Suggestions',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _recipes.isEmpty
                ? const Center(
                    child: Text(
                      'No ingredients expiring soon.\nAdd or scan products first.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  )
                : ListView.separated(
                    itemCount: _recipes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            _recipes[index],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}