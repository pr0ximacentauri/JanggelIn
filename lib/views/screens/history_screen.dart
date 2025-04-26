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

class HistoryContent extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // final sensorVM = Provider.of<SensorViewModel>(context);
    
      return Scaffold(
        backgroundColor: Color(0xFFC8DCC3),
        appBar: AppBar(
          title: const Text('Log Data Sensor'),
          backgroundColor: Color(0xFF5E7154),
        ),
        body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Ini Log'),
                // SensorHistoryChart(data: sensorVM.historicalData),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}