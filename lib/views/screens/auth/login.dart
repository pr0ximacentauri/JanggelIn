import 'package:c3_ppl_agro/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailTxt = TextEditingController();
  final passwordTxt = TextEditingController();
  bool isPasswordVisible = false;
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFC8DCC3),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/janggelin-logo.png',
                height: 150,
              ),
              const SizedBox(height: 12),
              const Text(
                "Selamat datang di\nJanggelin App",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2F4F2F),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),


              buildInputField(
                controller: emailTxt,
                label: "Email",
                icon: Icons.email,
                isPassword: false,
              ),
              const SizedBox(height: 16),

            
              buildInputField(
                controller: passwordTxt,
                label: "Password",
                icon: Icons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 12),

            
              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    activeColor: const Color(0xFF385A3C),
                    onChanged: (value) {
                      setState(() {
                        rememberMe = value ?? false;
                      });
                    },
                  ),
                  const Text(
                    "Ingat saya",
                    style: TextStyle(color: Color(0xFF385A3C)),
                  )
                ],
              ),

              const SizedBox(height: 16),

            
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5E7154),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 3,
                  ),
                  onPressed: authVM.isLoading
                      ? null
                      : () async {
                          final email = emailTxt.text.trim();
                          final password = passwordTxt.text.trim();

                          if (email.isEmpty) {
                            showSnackbar(context, "Email tidak boleh kosong!");
                            return;
                          } else if (password.isEmpty) {
                            showSnackbar(context, "Password tidak boleh kosong!");
                            return;
                          }

                          final success = await authVM.login(email, password);
                          if (success) {
                            Navigator.pushReplacementNamed(context, '/page');
                          } else {
                            showSnackbar(context, "Email atau password salah!");
                          }
                        },
                  child: authVM.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text("Login", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),

              const SizedBox(height: 20),

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
    );
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,
      keyboardType: isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.95),
        labelStyle: const TextStyle(color: Color(0xFF385A3C)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF6C9A8B), width: 2),
        ),
      ),
    );
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[400],
      ),
    );
  }
}
