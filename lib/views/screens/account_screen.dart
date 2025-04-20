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
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Color(0xFFC8DCC3),
      appBar: AppBar(
        title: const Text('Akun Pengguna'),
        backgroundColor: Color(0xFF5E7154),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profil Pengguna
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    "https://cdn-icons-png.flaticon.com/512/5987/5987424.png",
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Owner",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Deskripsi",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            const Divider(thickness: 1, color: Colors.grey),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifikasi'),
              onTap: () {
                
              },
            ),
            const Divider(thickness: 1, color: Colors.grey),
            
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text('Tema'),
              onTap: () {
                
              },
            ),
            const Divider(thickness: 1, color: Colors.grey),

            ListTile(
              leading: const Icon(Icons.contact_support),
              title: const Text('Bantuan'),
              onTap: () {
                // Navigator.pushNamed(context, '/bantuan');
              },
            ),
            const Divider(thickness: 1, color: Colors.grey),

            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Tentang Aplikasi'),
              onTap: () {
                // Navigator.pushNamed(context, '/bantuan');
              },
            ),
            const Divider(thickness: 1, color: Colors.grey),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {
                await authVM.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}