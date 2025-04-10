import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/device_view_model.dart';
import '../widgets/sensor_card.dart';
import '../widgets/power_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceVM = Provider.of<DeviceViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text("IoT Remote"), centerTitle: true, backgroundColor: Colors.lightBlueAccent,),
      backgroundColor: Colors.blueGrey,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SensorCard(
                  title: "Suhu",
                  value: deviceVM.device.temperature,
                  minValue: 25,
                  maxValue: 35,
                  color: Colors.orange,
                ),
                SensorCard(
                  title: "Kelembapan",
                  value: deviceVM.device.humidity,
                  minValue: 60,
                  maxValue: 80,
                  color: Colors.blue,
                ),
              ],
            ),
            SizedBox(height: 20),
            PowerCard(
              isOn: deviceVM.device.status,
              onToggle: deviceVM.toggleDevice,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: deviceVM.updateSensorData,
              child: Text("Update Sensor Data"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey, 
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Log History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Akun',
          ),
        ],
      ),
    );
  }
}
