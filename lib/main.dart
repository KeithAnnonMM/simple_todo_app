import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_todo_app/screens/homescreen.dart';
import 'package:simple_todo_app/screens/login.dart';
import 'package:simple_todo_app/services/auth.dart';
import 'package:simple_todo_app/widgets/reusable_loader.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Future<FirebaseApp> _initialisation = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: FutureBuilder(
        future: _initialisation,
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return const Scaffold(
                body: Center(child: Text('An error occurred')));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return const Root();
          }

          return Scaffold(body: Center(child: getSpinner()));
        }),
      ),
    );
  }
}

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth(auth: _auth).user,
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data?.uid == null) {
            return Login(auth: _auth);
          } else {
            return Home(auth: _auth, firestore: _firestore);
          }
        }
        return Scaffold(body: Center(child: getSpinner()));
      }),
    );
  }
}
