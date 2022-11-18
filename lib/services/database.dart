import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_todo_app/models/todo_model.dart';
import 'package:get/get.dart';

class Database {
  FirebaseFirestore firestore;

  Database({required this.firestore});

  Stream<List<TodoModel>> streamTodos({required String uid}) {
    return firestore
        .collection('todos')
        .doc(uid)
        .collection('todos')
        .where('done', isEqualTo: false)
        .snapshots()
        .map((event) {
      final List<TodoModel> returnList = <TodoModel>[];
      for (final DocumentSnapshot doc in event.docs) {
        returnList.add(TodoModel.fromDocumentSnapshot(documentSnapshot: doc));
      }
      return returnList;
    });
  }

  Future<void> addTodo({required String uid, required String content}) async {
    try {
      firestore
          .collection('todos')
          .doc(uid)
          .collection('todos')
          .add({'content': content, 'done': false});
      Duration deadline = const Duration(seconds: 6);
      Future.delayed(deadline, () {
        Get.snackbar('Alert', 'Hey you have pending tasks');
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTodo({required String uid, required String todoId}) async {
    try {
      firestore
          .collection('todos')
          .doc(uid)
          .collection('todos')
          .doc(todoId)
          .update({'done': true});
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<TodoModel>> streamViewedTodos({required String uid}) {
    return firestore
        .collection('todos')
        .doc(uid)
        .collection('todos')
        .where('done', isEqualTo: true)
        .snapshots()
        .map((event) {
      final List<TodoModel> newList = <TodoModel>[];
      for (final DocumentSnapshot doc in event.docs) {
        newList.add(TodoModel.fromDocumentSnapshot(documentSnapshot: doc));
      }
      return newList;
    });
  }
}
