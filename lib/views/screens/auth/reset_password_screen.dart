// ignore_for_file: deprecated_member_use

import 'package:c3_ppl_agro/view_models/auth_view_model.dart';
import 'package:c3_ppl_agro/views/screens/account_screen.dart';
import 'package:c3_ppl_agro/views/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  final bool fromDeepLink;
  final String? email;

  const ResetPassword({
    super.key,
    this.fromDeepLink = false,
    this.email,
  });

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final emailTxt = TextEditingController();
  final newPasswordTxt = TextEditingController();
  final confirmPasswordTxt = TextEditingController();
  bool emailVerified = false;

  @override
  void initState() {
    super.initState();
    if (widget.email != null) {
      emailTxt.text = widget.email!;
      if (widget.fromDeepLink) emailVerified = true;
    }
  }

  @override
  void dispose() {
    emailTxt.dispose();
    newPasswordTxt.dispose();
    confirmPasswordTxt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    final currentUserEmail = authVM.currentUserEmail ?? "";

    return Scaffold(
      backgroundColor: const Color(0xFFC8DCC3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5E7154),
        title: const Text("Reset Password"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                if (!emailVerified && !widget.fromDeepLink) ...[
                  const Text(
                    "Masukkan email kamu untuk verifikasi",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailTxt,
                    keyboardType: TextInputType.emailAddress,
                    readOnly: widget.email != null,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5E7154),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      if (emailTxt.text.trim() == currentUserEmail) {
                        setState(() => emailVerified = true);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Email tidak cocok dengan akun saat ini")),
                        );
                      }
                    },
                    child: const Text("Verifikasi Email", style: TextStyle(color: Colors.black)),
                  ),
                ] else ...[
                  const Text(
                    "Masukkan password baru kamu",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: newPasswordTxt,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password Baru",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: confirmPasswordTxt,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Konfirmasi Password",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5E7154),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () async {
                      final newPassword = newPasswordTxt.text.trim();
                      final confirmPassword = confirmPasswordTxt.text.trim();

                      if (newPassword.isEmpty || confirmPassword.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Password tidak boleh kosong")),
                        );
                        return;
                      }

                      if (newPassword != confirmPassword) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Password tidak cocok")),
                        );
                        return;
                      }

                      final success = await authVM.changePassword(newPassword);
                      if (!mounted) return;

                      if (success) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Berhasil"),
                            content: const Text("Password berhasil diubah"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => widget.fromDeepLink ? const Login() : const AccountScreen(),
                                    ),
                                  );
                                },
                                child: const Text("OK", style: TextStyle(color: Colors.black)),
                              ),
                            ],
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Password baru tidak boleh sama dengan yang lama")),
                        );
                      }
                    },
                    child: const Text("Simpan Password Baru", style: TextStyle(color: Colors.black)),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
