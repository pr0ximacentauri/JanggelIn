// ignore_for_file: deprecated_member_use
import 'package:JanggelIn/models/control.dart';
import 'package:JanggelIn/models/sensor_data.dart';
import 'package:JanggelIn/view_models/control_view_model.dart';
import 'package:JanggelIn/view_models/optimal_limit_view_model.dart';
import 'package:JanggelIn/view_models/sensor_view_model.dart';
import 'package:JanggelIn/views/widgets/bottom_navbar.dart';
import 'package:JanggelIn/views/widgets/pull_to_refresh.dart'; // pastikan ini diimport
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HistoryContent(),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}

class HistoryContent extends StatefulWidget {
  @override
  State<HistoryContent> createState() => _HistoryContentState();
}

class _HistoryContentState extends State<HistoryContent> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    final sensorVM = Provider.of<SensorViewModel>(context, listen: false);
    final optimalLimitVM = Provider.of<OptimalLimitViewModel>(context, listen: false);
    final controlVM = Provider.of<ControlViewModel>(context, listen: false);

    sensorVM.getSensorHistory();
    optimalLimitVM.getOptimalLimit();
    controlVM.getAllControls();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _resetFilter() {
    setState(() {
      selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sensorVM = Provider.of<SensorViewModel>(context);
    final controlVM = Provider.of<ControlViewModel>(context);
    final history = sensorVM.sensorHistory;

    if (history.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    String? selected = selectedDate != null
        ? DateFormat('dd-MM-yyyy').format(selectedDate!)
        : null;

    final filteredLogs = selected != null
        ? history.where((log) => DateFormat('dd-MM-yyyy').format(log.updatedAt) == selected).toList()
        : history;

    final pumpStatus = controlVM.controls.firstWhere(
      (c) => c.device?.name == 'Pompa Air',
      orElse: () => Control(id: 0, status: '-'),
    ).status;

    final fanStatus = controlVM.controls.firstWhere(
      (c) => c.device?.name == 'Kipas Exhaust',
      orElse: () => Control(id: 0, status: '-'),
    ).status;

    return Scaffold(
      backgroundColor: const Color(0xFFC8DCC3),
      appBar: AppBar(
        title: const Text('Log Data Sensor'),
        backgroundColor: const Color(0xFF5E7154),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: _pickDate,
            tooltip: 'Filter by Date',
          ),
          if (selectedDate != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _resetFilter,
              tooltip: 'Reset Filter',
            ),
        ],
      ),
      body: PullToRefresh(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(
                selectedDate != null
                    ? 'Filtered History (${DateFormat('dd-MM-yyyy').format(selectedDate!)})'
                    : 'History All',
              ),
              _buildDataTable(filteredLogs, pumpStatus, fanStatus),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF5E7154),
        ),
      ),
    );
  }

  Widget _buildDataTable(
    List<SensorData> logs,
    String pumpStatus,
    String fanStatus,
  ) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(const Color(0xFF5E7154)),
            headingTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            columnSpacing: 16,
            columns: const [
              DataColumn(label: Text('Waktu')),
              DataColumn(label: Text('Suhu')),
              DataColumn(label: Text('Kelembapan')),
              DataColumn(label: Text('Suhu Minimal')),
              DataColumn(label: Text('Suhu Maksimal')),
              DataColumn(label: Text('Kelembapan Minimal')),
              DataColumn(label: Text('Kelembapan Maksimal')),
              DataColumn(label: Text('Pompa Air')),
              DataColumn(label: Text('Kipas Exhaust')),
            ],
            rows: logs.map((log) {
              final limit = log.optimalLimit;
              return DataRow(
                cells: [
                  DataCell(Text(DateFormat('dd-MM-yyyy HH:mm').format(log.updatedAt))),
                  DataCell(Text('${log.temperature} °C')),
                  DataCell(Text('${log.humidity} %')),
                  DataCell(Text(limit != null ? '${limit.minTemperature} °C' : '-')),
                  DataCell(Text(limit != null ? '${limit.maxTemperature} °C' : '-')),
                  DataCell(Text(limit != null ? '${limit.minHumidity} %' : '-')),
                  DataCell(Text(limit != null ? '${limit.maxHumidity} %' : '-')),
                  DataCell(Text(pumpStatus)),
                  DataCell(Text(fanStatus)),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
