import 'package:c3_ppl_agro/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  final bool fromDeepLink;

  const ResetPassword({super.key, this.fromDeepLink = false});

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

    if (widget.fromDeepLink) {
      emailVerified = true;
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C9A8B),
        title: const Text("Ubah Password"),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (!emailVerified) ...[
              const Text("Masukkan email akun kamu terlebih dahulu"),
              const SizedBox(height: 16),
              TextField(
                controller: emailTxt,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (emailTxt.text.trim() == currentUserEmail) {
                    setState(() => emailVerified = true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Email tidak cocok dengan akun saat ini")),
                    );
                  }
                },
                child: const Text("Verifikasi Email"),
              ),
            ] else ...[
              const Text(
                "Masukkan Password Baru",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPasswordTxt,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password Baru",
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordTxt,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Konfirmasi Password",
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
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
                  if (success) {
                    if (!mounted) return;
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Berhasil"),
                        content: const Text("Password berhasil diubah"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(context, '/page');
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text("Simpan Password Baru"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
