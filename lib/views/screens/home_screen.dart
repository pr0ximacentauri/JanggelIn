import 'package:JanggelIn/view_models/sensor_view_model.dart';
import 'package:JanggelIn/views/widgets/bottom_navbar.dart';
import 'package:JanggelIn/views/widgets/pull_to_refresh.dart';
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
      backgroundColor: const Color(0xFFC8DCC3),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200),
        child: AppBar(
          backgroundColor: const Color(0xFF5E7154),
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
      body: PullToRefresh(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const SensorCard(
                title: 'Suhu saat ini',
                value: 'temperature',
              ),
              const SizedBox(height: 20),
              const SensorCard(
                title: 'Kelembapan saat ini',
                value: 'humidity',
              ),
              const SizedBox(height: 20),
              Text(
                sensorVM.updatedAtFormatted,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
