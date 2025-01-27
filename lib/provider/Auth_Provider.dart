import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/database/Tasks_Dao.dart';
import 'package:todo/database/Users_Dao.dart';
import 'package:todo/database/model/Task.dart';
import 'package:todo/database/model/User.dart' as MyUser;

class AuthProvider extends ChangeNotifier {
  MyUser.User? currentUser;

  void updateUser(MyUser.User loggedInUser) {
    currentUser = loggedInUser;
    notifyListeners();
  }

  void editTask(Task task) {
    TasksDao.updateTask(currentUser!.id!, task).then(
      (value) {
        print("task edited");
      },
    );
  }

  bool isUserLoggedInBefor() {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<void> autoLogin() async {
    var fireBaseUser = FirebaseAuth.instance.currentUser;
    if (fireBaseUser == null) return;
    currentUser = await UsersDao.readUser(fireBaseUser.uid);
  }
}
