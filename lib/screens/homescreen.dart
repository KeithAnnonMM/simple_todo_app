import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_todo_app/services/database.dart';
import 'package:simple_todo_app/widgets/reusable_loader.dart';
import 'package:simple_todo_app/widgets/todo_card.dart';

import '../services/auth.dart';

class Home extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  const Home({super.key, required this.auth, required this.firestore});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _todoController = TextEditingController();
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    Stream stream = checked
        ? Database(firestore: widget.firestore)
            .streamViewedTodos(uid: widget.auth.currentUser!.uid)
        : Database(firestore: widget.firestore)
            .streamTodos(uid: widget.auth.currentUser!.uid);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await Auth(auth: widget.auth).signOutUser();
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
        child: Column(
          children: [
            checked
                ? Container(width: 0)
                : Card(
                    margin: const EdgeInsets.all(20),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              key: const ValueKey("addField"),
                              controller: _todoController,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (_todoController.text != "") {
                                setState(() {
                                  Database(firestore: widget.firestore).addTodo(
                                      uid: widget.auth.currentUser!.uid,
                                      content: _todoController.text);
                                  _todoController.clear();
                                });
                              }
                            },
                            icon: const Icon(Icons.add, size: 40),
                          )
                        ],
                      ),
                    ),
                  ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Your Todos",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: stream,
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.data!.isEmpty) {
                      return const Center(child: Text('You have no todos'));
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) {
                        return TodoCard(
                          firestore: widget.firestore,
                          uid: widget.auth.currentUser!.uid,
                          todo: snapshot.data![index],
                        );
                      },
                    );
                  }
                  return Center(child: getSpinner());
                }),
              ),
            ),
            TextButton(
              onPressed: () {
                checked = !checked;
                setState(() {});
              },
              child: checked
                  ? const Text('View Pending tasks')
                  : const Text('View Done tasks'),
            ),
          ],
        ),
      ),
    );
  }
}
