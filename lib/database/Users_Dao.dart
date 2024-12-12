import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/database/model/User.dart';

class UsersDao {
  static CollectionReference<User> getUsersCollection() {
    return FirebaseFirestore.instance
        .collection(User.collectionName)
        .withConverter(
          fromFirestore: (snapshot, options) =>
              User.fromFireStore(snapshot.data()),
          toFirestore: (user, options) => user.toFireStore(),
        );
  }

  static Future<void> addUser(User user) {
    var collection = getUsersCollection();
    return collection.doc(user.id).set(user);
  }

  static Future<User?> readUser(String id) async {
    var collection = getUsersCollection();
    var docSnapshot = await collection.doc(id).get();
    return docSnapshot.data();
  }
}
