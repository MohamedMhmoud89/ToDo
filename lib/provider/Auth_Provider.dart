import 'package:flutter/material.dart';
import 'package:todo/database/model/User.dart';

class AuthProvider extends ChangeNotifier {
  User? currentUser;

  void updateUser(User loggedInUser) {
    currentUser = loggedInUser;
    notifyListeners();
  }
}
