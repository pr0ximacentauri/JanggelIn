import 'package:c3_ppl_agro/view_models/auth_view_model.dart';
import 'package:c3_ppl_agro/views/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatelessWidget{
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavbar();
  }
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
                    Text(
                      authVM.currentUserEmail ?? 'Belum ada akun',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            const Divider(thickness: 1, color: Colors.grey),
            ListTile(
              leading: const Icon(Icons.account_circle_sharp),
              title: const Text('Ubah Password'),
              onTap: () {
                Navigator.pushNamed(context, '/forgot-password');
              },
            ),
            const Divider(thickness: 1, color: Colors.grey),
            
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifikasi'),
              onTap: () {
                
              },
            ),
            const Divider(thickness: 1, color: Colors.grey),

            ListTile(
              leading: const Icon(Icons.contact_support),
              title: const Text('Bantuan'),
              onTap: () {
                
              },
            ),
            const Divider(thickness: 1, color: Colors.grey),

            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Tentang Aplikasi'),
              onTap: () {
                
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
                final confirmLogout = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Color(0xFF5E7154),
                    title: const Text("Konfirmasi"),
                    content: const Text("Apakah kamu yakin ingin logout?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Batal", style: TextStyle(color: Colors.black),),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("Logout", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );

                if (confirmLogout == true){
                  await authVM.logout();  
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}