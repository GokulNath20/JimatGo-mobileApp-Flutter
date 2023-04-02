import 'package:flutter/material.dart';
import 'package:jimatgo_app/auth.dart';
import 'package:jimatgo_app/homepage.dart';

import 'package:jimatgo_app/loginpage.dart';
import 'package:jimatgo_app/responsive.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

late double screenHeight, screenWidth;

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder(
      stream: authStateChanges,
      builder: (context, snapshot) {
        /*Snapshot is the result of the Future or Stream you are listening to in your 
        FutureBuilder . Before interacting with the data being returned and using it 
        in your builder, you have to access it first*/
        if (snapshot.hasData) {
          responsive(screenWidth);
          return const HomePage();
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
            backgroundColor: Color.fromARGB(255, 54, 54, 54),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Something Went Wrong!!"),
          );
        } else {
          responsive(screenWidth);
          return const LoginPage();
        }
      },
    );
  }
}
