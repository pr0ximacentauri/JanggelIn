import 'package:c3_ppl_agro/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Register extends StatelessWidget {
  final emailInput = TextEditingController();
  final passwordInput = TextEditingController();

  Register({super.key});

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Color(0xFFC8DCC3),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailInput, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passwordInput, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
            const SizedBox(height: 20),
            if (authVM.error != null) Text(authVM.error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: authVM.isLoading
                  ? null
                  : () async {
                      final success = await authVM.register(emailInput.text, passwordInput.text);
                      if (success) {
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    },
              child: authVM.isLoading ? const CircularProgressIndicator() : const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
