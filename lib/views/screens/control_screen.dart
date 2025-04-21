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

  Widget _buildAktuatorStatus(String name, bool isOn) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        ElevatedButton.icon(
          onPressed: null,
          icon: Icon(isOn ? Icons.power : Icons.power_off),
          label: Text(isOn ? 'ON' : 'OFF'),
          style: ElevatedButton.styleFrom(
            backgroundColor: isOn ? Colors.green : Colors.grey,
            foregroundColor: Colors.white,
            disabledBackgroundColor: isOn ? Colors.green : Colors.grey,
            disabledForegroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

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
                _buildAktuatorStatus("Pompa Air", pompa?.status == 'ON'),
                const SizedBox(height: 16),
                _buildAktuatorStatus("Kipas Exhaust", kipas?.status == 'ON'),
                const SizedBox(height: 16),
                _buildAktuatorStatus("Lampu Pijar", lampu?.status == 'ON'),
              ],
            ),
          ),
        );
      },
    );
  }
}
