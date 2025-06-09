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
    if (widget.fromDeepLink && widget.email != null) {
      emailTxt.text = widget.email!;
      emailVerified = true;
    } else if (widget.email != null) {
      emailTxt.text = widget.email!;
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
                Text(
                  "Reset Password",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF385A3C)),
                ),
                const SizedBox(height: 12),
                if (!emailVerified && !widget.fromDeepLink) ...[
                  const Text(
                    "Masukkan email akun kamu terlebih dahulu untuk verifikasi",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: emailTxt,
                    readOnly: widget.email != null,
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: const TextStyle(color: Color(0xFF385A3C)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.green, width: 2),
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
                    onPressed: () {
                      if (widget.fromDeepLink && widget.email != null) {
                        setState(() => emailVerified = true);
                        return;
                      }

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
                    "Masukkan Password Baru",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF385A3C)),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: newPasswordTxt,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password Baru",
                      labelStyle: const TextStyle(color: Color(0xFF385A3C)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.green, width: 2),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: confirmPasswordTxt,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Konfirmasi Password",
                      labelStyle: const TextStyle(color: Color(0xFF385A3C)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.green, width: 2),
                      ),
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C9A8B),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
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

                      if (success && widget.fromDeepLink) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Berhasil"),
                            content: const Text("Password berhasil diubah"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => Login()));
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                        );
                      } else if (success) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Berhasil"),
                            content: const Text("Password berhasil diperbarui"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => AccountScreen()));
                                },
                                child: const Text("OK"),
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
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Kembali", style: TextStyle(color: Colors.black)),
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
