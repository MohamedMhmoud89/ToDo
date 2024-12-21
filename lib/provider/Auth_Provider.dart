import 'package:flutter/material.dart';
import 'package:todo/database/Tasks_Dao.dart';
import 'package:todo/database/model/Task.dart';
import 'package:todo/database/model/User.dart';

class AuthProvider extends ChangeNotifier {
  User? currentUser;

  void updateUser(User loggedInUser) {
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
}
