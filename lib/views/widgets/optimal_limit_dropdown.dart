import 'package:c3_ppl_agro/models/optimal_limit.dart';
import 'package:c3_ppl_agro/view_models/optimal_limit_view_model.dart';
import 'package:c3_ppl_agro/view_models/sensor_view_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

     _loadSelectedLimit();
  }

  Future<void> _loadSelectedLimit() async {
  final prefs = await SharedPreferences.getInstance();
  final savedId = prefs.getInt('selected_optimal_limit_id');

  if (savedId != null) {
    final savedLimit = widget.limits.firstWhere(
      (limit) => limit.id == savedId,
      orElse: () => widget.limits.first,
    );

    setState(() {
      selectedLimit = savedLimit;
    });

    widget.optimalLimitVM.setSelectedLimit(savedLimit);
    await widget.optimalLimitVM.publishSelectedLimit();
    widget.onLimitChanged(savedLimit);
    } else {
      final firstLimit = widget.limits.first;
      setState(() {
        selectedLimit = firstLimit;
      });

      widget.optimalLimitVM.setSelectedLimit(firstLimit);
      await widget.optimalLimitVM.publishSelectedLimit();
      widget.onLimitChanged(firstLimit);
    }
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

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('selected_optimal_limit_id', newLimit.id);
      }
    );

  }
}
