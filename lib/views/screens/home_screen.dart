import 'package:c3_ppl_agro/views/screens/account_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/control_view_model.dart';
import '../widgets/sensor_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controlVM = Provider.of<ControlViewModel>(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SensorCard(
                title: "Suhu",
                type: "temperature",
                color: Colors.orange,
              ),
              SensorCard(
                title: "Kelembapan",
                type: "humidity",
                color: Colors.blue,
              ),
            ],
          ),
          SizedBox(height: 20),
          Center(
            child: Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.all(20),
              child: InkWell(
                onTap: () => controlVM.toggleControl(),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: controlVM.isOn ? Colors.green : Colors.blueAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        controlVM.isOn ? 'ON' : 'OFF',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}



class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; 

  final List<Widget> _pages = [
    HomeContent(),
    // Center(child: Text("Log History", style: TextStyle(fontSize: 24))),
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
      appBar: AppBar(
        title: Text("Janggelin", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),), 
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Akun"),
        ],
      ),
    );
  }
}