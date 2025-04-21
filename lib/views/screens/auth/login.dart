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
      backgroundColor: Color(0xFFC8DCC3),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            TextField(controller: emailInput, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passwordInput, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
            const SizedBox(height: 20),
            if (authVM.error != null) Text(authVM.error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: authVM.isLoading ? null : () async {
                final success = await authVM.login(emailInput.text, passwordInput.text);
                if (success) {
                  Navigator.pushReplacementNamed(context, '/page');
                }
              },
              child: authVM.isLoading ? const CircularProgressIndicator() : const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
