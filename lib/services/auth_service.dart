import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<AuthResponse> login({required String email, required String password}) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  }

  Future<void> forgotPassword(String email) async {
  return _client.auth.resetPasswordForEmail(
      email,
      redirectTo: 'janggelin://reset-password',
    );
  }


  Future<void> logout() async {
    return _client.auth.signOut();
  }

 User? get currentUser => _client.auth.currentUser;
}
