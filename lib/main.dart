import 'package:flutter/material.dart';
import 'package:netflix_clone/account/ui/account_screen.dart';
import 'package:netflix_clone/home/ui/home_screen.dart';
import 'package:netflix_clone/login/ui/login_screen.dart';
import 'package:netflix_clone/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashVideoScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
