// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jimatgo_app/auth.dart';
import 'package:jimatgo_app/colors.dart';
import 'package:jimatgo_app/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:jimatgo_app/responsive.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final FocusNode _focusNodeEmail = FocusNode();

  final _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? errorMessage = '';
  int maxSeconds = 65; //reset timer duration
  bool _circularIndicator = false; // loading Indicator onClick reset button
  bool _resetTimer = false; //reset timer onClick reset button
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 25, 0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        Icon(
                          Icons.lock,
                          size: resetPageIconSize,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "RESET PASSWORD",
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontFamily: 'BebasNeue',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: titleColor,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Provide your account's email address which you want to reset your password",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: contentFontSize,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: textFieldVerticalContainer,
                          ),
                          decoration: const BoxDecoration(),
                          child: TextFormField(
                            controller: _emailController,
                            focusNode: _focusNodeEmail,
                            style: TextStyle(fontSize: contentFontSize),
                            autovalidateMode: AutovalidateMode.always,
                            validator: (value) => _emailValidation(value),
                            decoration: InputDecoration(
                              icon: const Icon(
                                Icons.mail,
                                color: iconColor,
                              ),
                              hintText: "ex:Jackie@gmail.com",
                              labelText: 'Enter email address',
                              labelStyle: TextStyle(fontSize: contentFontSize),
                              hintStyle: TextStyle(fontSize: labelHintFontSize),
                              errorStyle: TextStyle(fontSize: errorFontSize),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            !_resetTimer
                                ? SizedBox(
                                    width: resetButtonWidth,
                                    height: resetButtonHeight,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _resetPassword();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: buttonColor,
                                      ),
                                      child: Text(
                                        "Reset password",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: contentFontSize,
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    width: resetButtonWidth,
                                    height: resetButtonHeight,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        null;
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                      ),
                                      child: Text(
                                        "Reset password",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: contentFontSize,
                                        ),
                                      ),
                                    ),
                                  ),
                            if (_resetTimer) resetTimer(),
                            const SizedBox(width: 6),
                            if (_circularIndicator)
                              const SizedBox(
                                width: 23,
                                height: 23,
                                child: CircularProgressIndicator(),
                              ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              backgroundColor: Colors.transparent,
                              padding: const EdgeInsets.all(0)),
                          child: Text(
                            "Go back",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: contentFontSize,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /*----------------------------------------------------------------
--> email validation*/
  _emailValidation(value) {
    if (value == null || value.trim().isEmpty) {
      if (!_focusNodeEmail.hasPrimaryFocus) {
        return null;
      }
      return 'This field is required';
    }

    if (value != null && !EmailValidator.validate(value)) {
      return "Enter a valid email";
    } else {
      if (!_focusNodeEmail.hasPrimaryFocus) {
        return null;
      }
      return null;
    }
  }

  /*----------------------------------------------------------------
--> Reset password validation*/
  void _resetPassword() {
    if (!_formKey.currentState!.validate() || _emailController.text == "") {
      Fluttertoast.showToast(
          msg: "Please enter the email address",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: contentFontSize);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text(
            "Reset password?",
            style: TextStyle(fontSize: contentFontSize),
          ),
          content: Text("Are you sure?",
              style: TextStyle(fontSize: contentFontSize)),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Yes",
                style: TextStyle(fontSize: contentFontSize),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                FocusScope.of(context).unfocus();
                setState(() {
                  _circularIndicator = true;
                });
                Timer(const Duration(seconds: 4), () {
                  sendPasswordResetEmail();
                  setState(() {
                    _circularIndicator = false;
                    _resetTimer = true;
                  });
                });
                startTimer();
                Timer(const Duration(seconds: 65), () {
                  setState(() {
                    _resetTimer = false;
                    return;
                  });
                });
              },
            ),
            TextButton(
              child: Text(
                "No",
                style: TextStyle(fontSize: contentFontSize),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                FocusScope.of(context).unfocus();
              },
            ),
          ],
        );
      },
    );
  }

  /*----------------------------------------------------------------
--> Reset password timer*/
  Widget resetTimer() {
    return Text(
      '($maxSeconds)',
      style: TextStyle(
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 111, 111, 109),
          fontSize: contentFontSize + 1),
    );
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      --maxSeconds;
      setState(() {
        if (maxSeconds == 0) {
          //Stop if second equal to 0
          timer.cancel();
          maxSeconds = 65;
        }
      });
    });
  }

  /*----------------------------------------------------------------
--> Firebase Authentication for reset password*/
  Future<void> sendPasswordResetEmail() async {
    try {
      await Auth()
          .sendPasswordResetEmail(
            email: _emailController.text,
          )
          .then((value) => {
                // Navigator.of(context).pop(),
                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (context) => const LoginPage())),
              });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 4),
          content: SizedBox(
              height: 30,
              child: Center(
                  child: Text("Reset request has been sent to the email")))));
      return;
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
        Fluttertoast.showToast(
            msg: "$errorMessage",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: contentFontSize);
        return;
      });
    }
  }

  /*----------------------------------------------------------------
--> action to take if the return button in phone is clicked*/
  Future<bool> _willPopCallback() async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()));
    return true;
  }
}
