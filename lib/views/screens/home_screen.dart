import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/control_view_model.dart';
import '../widgets/sensor_card.dart';
import '../widgets/power_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; 

  final List<Widget> _pages = [
    HomeContent(),
    Center(child: Text("Log History", style: TextStyle(fontSize: 24))),
    Center(child: Text("Akun", style: TextStyle(fontSize: 24))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Janggelin"),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      backgroundColor: Colors.blueGrey,
      body: _pages[_selectedIndex], 
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Log"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Akun"),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final deviceVM = Provider.of<DeviceViewModel>(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SensorCard(
                title: "Suhu",
                value: 2, //deviceVM.device.temperature,
                minValue: 25,
                maxValue: 35,
                color: Colors.orange,
              ),
              SensorCard(
                title: "Kelembapan",
                value: 1,//deviceVM.device.humidity,
                minValue: 60,
                maxValue: 80,
                color: Colors.blue,
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
