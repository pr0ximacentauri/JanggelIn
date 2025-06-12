import 'package:JanggelIn/models/optimal_limit.dart';
import 'package:JanggelIn/view_models/optimal_limit_view_model.dart';
import 'package:JanggelIn/view_models/sensor_view_model.dart';
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
    required this.onLimitChanged,
  }) : super(key: key);

  @override
  _OptimalLimitDropdownState createState() => _OptimalLimitDropdownState();
}

class _OptimalLimitDropdownState extends State<OptimalLimitDropdown> {
  @override
  void initState() {
    super.initState();

    widget.optimalLimitVM.addListener(_onVMChanged);
  }

  @override
  void dispose() {
    widget.optimalLimitVM.removeListener(_onVMChanged);
    super.dispose();
  }

  void _onVMChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.optimalLimitVM.selectedLimit;

    final validSelected = selected != null &&
            widget.limits.any((limit) => limit.id == selected.id)
        ? selected
        : (widget.limits.isNotEmpty ? widget.limits.first : null);

    return DropdownButton<int>(
      value: validSelected?.id,
      items: widget.limits.map((limit) {
        return DropdownMenuItem<int>(
          value: limit.id,
          child: Text(
              'Suhu: ${limit.minTemperature}-${limit.maxTemperature}, Kelembapan: ${limit.minHumidity}-${limit.maxHumidity}'),
        );
      }).toList(),
      onChanged: (int? id) async {
        if (id == null) return;

        final newLimit = widget.limits.firstWhere((limit) => limit.id == id);

        widget.optimalLimitVM.setSelectedLimit(newLimit);
        await widget.optimalLimitVM.saveSelectedLimit(newLimit.id);
        await widget.optimalLimitVM.publishSelectedLimit();
        widget.onLimitChanged(newLimit);
      },
    );
  }
}
