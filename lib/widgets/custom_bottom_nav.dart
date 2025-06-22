import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.green[700],
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Feather.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Feather.camera),
          label: 'Scan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Feather.archive),
          label: 'Saved',
        ),
        BottomNavigationBarItem(
          icon: Icon(Feather.edit),
          label: 'Manual',
        ),
        BottomNavigationBarItem(
          icon: Icon(Feather.book),
          label: 'Recipes',
        ),
      ],
    );
  }
}