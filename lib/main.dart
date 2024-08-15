import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/network/firebase_options.dart';
import 'package:connectfour/routes/AppRoutes.dart';
import 'package:connectfour/presentation/SignInPage.dart';
import 'package:connectfour/presentation/HomePage.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State  createState() => _MyApp();
}

class _MyApp extends State<MyApp>{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirebaseAuth.instance.currentUser == null? SignInPage() : HomePage(),
      routes: AppRoutes.routes
    );
  }
}

