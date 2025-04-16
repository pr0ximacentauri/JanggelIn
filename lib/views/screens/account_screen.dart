// import 'package:c3_ppl_agro/view_models/device_view_model.dart';
// import 'package:c3_ppl_agro/views/screens/home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class AccountScreen extends StatefulWidget{
//   const AccountScreen({super.key});

//    @override
//    _AccountScreenState createState() => _AccountScreenState();
// }

// class _AccountScreenState extends State<AccountScreen>{
//   int _selectedIndex = 0; 

//   final List<Widget> _pages = [
//     HomeContent(),
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
//       appBar: AppBar(
//         title: Text("IoT Remote"),
//         centerTitle: true,
//         backgroundColor: Colors.lightBlueAccent,
//       ),
//       backgroundColor: Colors.blueGrey,
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Akun"),
//         ],
//       ),
//     );
//   }
// }

// class AccountContent extends StatefulWidget{
//   @override
//   Widget build(BuildContext context) {
//     final deviceVM = Provider.of<DeviceViewModel>(context);

//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         children: [
//           Row(
            
//           ),
//         ],
//       ),
//     );
//   }
// }