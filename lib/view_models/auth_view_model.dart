import 'package:c3_ppl_agro/models/user.dart';
import 'package:flutter/material.dart';

class AuthViewModel with ChangeNotifier {
  User _user = User(
    id: 1,
    username: 'Owner',
    password: 'admin123',
    );

  User get user => _user;


}

