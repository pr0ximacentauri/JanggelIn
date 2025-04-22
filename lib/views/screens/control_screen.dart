import 'package:c3_ppl_agro/views/widgets/aktuator_status.dart';
import 'package:c3_ppl_agro/views/widgets/bottom_navbar.dart';
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

class ControlContent extends StatelessWidget {
  final MinSuhuTxt = TextEditingController();
  final MaxSuhuTxt = TextEditingController();
  final MinKelembapanTxt = TextEditingController();
  final MaxKelembapanTxt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ControlViewModel>(
      builder: (context, controlVM, _) {
        final pompa = controlVM.getControlById(1);
        final kipas = controlVM.getControlById(2);
        final lampu = controlVM.getControlById(3);

        return Scaffold(
          appBar: AppBar(
            title: const Text("Kontrol & Pengaturan Batasan"),
            backgroundColor: const Color(0xFF5E7154),
          ),
          backgroundColor: const Color(0xFFC8DCC3),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                AktuatorStatus(name: "Pompa Air", isOn:  pompa?.status == 'ON'),
                const SizedBox(height: 16),
                AktuatorStatus(name: "Kipas Exhaust", isOn: kipas?.status == 'ON'),
                const SizedBox(height: 16),
                AktuatorStatus(name: "Lampu Pijar", isOn: lampu?.status == 'ON'),
                
                const SizedBox(height: 24),
                const Divider(thickness: 1, color: Colors.grey),

                Text("Pengaturan Batasan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF385A3C))),
                const SizedBox(height: 16),
                TextField(
                  controller: MinSuhuTxt,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Minimal Batas Suhu",
                    labelStyle: TextStyle(color: const Color(0xFF385A3C)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                    prefixIcon: const Icon(Icons.thermostat),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: MaxSuhuTxt,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Maksimal Batas Suhu",
                    labelStyle: TextStyle(color: const Color(0xFF385A3C)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                    prefixIcon: const Icon(Icons.thermostat),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: MinKelembapanTxt,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Minimal Batas Kelembapan",
                    labelStyle: TextStyle(color: const Color(0xFF385A3C)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                    prefixIcon: const Icon(Icons.water_drop),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: MaxKelembapanTxt,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Maksimal Batas Kelembapan",
                    labelStyle: TextStyle(color: const Color(0xFF385A3C)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                    prefixIcon: const Icon(Icons.water_drop),
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}
