// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:jimatgo_app/splashpage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  //Flutter needs to call native code before calling runApp
  //WidgetsFlutterBinding makes sure that you have an instance of the WidgetsBinding, which is required to use platform channels to call the native code.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        themeMode: ThemeMode.light,
        title: 'JimatGo Auto Services',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SplashPage(),
        ));
  }
}
