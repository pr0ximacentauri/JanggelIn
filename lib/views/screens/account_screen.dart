import 'package:c3_ppl_agro/view_models/auth_view_model.dart';
import 'package:c3_ppl_agro/views/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget{
  const AccountScreen({super.key});

   @override
   HomeScreenState createState() => HomeScreenState();
}

class AccountContent extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    //final deviceVM = Provider.of<DeviceViewModel>(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage("https://cdn-icons-png.flaticon.com/512/5987/5987424.png"),
              ),
              SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Owner",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text("Deskripsi", style: TextStyle(fontSize: 16, color: Colors.grey)),
                  
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}