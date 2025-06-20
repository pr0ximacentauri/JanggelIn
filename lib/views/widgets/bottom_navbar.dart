

import 'package:JanggelIn/views/screens/account_screen.dart';
import 'package:JanggelIn/views/screens/control_screen.dart';
import 'package:JanggelIn/views/screens/history_screen.dart';
import 'package:JanggelIn/views/screens/home_screen.dart';
import 'package:flutter/material.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeContent(),
    ControlContent(),
    HistoryContent(),
    AccountContent(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC8DCC3),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFF5E7154),
        selectedItemColor: const Color(0xFFC8DCC3),
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
            icon: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.thermostat, size: 24),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Icon(Icons.water_drop, size: 12, color: Colors.lightBlueAccent),
                ),
              ],
            ),
            label: 'Pengaturan',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}