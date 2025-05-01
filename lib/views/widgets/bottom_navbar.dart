import 'package:c3_ppl_agro/views/screens/account_screen.dart';
import 'package:c3_ppl_agro/views/screens/control_screen.dart';
import 'package:c3_ppl_agro/views/screens/history_screen.dart';
import 'package:c3_ppl_agro/views/screens/home_screen.dart';
import 'package:flutter/material.dart';

class BottomNavbar extends StatefulWidget {
  final int initialIndex;
  const BottomNavbar({super.key, this.initialIndex = 0}); // Default ke tab Beranda

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

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
      backgroundColor: Colors.blueGrey,
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
