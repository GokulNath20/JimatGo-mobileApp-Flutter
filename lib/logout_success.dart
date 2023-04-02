import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jimatgo_app/loginpage.dart';
import 'package:jimatgo_app/responsive.dart';

class LogoutSuccess extends StatefulWidget {
  const LogoutSuccess({super.key});

  @override
  State<LogoutSuccess> createState() => _LogoutSuccessState();
}

class _LogoutSuccessState extends State<LogoutSuccess> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Fluttertoast.showToast(
          msg: "Logout Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: contentFontSize);
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(_createRoute()));
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: double.maxFinite,
              width: double.maxFinite,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Color.fromARGB(255, 224, 74, 74),
                    Color.fromARGB(255, 213, 164, 29),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    textAlign: TextAlign.center,
                    "You have",
                    style: TextStyle(
                      fontSize: 45,
                      color: Colors.white,
                    ),
                    maxLines: 3,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    "successfully",
                    style: TextStyle(
                      fontSize: 45,
                      color: Colors.white,
                    ),
                    maxLines: 3,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    "logged out",
                    style: TextStyle(
                      fontSize: 45,
                      color: Colors.white,
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 20),
                  Text(
                    textAlign: TextAlign.center,
                    "Logged out on",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 5),
                  Text(
                    textAlign: TextAlign.center,
                    "Tuesday, 07 March 17:28 pm",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 40,
              left: -110,
              child: Container(
                height: 300,
                width: 250,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color.fromARGB(255, 219, 64, 64),
                        Color.fromARGB(255, 213, 164, 29),
                      ],
                    ),
                    shape: BoxShape.circle),
              ),
            ),
            Positioned(
              top: -100,
              right: -80,
              child: Container(
                height: 300,
                width: 250,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color.fromARGB(255, 213, 164, 29),
                        Color.fromARGB(255, 219, 64, 64),
                      ],
                    ),
                    shape: BoxShape.circle),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const LoginPage(),
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
