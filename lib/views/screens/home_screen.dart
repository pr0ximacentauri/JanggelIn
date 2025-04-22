import 'package:c3_ppl_agro/view_models/sensor_view_model.dart';
import 'package:c3_ppl_agro/views/widgets/bottom_navbar.dart';
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
          SizedBox(height: 20),
          if(sensorVM.hasSensorData) ...[
            SensorCard(
              title: 'Suhu saat ini',
              value: 'temperature',
            ),
            SizedBox(height: 20),
            SensorCard(
              title: 'Kelembapan saat ini',
              value: 'humidity',
            ),
          ]else ...[
            SensorCard(
              title: 'Suhu saat ini',
              value: 'None',
            ),
            SizedBox(height: 20),
            SensorCard(
              title: 'Kelembapan saat ini',
              value: 'None',
            ),
          ],
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


// BottomNavbar
// class HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0; 

//   final List<Widget> _pages = [
//     HomeContent(),
//     ControlContent(),
//     HistoryContent(),
//     AccountContent(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blueGrey,
//       body: _pages[_selectedIndex], 
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         backgroundColor: Color(0xFF5E7154),
//         selectedItemColor: Color(0xFFC8DCC3),
//         unselectedItemColor: Colors.black,
//         showUnselectedLabels: true,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Beranda',
//           ),
//           BottomNavigationBarItem(
//             icon: Stack(
//               alignment: Alignment.center,
//               children: const [
//                 Icon(Icons.thermostat, size: 24),
//                 Positioned(
//                   bottom: 2,
//                   right: 2,
//                   child: Icon(
//                     Icons.water_drop,
//                     size: 12,
//                     color: Colors.lightBlueAccent,
//                   ),
//                 ),
//               ],
//             ),
//             label: 'Pengaturan',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.history),
//             label: 'Riwayat',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profil',
//           ),
//         ],
//       ),
//     );
//   }
// }