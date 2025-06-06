import 'package:c3_ppl_agro/models/optimal_limit.dart';
import 'package:c3_ppl_agro/view_models/optimal_limit_view_model.dart';
import 'package:c3_ppl_agro/view_models/sensor_view_model.dart';
import 'package:flutter/material.dart';

class OptimalLimitDropdown extends StatefulWidget {
  final List<OptimalLimit> limits;
  final SensorViewModel sensorVM;
  final OptimalLimitViewModel optimalLimitVM;
  final void Function(OptimalLimit) onLimitChanged;

  const OptimalLimitDropdown({
    Key? key,
    required this.limits,
    required this.sensorVM,
    required this.optimalLimitVM,
    required this.onLimitChanged
  }) : super(key: key);


  @override
  _OptimalLimitDropdownState createState() => _OptimalLimitDropdownState();
}

class _OptimalLimitDropdownState extends State<OptimalLimitDropdown> {
  OptimalLimit? selectedLimit;

  @override
  void initState() {
    super.initState();

    selectedLimit = widget.optimalLimitVM.selectedLimit;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: selectedLimit?.id,
      items: widget.limits.map((limit) {
        return DropdownMenuItem<int>(
          value: limit.id,
          child: Text('Suhu: ${limit.minTemperature}-${limit.maxTemperature}, Kelembapan: ${limit.minHumidity}-${limit.maxHumidity}'),
        );
      }).toList(),
      onChanged: (int? id) async{
        final newLimit = widget.limits.firstWhere((limit) => limit.id == id);
        setState(() {
          selectedLimit = newLimit;
        });
        widget.optimalLimitVM.setSelectedLimit(newLimit);
        await widget.optimalLimitVM.publishSelectedLimit();
        widget.onLimitChanged(newLimit);
      }
    );

  }
}
