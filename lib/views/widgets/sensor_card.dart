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
        final value = type == 'temperature'
        ? sensorVM.sensorData.temperature
        : sensorVM.sensorData.humidity;

    final progress = type == 'temperature'
        ? sensorVM.getTemperature()
        : sensorVM.getHumidity();
    
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ArcProgressBar(progress: progress, color: color, strokeWidth: 12),
            const SizedBox(height: 1),
            Text(
              "${value.toStringAsFixed(1)}",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
