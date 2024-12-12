import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/database/Users_Dao.dart';
import 'package:todo/database/model/Task.dart';

class TasksDao {
  static CollectionReference<Task> getTasksCollection(String uid) {
    return UsersDao.getUsersCollection()
        .doc(uid)
        .collection(Task.collectionName)
        .withConverter(
            fromFirestore: (snapshot, options) =>
                Task.fromFireStore(snapshot.data()),
            toFirestore: (task, options) => task.toFireStore());
  }

  static Future<void> createTask(Task task, String uid) {
    var docRef = getTasksCollection(uid).doc();
    task.id = docRef.id;
    return docRef.set(task);
  }

  static Future<List<Task>> getAllTasks(
      String uid, DateTime selectedDate) async {
    var tasksSnapshot = await getTasksCollection(uid)
        .where("dateTime",
            isEqualTo: Timestamp.fromMillisecondsSinceEpoch(
                selectedDate.millisecondsSinceEpoch))
        .get();
    var tasksList =
        tasksSnapshot.docs.map((snapshot) => snapshot.data()).toList();
    return tasksList;
  }

  static Stream<List<Task>> listenForTasks(
      String uid, DateTime selectedDate) async* {
    var stream = getTasksCollection(uid)
        .where("dateTime",
            isEqualTo: Timestamp.fromMillisecondsSinceEpoch(
                selectedDate.millisecondsSinceEpoch))
        .snapshots();
    yield* stream.map(
      (querySnapShot) => querySnapShot.docs.map((doc) => doc.data()).toList(),
    );
  }

  static Future<void> removeTask(String taskId, String uid) {
    return getTasksCollection(uid).doc(taskId).delete();
  }

  static Future<void> updateTask(String taskId, String uid, Task task) {
    return getTasksCollection(uid).doc(taskId).update(task.toFireStore());
  }
}
