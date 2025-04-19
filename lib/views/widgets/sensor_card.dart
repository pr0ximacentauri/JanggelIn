import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:c3_ppl_agro/view_models/sensor_view_model.dart';
import 'progress_bar.dart';

class SensorCard extends StatelessWidget {
  final String title;
  final String type;
  final Color color;

  const SensorCard({
    super.key,
    required this.title,
    required this.type,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final sensorVM = Provider.of<SensorViewModel>(context);
    
    String valueText = '0.0';
    if (type == 'temperature') {
      valueText = sensorVM.temperature.toStringAsFixed(1) + ' °C';
    } else if (type == 'humidity') {
      valueText = sensorVM.humidity.toStringAsFixed(1) + ' %';
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Container(
        width: 150,
        height: 120,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              valueText,
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black,),
            ),
            // const SizedBox(height: 20),
            // ArcProgressBar(progress: progress, color: color, strokeWidth: 12),
            // const SizedBox(height: 1),
            // Text(
            //   "${value.toStringAsFixed(1)}",
            //   style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            // ),
          ],
        ),
      ),
    );
  }
}
