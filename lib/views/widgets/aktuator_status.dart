import 'package:c3_ppl_agro/models/control.dart';
import 'package:flutter/material.dart';

class AktuatorStatus extends StatelessWidget {
  final Control control;

  const AktuatorStatus({
    super.key,
    required this.control,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOn = control.status == 'ON';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          control.perangkat?.name ?? 'Unknown',
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
