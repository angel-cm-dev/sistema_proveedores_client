import 'package:flutter/material.dart';

enum UserRole { admin, operator, client, guest }

class AuthProvider extends ChangeNotifier {
  UserRole _role = UserRole.guest;

  UserRole get role => _role;

  // Login simulado (Aquí luego conectarás con Yoel - Backend)
  void login(String selectedRole) => {
    if (selectedRole == 'admin')
      _role = UserRole.admin
    else if (selectedRole == 'operator')
      _role = UserRole.operator
    else
      _role = UserRole.client,
    notifyListeners(),
  };

  void logout() => {_role = UserRole.guest, notifyListeners()};
}
