import 'dart:io';

import 'package:chat_me/Screens/Registration_screen.dart';
import 'package:chat_me/Screens/chat_screen.dart';
import 'package:chat_me/Screens/signin_screen.dart';
import 'package:chat_me/Screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid ?  await Firebase.initializeApp(
options: const FirebaseOptions(
  apiKey: 'AIzaSyBumR7wxy1jNnQNpX_6gH0IUQZKYipY9mU',
 appId: '1:716750532585:android:8993d71e8336a6c5f86578', 
 messagingSenderId: '716750532585',
  projectId: 'hopeful-hold-387912',
  storageBucket: 'hopeful-hold-387912.appspot.com'
  )
  )
  :
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
  final _auth = FirebaseAuth.instance;
    return MaterialApp(
      title: 'Contact Me',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 8, 234, 117)),
        useMaterial3: true,
      ),
      initialRoute: WelcomeScreen.screenRoute,
      routes: {
        WelcomeScreen.screenRoute :(context) => WelcomeScreen(),
        SignInScreen.screenRoute: (context) => SignInScreen(),
        RegistrationScreen.screenRoute: (context) => RegistrationScreen(),
        ChatScreen.screenRoute: (context) => ChatScreen(),
      
      },
    );
  }
}
