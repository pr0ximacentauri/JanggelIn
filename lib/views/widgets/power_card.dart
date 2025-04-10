import 'package:flutter/material.dart';

class PowerCard extends StatelessWidget {
  final bool isOn;
  final VoidCallback onToggle;

  const PowerCard({super.key, required this.isOn, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Status: ${isOn ? "ON" : "OFF"}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: onToggle,
              style: ElevatedButton.styleFrom(
                backgroundColor: isOn ? Colors.red : Colors.green,
                padding: EdgeInsets.symmetric(horizontal:80, vertical: 20),
              ),
              child: Text(isOn ? "MATIKAN" : "HIDUPKAN", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
