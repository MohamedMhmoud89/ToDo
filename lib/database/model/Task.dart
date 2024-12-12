import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  static const String collectionName = "tasks";
  String? id;
  String? title;
  String? description;
  Timestamp? dateTime;
  bool isDone;

  Task(
      {this.id,
      this.title,
      this.description,
      this.dateTime,
      this.isDone = false});

  Task.fromFireStore(Map<String, dynamic>? data)
      : this(
            id: data?["id"],
            title: data?["title"],
            description: data?["description"],
            dateTime: data?["dateTime"],
            isDone: data?["isDone"]);

  Map<String, dynamic> toFireStore() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "dateTime": dateTime,
      "isDone": isDone
    };
  }
}
