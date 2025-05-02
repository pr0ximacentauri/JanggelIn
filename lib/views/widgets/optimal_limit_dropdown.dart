import 'package:c3_ppl_agro/models/optimal_limit.dart';
import 'package:c3_ppl_agro/view_models/sensor_view_model.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';


class OptimalLimitDropdown extends StatefulWidget {
  final List<OptimalLimit> limits;
  final SensorViewModel sensorVM;

  const OptimalLimitDropdown({
    Key? key,
    required this.limits,
    required this.sensorVM,
  }) : super(key: key);

  @override
  _OptimalLimitDropdownState createState() => _OptimalLimitDropdownState();
}

class _OptimalLimitDropdownState extends State<OptimalLimitDropdown> {
  OptimalLimit? selectedLimit;

  @override
  void initState() {
    super.initState();

    final currentFk = widget.sensorVM.sensorData?.fkOptimalLimit;

    selectedLimit = widget.limits.firstWhereOrNull(
      (limit) => limit.id == currentFk,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<OptimalLimit>(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      value: selectedLimit,
      hint: const Text("Pilih batas optimal", style: TextStyle(color: Colors.black)),
      isExpanded: true,
      items: widget.limits.map((limit) {
        return DropdownMenuItem<OptimalLimit>(
          value: limit,
          child: Text('Suhu: ${limit.minTemperature}-${limit.maxTemperature},''Kelembapan: ${limit.minHumidity}-${limit.maxHumidity}'),
        );
      }).toList(),
      onChanged: (OptimalLimit? newLimit) async {
        if (newLimit != null) {
          setState(() {
            selectedLimit = newLimit;
          });
          await widget.sensorVM.setSensorOptimalLimit(newLimit.id);
        }
      },
    );
  }
}
