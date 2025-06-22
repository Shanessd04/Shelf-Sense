import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/scan_screen.dart';
import '../screens/saved_scans_screen.dart';
import '../screens/manual_entry_screen.dart';
import '../screens/recipe_suggestions_screen.dart';
import '../widgets/custom_bottom_nav.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ScanScreen(),
    const SavedScansScreen(),
    const ManualEntryScreen(),
    const RecipeSuggestionsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}