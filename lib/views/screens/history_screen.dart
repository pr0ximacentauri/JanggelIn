// ignore_for_file: deprecated_member_use

import 'package:c3_ppl_agro/views/widgets/bottom_navbar.dart';
import 'package:c3_ppl_agro/view_models/sensor_view_model.dart';
import 'package:c3_ppl_agro/models/sensor_data.dart';
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
    final viewModel = Provider.of<SensorViewModel>(context, listen: false);
    viewModel.getSensorHistory();
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
    final viewModel = Provider.of<SensorViewModel>(context);
    final history = viewModel.sensorHistory;

    if(history.isEmpty){
      return const Center(child: CircularProgressIndicator());
    }
    String today = DateFormat('dd-MM-yyyy').format(DateTime.now());
    String? selected = selectedDate != null
        ? DateFormat('dd-MM-yyyy').format(selectedDate!)
        : null;
    final todayLogs = history.where((log) =>
        DateFormat('dd-MM-yyyy').format(log.updatedAt) == today).toList();

    final filteredLogs = selected != null
        ? history.where((log) =>
            DateFormat('dd-MM-yyyy').format(log.updatedAt) == selected).toList()
        : history;

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            if (selectedDate == null)
              _buildSectionTitle('History Today'),
            if (selectedDate == null) _buildDataTable(todayLogs),
            
            const SizedBox(height: 20),

            
            _buildSectionTitle(
              selectedDate != null
                  ? 'Filtered History (${DateFormat('dd-MM-yyyy').format(selectedDate!)})'
                  : 'History All',
            ),
            _buildDataTable(filteredLogs),
          ],
        ),
      ),
    );
  }
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5E7154)),
      ),
    );
  }

  Widget _buildDataTable(List<SensorData> logs) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(const Color(0xFF5E7154)),
            headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            columnSpacing: 16,
            columns: const [
              DataColumn(label: Text('Waktu')),
              DataColumn(label: Text('Suhu')),
              DataColumn(label: Text('Kelembapan')),
            ],
            rows: logs.map((log) {
              return DataRow(
                cells: [
                  DataCell(Text(DateFormat('dd-MM-yyyy HH:mm').format(log.createdAt))),
                  DataCell(Text('${log.temperature} °C')),
                  DataCell(Text('${log.humidity} %')),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}