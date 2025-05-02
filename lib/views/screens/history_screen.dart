// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:c3_ppl_agro/views/widgets/bottom_navbar.dart';

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

  final List<Map<String, dynamic>> dummyLogs = [
    {
      'timestamp': '29-04-2025 08:30',
      'temperature': 27.5,
      'humidity': 75.0,
      'minTemp': 25.0,
      'maxTemp': 30.0,
      'minHumid': 70.0,
      'actuators': {'lampu': 'OFF', 'kipas': 'OFF', 'pompa': 'OFF'}
    },
    {
      'timestamp': '29-04-2025 08:00',
      'temperature': 24.0,
      'humidity': 68.0,
      'minTemp': 25.0,
      'maxTemp': 30.0,
      'minHumid': 70.0,
      'actuators': {'lampu': 'ON', 'kipas': 'OFF', 'pompa': 'ON'}
    },
    {
      'timestamp': '29-04-2025 07:30',
      'temperature': 31.2,
      'humidity': 72.0,
      'minTemp': 25.0,
      'maxTemp': 30.0,
      'minHumid': 70.0,
      'actuators': {'lampu': 'OFF', 'kipas': 'ON', 'pompa': 'OFF'}
    },
  ];

  List<Map<String, dynamic>> _filterLogsByDate(String targetDate) {
    return dummyLogs
        .where((log) => log['timestamp'].startsWith(targetDate))
        .toList();
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
    String today = DateFormat('dd-MM-yyyy').format(DateTime.now());
    String? selected = selectedDate != null
        ? DateFormat('dd-MM-yyyy').format(selectedDate!)
        : null;

    final todayLogs = _filterLogsByDate(today);
    final filteredLogs = selected != null ? _filterLogsByDate(selected) : dummyLogs;

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

  Widget _buildDataTable(List<Map<String, dynamic>> logs) {
    return Card(
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
            DataColumn(label: Text('Lampu')),
            DataColumn(label: Text('Kipas')),
            DataColumn(label: Text('Pompa')),
          ],
          rows: logs.map((log) {
            return DataRow(
              cells: [
                DataCell(Text(log['timestamp'])),
                DataCell(Text('${log['temperature']} °C')),
                DataCell(Text('${log['humidity']} %')),
                DataCell(Text(log['actuators']['lampu'])),
                DataCell(Text(log['actuators']['kipas'])),
                DataCell(Text(log['actuators']['pompa'])),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}