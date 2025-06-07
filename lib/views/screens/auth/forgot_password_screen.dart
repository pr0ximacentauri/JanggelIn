import 'package:c3_ppl_agro/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatelessWidget {
  final emailTxt = TextEditingController();

  ForgotPassword({super.key});

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
                  "Forgot Password",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF385A3C)),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Masukkan email kamu, kami akan mengirim link reset password.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black87),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: emailTxt,
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

                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C9A8B),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: authVM.isLoading
                      ? null
                      : () async {
                          final email = emailTxt.text.trim();
                          if (email.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Email tidak boleh kosong.")),
                            );
                            return;
                          }

                          final success = await authVM.forgotPassword(email);
                          if (success) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Berhasil"),
                                content: const Text("Link reset password telah dikirim ke email kamu."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("OK", style: TextStyle(color: Colors.black)),
                                  )
                                ],
                              ),
                            );
                          }
                        },
                  child: authVM.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text("Kirim Link Reset", style: TextStyle(color: Colors.black)),
                ),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Kembali ke Login", style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
