import 'package:c3_ppl_agro/view_models/optimal_limit_view_model.dart';
import 'package:c3_ppl_agro/view_models/sensor_view_model.dart';
import 'package:c3_ppl_agro/views/widgets/bottom_navbar.dart';
import 'package:c3_ppl_agro/views/widgets/optimal_limit_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/sensor_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return BottomNavbar();
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sensorVM = Provider.of<SensorViewModel>(context);

    return Scaffold(
      backgroundColor: Color(0xFFC8DCC3),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200),
        child: AppBar(
          backgroundColor: Color(0xFF5E7154),
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(left: 20, right: 0, bottom: 0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 70),
                    Text(
                      'Hai 👋',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Selamat datang',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'di Janggelin App',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    'assets/jamur.png',
                    height: 400,
                  ),
                ),
              ],
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(40),
              bottomLeft: Radius.circular(30),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // SizedBox(height: 20),
          // Text("Pilih batas optimal:"),
          //   if (optimalVM.limits.isEmpty)
          //     CircularProgressIndicator()
          //   else
          //     OptimalLimitDropdown(
          //       limits: optimalVM.limits,
          //       sensorVM: sensorVM,
          //     ),
          SizedBox(height: 20),
            SensorCard(
              title: 'Suhu saat ini',
              value: 'temperature',
            ),
            SizedBox(height: 20),
            SensorCard(
              title: 'Kelembapan saat ini',
              value: 'humidity',
            ),
            const SizedBox(height: 20),
            Text(
              sensorVM.updatedAtFormatted,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
      
    );
  }
}