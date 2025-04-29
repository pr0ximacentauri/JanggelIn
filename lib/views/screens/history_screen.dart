import 'package:c3_ppl_agro/view_models/sensor_view_model.dart';
import 'package:c3_ppl_agro/views/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget{
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HistoryContent(), 
      bottomNavigationBar: BottomNavbar(),
    );
  }
}

class HistoryContent extends StatelessWidget {
  final List<Map<String, dynamic>> dummyLogs = [
    {
      'timestamp': '29-04-2025 08:30',
      'temperature': 27.5,
      'humidity': 75.0,
      'minTemp': 25.0,
      'maxTemp': 30.0,
      'minHumid': 70.0,
      'actuators': {'lampu': 'OFF', 'kipas': 'OFF', 'pompa': 'OFF'}
    },
    {
      'timestamp': '29-04-2025 08:00',
      'temperature': 24.0,
      'humidity': 68.0,
      'minTemp': 25.0,
      'maxTemp': 30.0,
      'minHumid': 70.0,
      'actuators': {'lampu': 'ON', 'kipas': 'OFF', 'pompa': 'ON'}
    },
    {
      'timestamp': '29-04-2025 07:30',
      'temperature': 31.2,
      'humidity': 72.0,
      'minTemp': 25.0,
      'maxTemp': 30.0,
      'minHumid': 70.0,
      'actuators': {'lampu': 'OFF', 'kipas': 'ON', 'pompa': 'OFF'}
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC8DCC3),
      appBar: AppBar(
        title: const Text('Log Data Sensor'),
        backgroundColor: const Color(0xFF5E7154),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dummyLogs.length,
        itemBuilder: (context, index) {
          final log = dummyLogs[index];
          return Card(
            color: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Waktu: ${log['timestamp']}', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Suhu: ${log['temperature']} °C'),
                  Text('Kelembapan: ${log['humidity']} %'),
                  const SizedBox(height: 8),
                  Text('Batas Optimal:'),
                  Text('- Suhu: ${log['minTemp']} - ${log['maxTemp']} °C'),
                  Text('- Kelembapan: ${log['minHumid']}+ %'),
                  const SizedBox(height: 8),
                  Text('Status Aktuator:'),
                  Text('- Lampu Pijar: ${log['actuators']['lampu']}'),
                  Text('- Kipas: ${log['actuators']['kipas']}'),
                  Text('- Pompa Air: ${log['actuators']['pompa']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
