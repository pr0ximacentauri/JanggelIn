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

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Ini History')
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}