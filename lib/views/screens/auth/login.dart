import 'package:c3_ppl_agro/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  final emailInput = TextEditingController();
  final passwordInput = TextEditingController();

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFC8DCC3),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Janggelin",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF385A3C)),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Silakan login untuk melanjutkan",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 24),

                TextField(
                  controller: emailInput,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: const Color(0xFF385A3C)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.green, width: 2), // warna saat fokus
                    ),
                    prefixIcon: const Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: passwordInput,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(color: const Color(0xFF385A3C)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.green, width: 2), // warna saat fokus
                    ),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                ),

                // if (authVM.error != null) ...[
                //   const SizedBox(height: 12),
                //   Text(authVM.error!, style: const TextStyle(color: Colors.red)),
                // ],

                const SizedBox(height: 24),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C9A8B),
                    padding: const EdgeInsets.symmetric(horizontal: 126, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: authVM.isLoading
                      ? null
                      : () async {
                          final success = await authVM.login(emailInput.text, passwordInput.text);
                          if (success) {
                            Navigator.pushReplacementNamed(context, '/page');
                          }
                          final email = await emailInput.text.trim();
                          final password = await passwordInput.text.trim();
                          if (email.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Email tidak boleh kosong!")),
                            );
                            return;
                          }
                          else if (password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Password tidak boleh kosong!")),
                            );
                            return;
                          }
                          
                        },
                  child: authVM.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text("Login", style: TextStyle(fontSize: 16, color: Colors.black)),
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/forgot-password');
                  },
                  child: const Text(
                    "Lupa Password?",
                    style: TextStyle(color: Color(0xFF385A3C)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
