import 'package:flutter/material.dart';
import 'package:jimatgo_app/homepage.dart';
import 'package:jimatgo_app/mainpage.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:percent_indicator/percent_indicator.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        appBar: NewGradientAppBar(
          elevation: 0,
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 224, 74, 74),
              Color.fromARGB(255, 213, 164, 29),
            ],
          ),
        ),
        body: SafeArea(
          child: LinearPercentIndicator(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            width: screenWidth,
            animation: true,
            animationDuration: 2500,
            percent: 1.0,
            backgroundColor: Colors.white,
            progressColor: Colors.amber[800],
          ),
        ),
      ),
    );
  }

  /*----------------------------------------------------------------
--> action to take if the return button in phone is clicked*/
  Future<bool> _willPopCallback() async {
    Navigator.of(context).push(_createRoute());
    return true;
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
