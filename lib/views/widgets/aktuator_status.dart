import 'package:flutter/material.dart';

class AktuatorStatus extends StatelessWidget {
  final String name;
  final bool isOn;

  const AktuatorStatus({
    super.key,
    required this.name,
    required this.isOn,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        ElevatedButton.icon(
          onPressed: null,
          icon: Icon(isOn ? Icons.power : Icons.power_off),
          label: Text(isOn ? 'ON' : 'OFF'),
          style: ElevatedButton.styleFrom(
            backgroundColor: isOn ? Colors.green : Colors.grey,
            foregroundColor: Colors.white,
            disabledBackgroundColor: isOn ? Colors.green : Colors.grey,
            disabledForegroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
