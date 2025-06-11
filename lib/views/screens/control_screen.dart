import 'package:c3_ppl_agro/models/optimal_limit.dart';
import 'package:c3_ppl_agro/view_models/optimal_limit_view_model.dart';
import 'package:c3_ppl_agro/view_models/sensor_view_model.dart';
import 'package:c3_ppl_agro/views/widgets/aktuator_status.dart';
import 'package:c3_ppl_agro/views/widgets/bottom_navbar.dart';
import 'package:c3_ppl_agro/views/widgets/optimal_limit_dropdown.dart';
import 'package:c3_ppl_agro/views/widgets/pull_to_refresh.dart';
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
  bool _isInitialized = false;

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

    @override
    void initState() {
      super.initState();
      
      Future.microtask(() {
        final controlVM = Provider.of<ControlViewModel>(context, listen: false);
        controlVM.init();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ControlViewModel, OptimalLimitViewModel, SensorViewModel>(
      builder: (context, controlVM, optimalLimitVM, sensorVM, _) {
        final pompa = controlVM.getControlByDeviceId(1);
        final kipas = controlVM.getControlByDeviceId(2);
        // final lampu = controlVM.getControlById(3);

        if (!_isInitialized && optimalLimitVM.limits.isNotEmpty && sensorVM.sensorData != null) {
          final defaultLimit = optimalLimitVM.selectedLimit;
          if (defaultLimit != null) {
            _setInitialLimitText(defaultLimit);
            _isInitialized = true;
          }
        }

        return Scaffold(
          appBar: AppBar(title: const Text("Kontrol & Pengaturan Batasan"), backgroundColor: const Color(0xFF5E7154)),
          backgroundColor: const Color(0xFFC8DCC3),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: PullToRefresh(
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Text("Aktuator", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  AktuatorStatus(controlAsync: pompa),
                  const SizedBox(height: 16),
                  AktuatorStatus(controlAsync: kipas),
                  const SizedBox(height: 16),
                  const Divider(thickness: 1, color: Colors.grey),

                  const SizedBox(height: 20),
                  Text("Pilih batas optimal:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  if (optimalLimitVM.limits.isEmpty)
                    CircularProgressIndicator()
                  else
                    OptimalLimitDropdown(
                      limits: optimalLimitVM.limits,
                      sensorVM: sensorVM,
                      optimalLimitVM: optimalLimitVM,
                      onLimitChanged: (limit) =>_setInitialLimitText(limit)
                    ),

                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final selected = optimalLimitVM.selectedLimit;
                      if (selected == null) return;

                      if (selected == optimalLimitVM.selectedLimit) {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Konfirmasi Hapus"),
                            content: const Text("Batas optimal ini sedang dipilih. Apakah yakin ingin menghapus?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text("Batal"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text("Hapus", style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await optimalLimitVM.deleteOptimalLimit(selected.id);
                          final updatedLimits = optimalLimitVM.limits;

                          setState(() {
                            MinSuhuTxt.clear();
                            MaxSuhuTxt.clear();
                            MinKelembapanTxt.clear();
                            MaxKelembapanTxt.clear();

                            if(updatedLimits.isNotEmpty) {
                              final newSelectedLimit = updatedLimits.first;
                              optimalLimitVM.setSelectedLimit(newSelectedLimit);
                              _setInitialLimitText(newSelectedLimit);
                            }else {
                              optimalLimitVM.setSelectedLimit(null);
                            }
                          });
                          optimalLimitVM.updateSelectedLimitAfterDeletion(optimalLimitVM.limits);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Batas optimal berhasil dihapus")),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.delete, color: Colors.white),
                    label: const Text("Hapus Batas Ini", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),

                  const SizedBox(height: 16),
                  Text("Pengaturan Batasan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: MinSuhuTxt,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: "Minimal Batas Suhu"),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: MaxSuhuTxt,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: "Maksimal Batas Suhu"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: MinKelembapanTxt,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: "Minimal Batas Kelembapan"),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: MaxKelembapanTxt,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: "Maksimal Batas Kelembapan"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      final minSuhu = double.tryParse(MinSuhuTxt.text.trim());
                      final maxSuhu = double.tryParse(MaxSuhuTxt.text.trim());
                      final minKelembapan = double.tryParse(MinKelembapanTxt.text.trim());
                      final maxKelembapan = double.tryParse(MaxKelembapanTxt.text.trim());

                      if (minSuhu == null || maxSuhu == null || minKelembapan == null || maxKelembapan == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Harap lengkapi semua data terlebih dahulu'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      }

                      final isSameSuhu = minSuhu == maxSuhu;
                      final isSameKelembapan = minKelembapan == maxKelembapan;


                      if (isSameSuhu || isSameKelembapan) {
                        String message = "Batas minimal dan maksimal ";

                        if (isSameSuhu && isSameKelembapan) {
                          message += "suhu dan kelembapan tidak boleh sama";
                        } else if (isSameSuhu) {
                          message += "suhu tidak boleh sama";
                        } else {
                          message += "kelembapan tidak boleh sama";
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(message)),
                        );
                        return; 
                      }
                     
                      final isDuplicate = optimalLimitVM.limits.any((limit) =>
                        limit.minTemperature == minSuhu &&
                        limit.maxTemperature == maxSuhu &&
                        limit.minHumidity == minKelembapan &&
                        limit.maxHumidity == maxKelembapan
                      );

                      if (isDuplicate) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Data dengan batas tersebut sudah ada!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      }
                     
                      await optimalLimitVM.updateOptimalLimit(
                        minTemperature: minSuhu,
                        maxTemperature: maxSuhu,
                        minHumidity: minKelembapan,
                        maxHumidity: maxKelembapan,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Batas optimal berhasil diperbarui'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF385A3C)),
                    child: const Text("Simpan", style: TextStyle(color: Colors.white)),
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