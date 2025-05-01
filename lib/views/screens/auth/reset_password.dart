import 'package:c3_ppl_agro/view_models/auth_view_model.dart';
import 'package:c3_ppl_agro/views/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final emailTxt = TextEditingController();
  final newPasswordTxt = TextEditingController();
  final confirmPasswordTxt = TextEditingController();
  bool emailVerified = false;
  bool showNewPassword = false;
  bool showConfirmPassword = false;

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
      backgroundColor: const Color(0xFFF0F4EF),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock, size: 64, color: Color(0xFF6C9A8B)),
                  const SizedBox(height: 16),
                  Text(
                    emailVerified ? "Masukkan Password Baru" : "Verifikasi Email",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF385A3C),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (!emailVerified) ...[
                    TextField(
                      controller: emailTxt,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.verified),
                      label: const Text("Verifikasi Email"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 68, 201, 97),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      ),
                      onPressed: () {
                        if (emailTxt.text.trim() == currentUserEmail) {
                          setState(() => emailVerified = true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Email tidak cocok dengan akun saat ini.")),
                          );
                        }
                      },
                    ),
                  ] else ...[
                    TextField(
                      controller: newPasswordTxt,
                      obscureText: !showNewPassword,
                      decoration: InputDecoration(
                        labelText: "Password Baru",
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(showNewPassword ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => showNewPassword = !showNewPassword),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: confirmPasswordTxt,
                      obscureText: !showConfirmPassword,
                      decoration: InputDecoration(
                        labelText: "Konfirmasi Password",
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(showConfirmPassword ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => showConfirmPassword = !showConfirmPassword),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text("Simpan Password Baru"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 68, 201, 97),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      ),
                      onPressed: () async {
                        final newPassword = newPasswordTxt.text.trim();
                        final confirmPassword = confirmPasswordTxt.text.trim();

                        if (newPassword.isEmpty || confirmPassword.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Password tidak boleh kosong.")),
                          );
                          return;
                        }

                        if (newPassword != confirmPassword) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Password tidak cocok.")),
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
                              content: const Text("Password berhasil diubah."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // tutup dialog
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const BottomNavbar(initialIndex: 3), // ke tab Profil
                                      ),
                                    );
                                  },
                                  child: const Text("OK"),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
