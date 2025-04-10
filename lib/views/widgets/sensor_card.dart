import 'package:flutter/material.dart';

class SensorCard extends StatelessWidget {
  final String title;
  final double value;
  final double minValue;
  final double maxValue;
  final Color color;

  const SensorCard({
    super.key,
    required this.title,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.color,

  });

  @override
  Widget build(BuildContext context) {
    double progress = ((value - minValue) / (maxValue - minValue)).clamp(0.0, 1.0);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSensorColumn(title, value, progress, color),
            const VerticalDivider(thickness: 1, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorColumn(String title, double value, double progress, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "${value.toStringAsFixed(1)}",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          height: 120,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              FractionallySizedBox(
                heightFactor: progress,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}