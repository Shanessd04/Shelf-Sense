import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'ShelfSense',
          style: TextStyle(
            color: Color(0xFF1B1C1E),
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/fridge.png',
                height: 220,
              ),
              const SizedBox(height: 30),
              const Text(
                'Welcome to ShelfSense!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 32, 84, 58),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Smartly scan, save and track your groceries.\nNever let food go to waste again!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}