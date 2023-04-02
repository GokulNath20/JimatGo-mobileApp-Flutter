// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jimatgo_app/auth.dart';
import 'package:jimatgo_app/colors.dart';
import 'package:jimatgo_app/homepage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:jimatgo_app/mainpage.dart';
import 'package:jimatgo_app/reset_password.dart';
import 'package:jimatgo_app/responsive.dart';
import 'package:jimatgo_app/register.dart';
import 'package:ndialog/ndialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage2State();
}

class _LoginPage2State extends State<LoginPage> with TickerProviderStateMixin {
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late double viewInset;

  bool _isChecked = false; //Remember me switch
  bool _isVisible = false; //to view password
  String? errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadPref();
    loadPermission();
  }

  void updateStatus() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    viewInset = MediaQuery.of(context).viewInsets.bottom;
    return WillPopScope(
      onWillPop: _willPopCallback,
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
            GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [upperHalf(context), lowerHalf(context)],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget upperHalf(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: screenWidth * 0.6,
          child: Image.asset("assets/images/JimatGo_Logo.png",
              fit: BoxFit.fitWidth),
        ),
      ],
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 25, 0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "LOGIN",
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontFamily: 'BebasNeue',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: titleColor,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                Text(
                  "Email",
                  style: TextStyle(
                    fontSize: contentFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: textFieldVerticalContainer,
                  ),
                  decoration: BoxDecoration(
                    color: textFormFieldColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Focus(
                    onFocusChange: (hasFocus) {
                      setState(() {
                        if (hasFocus) {
                          textFormFieldColor = textFormFieldOnTapColor;
                        } else {
                          textFormFieldColor =
                              const Color.fromARGB(255, 206, 206, 200);
                        }
                        return;
                      });
                    },
                    child: TextFormField(
                      controller: _emailController,
                      focusNode: _focusNodeEmail,
                      style: TextStyle(fontSize: contentFontSize),
                      autovalidateMode: AutovalidateMode.always,
                      validator: (value) => _emailValidation(value),
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(_focusNodePassword);
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.mail,
                          color: iconColor,
                          size: loginPageIconSize,
                        ),
                        hintText: "ex:Jackie@gmail.com",
                        labelText: 'Enter email address',
                        hintStyle: TextStyle(fontSize: labelHintFontSize),
                        labelStyle: TextStyle(fontSize: labelHintFontSize),
                        errorStyle: TextStyle(fontSize: errorFontSize),
                        /*border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                              width: 1.0,
                                            ),
                                          ),*/
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Text(
                  "Password",
                  style: TextStyle(
                    fontSize: contentFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: textFieldVerticalContainer,
                  ),
                  decoration: BoxDecoration(
                    color: textFormFieldColor2,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Focus(
                    onFocusChange: (hasFocus) {
                      setState(() {
                        if (hasFocus) {
                          textFormFieldColor2 = textFormFieldOnTapColor;
                        } else {
                          textFormFieldColor2 =
                              const Color.fromARGB(255, 206, 206, 200);
                        }
                        return;
                      });
                    },
                    child: TextFormField(
                      obscureText: _isVisible ? false : true,
                      controller: _passwordController,
                      focusNode: _focusNodePassword,
                      style: TextStyle(fontSize: contentFontSize),
                      textInputAction: TextInputAction.done,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (value) => _passwordValidation(value),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () => updateStatus(),
                          icon: Icon(_isVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          iconSize: loginPageIconSize,
                        ),
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.lock,
                          color: iconColor,
                          size: loginPageIconSize,
                        ),
                        labelText: 'Please enter password',
                        labelStyle: TextStyle(fontSize: labelHintFontSize),
                        errorStyle: TextStyle(fontSize: errorFontSize),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: switchButtonScale,
                        child: Switch(
                          activeColor: Colors.white,
                          value: _isChecked,
                          onChanged: (bool value) {
                            setState(() {
                              _rememberMeChanged(value);
                            });
                          },
                        ),
                      ),
                      Text(
                        'Remember me',
                        style: TextStyle(
                          fontSize: contentFontSize + 1,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenWidth * 0.03,
            ),
            if (_loginButtonVisible())
              Container(
                padding: const EdgeInsets.only(top: 5),
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.065,
                      width: screenWidth,
                      child: FloatingActionButton.extended(
                        hoverColor: const Color.fromARGB(255, 206, 156, 49),
                        onPressed: () {
                          _loginUser();
                        },
                        label: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: contentFontSize,
                          ),
                        ),
                        icon: Icon(
                          Icons.car_repair_rounded,
                          size: loginPageIconSize,
                        ),
                        backgroundColor: buttonColor,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.005,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const ResetPassword()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Forget",
                              style: TextStyle(
                                fontSize: contentFontSize,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromARGB(255, 255, 196, 93),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "Password?",
                              style: TextStyle(
                                fontSize: contentFontSize,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.005,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: screenWidth / 3,
                          height: screenHeight * 0.005,
                          color: titleColor,
                        ),
                        Text(
                          " or ",
                          style: TextStyle(
                            fontSize: contentFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          width: screenWidth / 3,
                          height: screenHeight * 0.005,
                          color: titleColor,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Text(
                      "Sign in with",
                      style: TextStyle(
                        fontSize: contentFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: screenWidth * 0.08,
                          width: screenWidth * 0.08,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              /* setState(() {
                                loadingIndicator == true;
                              });
                              Timer(const Duration(seconds: 3), () {
                                loadingIndicator == false;
                               
                              }); */
                              signInWithGoogle();
                            },
                            child: const Image(
                                image: AssetImage(
                                    "assets/images/google_icon.png")),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.05,
                        ),
                        Container(
                          height: screenWidth * 0.08,
                          width: screenWidth * 0.08,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            color: Colors.white,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              //Auth().signInWithFacebook();
                              signInWithFacebook();
                            },
                            child: const Image(
                                image: AssetImage(
                                    "assets/images/facebook_icon.png")),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            fontSize: contentFontSize,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const Register()));
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 255, 196, 93),
                              fontSize: contentFontSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /*----------------------------------------------------------------
--> Firebase Authentication for Login account using Facebook Sign-in*/
  Future<void> signInWithFacebook() async {
    await Auth().signInWithFacebook().then((value) async => {
          /* setState(() {
            loadingIndicator == true;
          }), */
          /* setState(() {
                loadingIndicator == false;/*  Timer(const Duration(seconds: 3), () {
            
          }) */
              }); */
          if (value == "Login Successful")
            {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomePage())),
            }
        });
  }

  /*----------------------------------------------------------------
--> Firebase Authentication for Login account using Google Sign-in*/
  Future<void> signInWithGoogle() async {
    try {
      await Auth().signInWithGoogle().then((value) => {
            /* setState(() {
              loadingIndicator == true;
            }), */
            /* setState(() {
                loadingIndicator == false; }); */
            /* Timer(const Duration(seconds: 3), () {
            }), */
            setState(() {
              Fluttertoast.showToast(
                  msg: "Login Successful",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  fontSize: contentFontSize);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomePage()));
              return;
            }),
          });
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
        Fluttertoast.showToast(
            msg: '$errorMessage',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: contentFontSize);
        return;
      });
    }
  }

  /*----------------------------------------------------------------
--> Firebase Authentication for Login account*/
  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth()
          .signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          )
          .then((value) => {
                Navigator.of(context).pop(),
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomePage())),
              });
      Fluttertoast.showToast(
          msg: "Login Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: contentFontSize);
      return;
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: "Invalid email or password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: contentFontSize);
        return;
      });
    }
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
--> password validation*/
  _passwordValidation(value) {
    if (value == null || value.trim().isEmpty) {
      if (!_focusNodePassword.hasPrimaryFocus) {
        return null;
      }
      return 'This field is required';
    }
  }

/*----------------------------------------------------------------
--> overall login validation*/
  void _loginUser() {
    if (!_formKey.currentState!.validate() ||
        _emailController.text == "" ||
        _passwordController.text == "") {
      Fluttertoast.showToast(
          msg: "Please fill in the login details",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: contentFontSize);
      return;
    } else {
      signInWithEmailAndPassword();
    }

    ProgressDialog progressDialog = ProgressDialog(
      context,
      message:
          Text("Please wait..", style: TextStyle(fontSize: contentFontSize)),
      title: Text("Login user", style: TextStyle(fontSize: contentFontSize)),
    );
    progressDialog.show();
  }

  void saveRemovePreference(bool value) async {
    if (!_formKey.currentState!.validate() ||
        _emailController.text == "" ||
        _passwordController.text == "") {
      Fluttertoast.showToast(
          msg: "Please fill in the login details",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: contentFontSize);
      _isChecked = false;
      return;
    }

    String email = _emailController.text;
    String password = _passwordController.text;
    SharedPreferences data = await SharedPreferences.getInstance();
    if (value) {
      //save preference
      await data.setString('email', email);
      await data.setString('pass', password);
      Fluttertoast.showToast(
          msg: "Preference Stored",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: contentFontSize);
    } else {
      //delete preference
      await data.setString('email', '');
      await data.setString('pass', '');
      setState(() {
        _isChecked = false;
      });
      Fluttertoast.showToast(
          msg: "Preference Removed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: contentFontSize);
    }
  }

  void _rememberMeChanged(bool newValue) => setState(() {
        _isChecked = newValue;
        if (_isChecked) {
          saveRemovePreference(true);
        } else {
          saveRemovePreference(false);
        }
      });

  Future<void> loadPref() async {
    SharedPreferences data = await SharedPreferences.getInstance();
    String email = (data.getString('email')) ?? '';
    String password = (data.getString('pass')) ?? '';
    if (email.length > 1 && password.length > 1) {
      setState(() {
        _emailController.text = email;
        _passwordController.text = password;
        _isChecked = true;
      });
    }
  }

  /*----------------------------------------------------------------
--> Get permissions from the user*/
  loadPermission() async {
    await Permission.notification.request();
  }

  /*----------------------------------------------------------------
--> action to take if the return button in phone is clicked*/
  Future<bool> _willPopCallback() async {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return true;
  }

  /*----------------------------------------------------------------
--> Check the visibility of login button*/
  _loginButtonVisible() {
    if ((!_focusNodeEmail.hasFocus && !_focusNodePassword.hasFocus) ||
        (_focusNodeEmail.hasFocus && viewInset == 0) ||
        (_focusNodePassword.hasFocus && viewInset == 0)) {
      return true;
    } else {
      return false;
    }
  }
}
