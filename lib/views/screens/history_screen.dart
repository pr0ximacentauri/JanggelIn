import 'package:c3_ppl_agro/views/screens/home_screen.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget{
  const HistoryScreen({super.key});

   @override
   HomeScreenState createState() => HomeScreenState();
}

class HistoryContent extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // final authVM = Provider.of<AuthViewModel>(context);

      return Scaffold(
        backgroundColor: Color(0xFFC8DCC3),
        appBar: AppBar(
          title: const Text('Log Data Sensor'),
          backgroundColor: Color(0xFF5E7154),
        ),
        body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Ini Log')
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}