import 'package:JanggelIn/view_models/control_view_model.dart';
import 'package:JanggelIn/view_models/optimal_limit_view_model.dart';
import 'package:JanggelIn/view_models/sensor_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PullToRefresh extends StatelessWidget {
  final Widget child;

  const PullToRefresh({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<ControlViewModel>().getAllControls();
        await context.read<SensorViewModel>().getSensorData();
        await context.read<OptimalLimitViewModel>().getAllOptimalLimits();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: child,
      ),
    );
  }
}
