import 'package:c3_ppl_agro/view_models/control_view_model.dart';
import 'package:c3_ppl_agro/view_models/optimal_limit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:c3_ppl_agro/view_models/sensor_view_model.dart';
import 'progress_bar.dart';


class SensorCard extends StatelessWidget {
  final String title;
  final String value;

  const SensorCard({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final sensorVM = Provider.of<SensorViewModel>(context);
    final optimalVM = Provider.of<OptimalLimitViewModel>(context, listen: false);
    final controlVM = Provider.of<ControlViewModel>(context, listen: false);

    String valueText = '0.0';
    if (value == 'temperature') {
      valueText = sensorVM.temperature.toStringAsFixed(1) + ' °C';
    } else if (value == 'humidity') {
      valueText = sensorVM.humidity.toStringAsFixed(1) + ' %';
    }

    bool isOptimal = (value == 'temperature')
      ? optimalVM.isTemperatureOptimal(sensorVM.temperature)
      : optimalVM.isHumidityOptimal(sensorVM.humidity);

    String statusText = isOptimal ? 'Optimal' : 'Tidak Optimal';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      sensorVM.evaluateAndControl(optimalVM, controlVM);
    });

    print('Sensor Data: ${sensorVM.temperature}, ${sensorVM.humidity}');
    print('Optimal Temperature: ${optimalVM.limit?.minTemperature} - ${optimalVM.limit?.maxTemperature}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFAEBDA2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                valueText,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isOptimal ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
