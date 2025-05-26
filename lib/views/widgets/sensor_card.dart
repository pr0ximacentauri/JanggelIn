import 'package:c3_ppl_agro/view_models/optimal_limit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:c3_ppl_agro/view_models/sensor_view_model.dart';

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
    final sensorVM  = Provider.of<SensorViewModel>(context);
    final optimalVM = Provider.of<OptimalLimitViewModel>(context);

    final optimalLimit = optimalVM.getById(sensorVM.sensorData?.fkOptimalLimit);

    String valueText = 'None';
    if (value == 'temperature' && sensorVM.hasSensorData) {
      valueText = '${sensorVM.temperature.toStringAsFixed(1)} °C';
    } else if (value == 'humidity' && sensorVM.hasSensorData) {
      valueText = '${sensorVM.humidity.toStringAsFixed(1)} %';
    }

    bool isOptimal = false;
    if (sensorVM.hasSensorData && optimalLimit != null) {
      isOptimal = (value == 'temperature')
          ? optimalVM.isTemperatureOptimal(sensorVM.temperature, optimalLimit)
          : optimalVM.isHumidityOptimal(sensorVM.humidity, optimalLimit);
    }

    final bool showNone = !sensorVM.hasSensorData || optimalLimit == null; 

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
                showNone ? 'None' : valueText,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: showNone
                      ? Colors.grey
                      : (isOptimal ? Colors.green : Colors.red),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  showNone
                      ? 'None'
                      : (isOptimal ? 'Optimal' : 'Tidak Optimal'),
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
