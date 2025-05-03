import 'package:c3_ppl_agro/models/optimal_limit.dart';
import 'package:c3_ppl_agro/view_models/optimal_limit_view_model.dart';
import 'package:c3_ppl_agro/view_models/sensor_view_model.dart';
import 'package:c3_ppl_agro/views/widgets/aktuator_status.dart';
import 'package:c3_ppl_agro/views/widgets/bottom_navbar.dart';
import 'package:c3_ppl_agro/views/widgets/optimal_limit_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:c3_ppl_agro/view_models/control_view_model.dart';

class ControlScreen extends StatelessWidget{
  const ControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavbar();
  }
}

class ControlContent extends StatefulWidget {
  @override
  _ControlContentState createState() => _ControlContentState();
}

class _ControlContentState extends State<ControlContent> {
  final MinSuhuTxt = TextEditingController();
  final MaxSuhuTxt = TextEditingController();
  final MinKelembapanTxt = TextEditingController();
  final MaxKelembapanTxt = TextEditingController();

  @override
  void dispose() {
    MinSuhuTxt.dispose();
    MaxSuhuTxt.dispose();
    MinKelembapanTxt.dispose();
    MaxKelembapanTxt.dispose();
    super.dispose();
  }

  void _setInitialLimitText(OptimalLimit? limit) {
    if (limit != null) {
      MinSuhuTxt.text = limit.minTemperature.toString();
      MaxSuhuTxt.text = limit.maxTemperature.toString();
      MinKelembapanTxt.text = limit.minHumidity.toString();
      MaxKelembapanTxt.text = limit.maxHumidity.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SensorViewModel, OptimalLimitViewModel>(
      builder: (context, sensorVM, optimalLimitVM, _) {
        final latestSensor =  sensorVM.sensorData;
        final pompa = latestSensor?.statusPompa ?? "OFF";
        final kipas = latestSensor?.statusKipas ?? "OFF";
        final lampu = latestSensor?.statusLampu ?? "OFF";
        final limit = optimalLimitVM.limit;

        if (MinSuhuTxt.text.isEmpty && limit != null) {
          _setInitialLimitText(limit);
        }

        return Scaffold(
          appBar: AppBar(title: const Text("Kontrol & Pengaturan Batasan"), backgroundColor: const Color(0xFF5E7154)),
          backgroundColor: const Color(0xFFC8DCC3),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AktuatorStatus(name: "Pompa Air", status: pompa), 
                  const SizedBox(height: 16),
                  AktuatorStatus(name: "Kipas Exhaust", status: kipas),
                  const SizedBox(height: 16),
                  AktuatorStatus(name: "Lampu Pijar", status: lampu),
                  const Divider(thickness: 1, color: Colors.grey),

                  SizedBox(height: 20),
                  Text("Pilih batas optimal:"),
                    if (optimalLimitVM.limits.isEmpty)
                      CircularProgressIndicator()
                    else
                      OptimalLimitDropdown(
                        limits: optimalLimitVM.limits,
                        sensorVM: sensorVM,
                    ),
                  Text("Pengaturan Batasan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 16),
                  TextField(controller: MinSuhuTxt, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Minimal Batas Suhu")),
                  const SizedBox(height: 12),
                  TextField(controller: MaxSuhuTxt, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Maksimal Batas Suhu")),
                  const SizedBox(height: 12),
                  TextField(controller: MinKelembapanTxt, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Minimal Batas Kelembapan")),
                  const SizedBox(height: 12),
                  TextField(controller: MaxKelembapanTxt, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Maksimal Batas Kelembapan")),
                  
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      final minSuhu = double.tryParse(MinSuhuTxt.text.trim()) ?? 0.0;
                      final maxSuhu = double.tryParse(MaxSuhuTxt.text.trim()) ?? 0.0;
                      final minKelembapan = double.tryParse(MinKelembapanTxt.text.trim()) ?? 0.0;
                      final maxKelembapan = double.tryParse(MaxKelembapanTxt.text.trim()) ?? 0.0;

                      await optimalLimitVM.updateOptimalLimit(
                        minTemperature: minSuhu,
                        maxTemperature: maxSuhu,
                        minHumidity: minKelembapan,
                        maxHumidity: maxKelembapan,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Batas optimal berhasil diperbarui')),
                      );
                    },
                    child: const Text("Simpan", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF385A3C)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
