// import 'package:c3_ppl_agro/view_models/auth_view_model.dart';
import 'package:c3_ppl_agro/views/screens/home_screen.dart';
import 'package:flutter/material.dart';

class ControlScreen extends StatefulWidget{
  const ControlScreen({super.key});

   @override
   HomeScreenState createState() => HomeScreenState();
}

class ControlContent extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // final authVM = Provider.of<AuthViewModel>(context);

      return Scaffold(
        backgroundColor: Color(0xFFC8DCC3),
        appBar: AppBar(
          title: const Text('Kontrol IoT'),
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
                Text('Ini Control')
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}