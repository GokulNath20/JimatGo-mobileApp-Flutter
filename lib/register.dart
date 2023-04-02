// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jimatgo_app/auth.dart';
import 'package:jimatgo_app/colors.dart';
import 'package:jimatgo_app/loginpage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:jimatgo_app/mainpage.dart';
import 'package:jimatgo_app/responsive.dart';
import 'package:ndialog/ndialog.dart';
import 'package:username_validator/username_validator.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

late final userUsername = []; //store user data

class _RegisterState extends State<Register> with TickerProviderStateMixin {
  final FocusNode _focusNodeUserName = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePhoneNumber = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodeReEnterPassword = FocusNode();

  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _reEnterPasswordController = TextEditingController();

  final validatorKey = GlobalKey<FlutterPwValidatorState>();
  final _formKey = GlobalKey<FormState>();

  late final userEmail = [];
  late final userPhoneNumber = [];
  late double viewInset;

  bool _isChecked = false; //accept terms and condition checkbox
  bool _isVisible = false; //to view password
  bool _isClick = false; //textfield color changing
  bool _passwordMatch = false; //check password match

  String _eula = "";
  String? _errorMessage = '';

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return buttonColor;
    }
    return buttonColor;
  }

  @override
  void initState() {
    super.initState();
    _getUserName();
    _getEmail();
    _getPhoneNumber();
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
        Container(
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
                const SizedBox(
                  height: 40,
                ),
                Text(
                  "REGISTER",
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
                  "Username",
                  style: TextStyle(
                    fontSize: contentFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
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
                          _isClick = true;
                        } else {
                          textFormFieldColor =
                              const Color.fromARGB(255, 206, 206, 200);
                          _isClick = false;
                        }
                        return;
                      });
                    },
                    child: TextFormField(
                      controller: _userNameController,
                      focusNode: _focusNodeUserName,
                      style: TextStyle(fontSize: contentFontSize),
                      keyboardType: TextInputType.text,
                      autovalidateMode: AutovalidateMode.always,
                      validator: (value) => (value != null &&
                              userUsername.any((element) => element == value))
                          ? "Username already exists"
                          : _usernameValidation(value),
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(_focusNodeEmail);
                      },
                      onChanged: (value) {
                        setState(() {
                          _userNameController;
                          _getUserName();
                        });
                      },
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          letterSpacing: 0.3,
                          color: _usernameErrorTextColorValidation(),
                          fontSize: errorFontSize,
                        ),
                        labelStyle: TextStyle(
                            fontSize: labelHintFontSize,
                            color: _focusNodeUserName.hasFocus
                                ? Colors.blue
                                : null),
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.person,
                          color: iconColor,
                          size: registerPageIconSize,
                        ),
                        hintText: "ex:Jackie",
                        labelText: 'Enter username',
                        hintStyle: TextStyle(fontSize: labelHintFontSize),

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
                if (_isClick) _usernameValidationText(),
                SizedBox(
                  height: screenHeight * 0.02,
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
                  height: screenHeight * 0.01,
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
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: contentFontSize),
                      autovalidateMode: AutovalidateMode.always,
                      validator: (value) => (value != null &&
                              userEmail.any((element) => element == value))
                          ? "Email already exists"
                          : _emailValidation(value),
                      focusNode: _focusNodeEmail,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context)
                            .requestFocus(_focusNodePhoneNumber);
                      },
                      onChanged: (value) {
                        setState(() {
                          _emailController;
                          _getEmail();
                        });
                      },
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          letterSpacing: 0.3,
                          fontSize: errorFontSize,
                          color: _emailErrorTextColorValidation(),
                        ),
                        labelStyle: TextStyle(
                            fontSize: labelHintFontSize,
                            color:
                                _focusNodeEmail.hasFocus ? Colors.blue : null),
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.email,
                          color: iconColor,
                          size: registerPageIconSize,
                        ),
                        hintText: 'Jackie@gmail.com',
                        labelText: "Enter email address",
                        hintStyle: TextStyle(fontSize: labelHintFontSize),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Text(
                  "Phone number",
                  style: TextStyle(
                    fontSize: contentFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
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
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: contentFontSize),
                      autovalidateMode: AutovalidateMode.always,
                      validator: (value) => (value != null &&
                              userPhoneNumber
                                  .any((element) => element == value))
                          ? "Phone number already exists"
                          : _phoneNumberValidation(value),
                      focusNode: _focusNodePhoneNumber,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context).requestFocus(_focusNodePassword);
                      },
                      onChanged: (value) {
                        setState(() {
                          _phoneNumberController;
                          _getPhoneNumber();
                        });
                      },
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          letterSpacing: 0.3,
                          fontSize: errorFontSize,
                          color: _phoneNumberErrorTextColorValidation(),
                        ),
                        labelStyle: TextStyle(
                            fontSize: labelHintFontSize,
                            color: _focusNodePhoneNumber.hasFocus
                                ? Colors.blue
                                : null),
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.email,
                          color: iconColor,
                          size: registerPageIconSize,
                        ),
                        hintText: 'ex:01126XXXXX',
                        labelText: "Enter phone number",
                        hintStyle: TextStyle(fontSize: labelHintFontSize),
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
                  height: screenHeight * 0.01,
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
                      obscureText: _isVisible ? false : true,
                      controller: _passwordController,
                      focusNode: _focusNodePassword,
                      style: TextStyle(fontSize: contentFontSize),
                      autovalidateMode: AutovalidateMode.always,
                      validator: (value) => _passwordValidation(value),
                      onFieldSubmitted: (v) {
                        FocusScope.of(context)
                            .requestFocus(_focusNodeReEnterPassword);
                      },
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                            fontSize: labelHintFontSize,
                            color: _focusNodePassword.hasFocus
                                ? Colors.blue
                                : null),
                        suffixIcon: IconButton(
                          onPressed: () => updateStatus(),
                          icon: Icon(_isVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          iconSize: registerPageIconSize,
                        ),
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.lock,
                          color: iconColor,
                          size: registerPageIconSize,
                        ),
                        labelText: 'Enter password',
                        errorStyle: TextStyle(fontSize: errorFontSize),
                      ),
                    ),
                  ),
                ),
                if (_focusNodePassword.hasPrimaryFocus)
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                if (_focusNodePassword.hasPrimaryFocus) _passwordValidator(),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Text(
                  "Re-enter password",
                  style: TextStyle(
                    fontSize: contentFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
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
                      obscureText: true,
                      controller: _reEnterPasswordController,
                      textInputAction: TextInputAction.done,
                      style: TextStyle(fontSize: contentFontSize),
                      autovalidateMode: AutovalidateMode.always,
                      validator: (value) => _reEnterPasswordValidation(value),
                      focusNode: _focusNodeReEnterPassword,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                            fontSize: labelHintFontSize,
                            color: _focusNodeReEnterPassword.hasFocus
                                ? Colors.blue
                                : null),
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.lock,
                          color: iconColor,
                          size: registerPageIconSize,
                        ),
                        labelText: 'Re-enter password',
                        errorStyle: TextStyle(fontSize: errorFontSize),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.005,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  Transform.scale(
                    scale: screenHeight * 0.0014,
                    child: Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: _isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked = value!;
                          });
                        }),
                  ),
                  GestureDetector(
                    onTap: _showEULA,
                    child: Text(
                      'Agree with terms & conditions',
                      style: TextStyle(
                        fontSize: contentFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenWidth * 0.01,
            ),
            if (_registerButtonVisible())
              Container(
                padding: const EdgeInsets.only(top: 5),
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.065,
                      width: screenWidth,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          _registerUser();
                        },
                        label: Text(
                          'Register',
                          style: TextStyle(fontSize: contentFontSize),
                        ),
                        icon: Icon(
                          Icons.car_repair_rounded,
                          size: registerPageIconSize,
                        ),
                        backgroundColor: buttonColor,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
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
                            _exitRegisterPage();
                          },
                          child: Text(
                            "Sign in",
                            style: TextStyle(
                              fontSize: contentFontSize,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromARGB(255, 255, 196, 93),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
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
--> Firebase Authentication for Register account*/
  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth()
          .createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          )
          .then((value) async => {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc((_emailController.text))
                    .set(
                  {
                    "Member ID": "",
                    "Username": _userNameController.text,
                    "Full Name": "",
                    "Phone Number": _phoneNumberController.text,
                    "Email": _emailController.text,
                    "Birth Date": "",
                    "NRIC": "",
                    "Address": "",
                    "Vehicle Number": "",
                  },
                ),
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage())),
              });
      Fluttertoast.showToast(
          msg: "Register Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: contentFontSize);
      return;
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: "$_errorMessage",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: contentFontSize);
        return;
      });
    }
  }

  /*----------------------------------------------------------------
--> Firebase retrieve all users username details*/
  void _getUserName() {
    FirebaseFirestore.instance.collection("users").snapshots().listen((event) {
      for (var doc in event.docs) {
        userUsername.add(doc.data()["Username"]);
      }
    });
  }

  /*----------------------------------------------------------------
--> Firebase retrieve all users email details*/
  void _getEmail() {
    FirebaseFirestore.instance.collection("users").snapshots().listen((event) {
      for (var doc in event.docs) {
        userEmail.add(doc.data()["Email"]);
      }
    });
  }

  /*----------------------------------------------------------------
--> Firebase retrieve all users phone number details*/
  void _getPhoneNumber() {
    FirebaseFirestore.instance.collection("users").snapshots().listen((event) {
      for (var doc in event.docs) {
        userPhoneNumber.add(doc.data()["Phone Number"]);
      }
    });
  }

/*----------------------------------------------------------------
--> username validation*/
  Widget _usernameValidationText() {
    return Container(
      decoration: BoxDecoration(
        //color: const Color.fromARGB(255, 211, 209, 209),
        borderRadius: BorderRadius.circular(7),
      ),
      margin: const EdgeInsets.fromLTRB(25, 3, 0, 0),
      child: Text(
        '''- Requires minimum of 3 character and a maximum of 30.\n- Accepted characters are: a-z A-Z 0-9 dot(.) underscore(_).\n- Allow "_" and "." in the middle of character only.\n- Numbers must not be the first character.\n- The dot (.) or underscore (_) must not appear\n  consecutively.''',
        style: TextStyle(
          fontSize: contentFontSize - 3,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  _usernameValidation(value) {
    if (value == null || value.trim().isEmpty) {
      if (!_focusNodeUserName.hasPrimaryFocus) {
        return null;
      }
      return 'This field is required';
    }

    if (value != null &&
        !UValidator.validateThis(
            pattern: RegPattern.strict, username: value!)) {
      return "Enter a valid username";
    } else {
      if (!_focusNodeUserName.hasPrimaryFocus) {
        return null;
      }

      return "Username available";
    }
  }

  _usernameErrorTextColorValidation() {
    if (((!UValidator.validateThis(
            pattern: RegPattern.strict, username: _userNameController.text))) ||
        _userNameController.text.trim().isEmpty ||
        !_focusNodeUserName.hasPrimaryFocus ||
        userUsername.any((element) => element == _userNameController.text)) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  _emailErrorTextColorValidation() {
    if ((!EmailValidator.validate(_emailController.text)) ||
        _emailController.text.trim().isEmpty ||
        !_focusNodeEmail.hasPrimaryFocus ||
        userEmail.any((element) => element == _emailController.text)) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  _phoneNumberErrorTextColorValidation() {
    final RegExp phoneNumber =
        RegExp(r'^(\+?6?01)[02-46-9]-*[0-9]{7}$|^(\+?6?01)[1]-*[0-9]{8}$');
    if (!phoneNumber.hasMatch(_phoneNumberController.text) ||
        _phoneNumberController.text.trim().isEmpty ||
        !_focusNodePhoneNumber.hasPrimaryFocus ||
        userPhoneNumber
            .any((element) => element == _phoneNumberController.text)) {
      return Colors.red;
    } else {
      return Colors.green;
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

    if (value != null && !EmailValidator.validate(value) ||
        !value.toString().endsWith("com")) {
      return "Enter a valid email";
    } else {
      if (!_focusNodeEmail.hasPrimaryFocus) {
        return null;
      }
      return null;
    }
  }

  /*----------------------------------------------------------------
--> phone number validation*/
  _phoneNumberValidation(value) {
    final RegExp phoneNumber =
        RegExp(r'^(\+?6?01)[02-46-9]-*[0-9]{7}$|^(\+?6?01)[1]-*[0-9]{8}$');

    if (value == null || value.trim().isEmpty) {
      if (!_focusNodePhoneNumber.hasPrimaryFocus) {
        return null;
      }
      return 'This field is required';
    }
    if (value != null && !phoneNumber.hasMatch(value)) {
      return "Enter a valid phone number";
    } else {
      if (!_focusNodePhoneNumber.hasPrimaryFocus) {
        return null;
      }
      return null;
    }
  }

  /*----------------------------------------------------------------
--> Password validation*/
  Widget _passwordValidator() {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.center,
      child: FlutterPwValidator(
        defaultColor: Colors.white,
        failureColor: Colors.white,
        successColor: Colors.yellow,
        key: validatorKey,
        controller: _passwordController,
        height: screenWidth * 0.25,
        minLength: 8,
        uppercaseCharCount: 1,
        specialCharCount: 1,
        numericCharCount: 2,
        width: screenWidth * 0.75,
        onSuccess: () {
          setState(() {
            _passwordMatch = true;
          });
        },
        onFail: () {
          setState(() {
            _passwordMatch = false;
          });
        },
      ),
    );
  }

  _passwordValidation(value) {
    if (value == null || value.isEmpty) {
      if (!_focusNodePassword.hasPrimaryFocus) {
        return null;
      }
      return 'This field is required';
    } else if (value != null && !_passwordMatch) {
      // if password entered only in re-enter textfield
      return "Password is too weak";
    }
  }

  /*----------------------------------------------------------------
--> Re-enter password validation*/
  _reEnterPasswordValidation(value) {
    if (value == null || value.trim().isEmpty) {
      // if FocusNode is false and empty
      if (!_focusNodeReEnterPassword.hasPrimaryFocus && value.trim().isEmpty) {
        return null;
      }
      return 'This field is required';
    } else if (value != null &&
        _passwordController.text != _reEnterPasswordController.text &&
        _passwordMatch) {
      // if password entered is met criteria but not same
      return "Password not match";
    } else if (value != null &&
        _passwordController.text == _reEnterPasswordController.text &&
        !_passwordMatch) {
      // if password entered is not met criteria but same
      return "Password is too weak";
    } else if (value != null &&
        _passwordController.text.trim().isNotEmpty &&
        _passwordController.text != _reEnterPasswordController.text &&
        !_passwordMatch) {
      // if password entered is not met criteria and not same
      return "Password is too weak";
    } else if (value != null && _passwordController.text.trim().isEmpty) {
      // if password entered only in re-enter textfield
      return "Fill in the password";
    }
  }

/*----------------------------------------------------------------
--> overall register validation*/
  void _registerUser() {
    if (!_formKey.currentState!.validate() ||
        _userNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _reEnterPasswordController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please complete the registration form first",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: contentFontSize);
      return;
    }

    if (!_isChecked) {
      Fluttertoast.showToast(
          msg: "Please accept the terms and conditions",
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
            "Register new account?",
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
                ProgressDialog progressDialog = ProgressDialog(context,
                    message: Text(
                      "Please wait while we processing your registration...",
                      style: TextStyle(fontSize: contentFontSize),
                    ),
                    title: Text(
                      "Creating new account",
                      style: TextStyle(fontSize: contentFontSize),
                    ));
                progressDialog.show();
                Timer(const Duration(seconds: 3), () {
                  setState(() {
                    createUserWithEmailAndPassword();
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
              },
            ),
          ],
        );
      },
    );
  }

/*----------------------------------------------------------------
--> OnClick Register*/
  void _exitRegisterPage() {
    if (!_formKey.currentState!.validate() ||
        _userNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneNumberController.text.isEmpty) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()));
      return;
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text(
              "Are you sure you want to exit register page?",
              style: TextStyle(fontSize: contentFontSize),
            ),
            content: Text("All your data entered will be lost..",
                style: TextStyle(fontSize: contentFontSize)),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Yes",
                  style: TextStyle(fontSize: contentFontSize),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const LoginPage()));
                },
              ),
              TextButton(
                child: Text(
                  "No",
                  style: TextStyle(fontSize: contentFontSize),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
            ],
          );
        },
      );
    }
  }

/*----------------------------------------------------------------
--> End-User License Agreement (EULA) of JimatGo */
  void _showEULA() {
    loadEula();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "EULA",
          ),
          content: SizedBox(
            height: screenHeight / 1.5,
            width: screenWidth,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                      child: RichText(
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                        ),
                        text: _eula),
                  )),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Close",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  loadEula() async {
    _eula = await rootBundle.loadString('assets/eula.txt');
  }

  /*----------------------------------------------------------------
--> action to take if the return button in phone is clicked*/
  Future<bool> _willPopCallback() async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()));
    return true;
  }

  /*----------------------------------------------------------------
--> Check the visibility of register button*/
  _registerButtonVisible() {
    if ((!_focusNodeUserName.hasFocus &&
            !_focusNodePassword.hasFocus &&
            !_focusNodeEmail.hasFocus &&
            !_focusNodePhoneNumber.hasFocus &&
            !_focusNodeReEnterPassword.hasFocus) ||
        ((_focusNodeUserName.hasFocus && viewInset == 0) ||
            (_focusNodePassword.hasFocus && viewInset == 0) ||
            (_focusNodeEmail.hasFocus && viewInset == 0) ||
            (_focusNodePhoneNumber.hasFocus && viewInset == 0) ||
            (_focusNodeReEnterPassword.hasFocus && viewInset == 0))) {
      return true;
    } else {
      return false;
    }
  }
}
