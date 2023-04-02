// ignore_for_file: depend_on_referenced_packages, equal_keys_in_map

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jimatgo_app/mainpage.dart';
import 'package:jimatgo_app/profile.dart';
import 'dart:math';
import 'package:jimatgo_app/responsive.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:username_validator/username_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late final userUsername = [];
  late final userEmail = [];
  late final userPhoneNumber = [];
  late final userNRIC = [];
  late final userBirthDate = [];
  late final userAddress = [];
  late final userVehicleNumber = [];

  final FocusNode _focusNodeUserName = FocusNode();
  final FocusNode _focusNodeFullName = FocusNode();
  final FocusNode _focusNodePhoneNumber = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodeBirthDate = FocusNode();
  final FocusNode _focusNodeNRIC = FocusNode();
  final FocusNode _focusNodeAddress = FocusNode();
  final FocusNode _focusNodeVehicleNumber = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();

  late String memberID = "";
  var _userNameController = TextEditingController();
  var _fullNameController = TextEditingController();
  var _phoneNumberController = TextEditingController();
  var _emailController = TextEditingController();
  var _birthDateController = TextEditingController();
  var _nRICController = TextEditingController();
  var _addressController = TextEditingController();
  var _vehicleNumberController = TextEditingController();

  bool _isClick = false; //textfield color changing

  @override
  void initState() {
    super.initState();
    _getUserName();
    _getFullName();
    _getPhoneNumber();
    _getEmail();
    _getBirthDate();
    _getNRIC();
    _getAddress();
    _getVehicleNumber();
    _userNameController = TextEditingController(text: currentUserName);
    _fullNameController = TextEditingController(text: currentFullName);
    _phoneNumberController = TextEditingController(text: currentPhoneNumber);
    _emailController = TextEditingController(text: currentEmailAddress);
    _birthDateController = TextEditingController(text: currentBirthDate);
    _nRICController = TextEditingController(text: currentNRIC);
    _addressController = TextEditingController(text: currentAddress);
    _vehicleNumberController =
        TextEditingController(text: currentVehicleNumber);
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    _nRICController.dispose();
    _addressController.dispose();
    _vehicleNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: WillPopScope(
        onWillPop: _willPopCallback,
        child: Scaffold(
          appBar: NewGradientAppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Align(
                    alignment: Alignment.centerRight,
                    child: Text("Edit Profile")),
                if (_userNameController.text == currentUserName &&
                    _fullNameController.text == currentFullName &&
                    _phoneNumberController.text == currentPhoneNumber &&
                    _emailController.text == currentEmailAddress &&
                    _birthDateController.text == currentBirthDate &&
                    _nRICController.text == currentNRIC &&
                    _addressController.text == currentAddress &&
                    _vehicleNumberController.text == currentVehicleNumber)
                  Icon(
                    Icons.save_rounded,
                    color: Colors.white.withOpacity(0.6),
                  ),
                if (_userNameController.text != currentUserName ||
                    _fullNameController.text != currentFullName ||
                    _phoneNumberController.text != currentPhoneNumber ||
                    _emailController.text != currentEmailAddress ||
                    _birthDateController.text != currentBirthDate ||
                    _nRICController.text != currentNRIC ||
                    _addressController.text != currentAddress ||
                    _vehicleNumberController.text != currentVehicleNumber)
                  GestureDetector(
                      onTap: () => _editProfile(),
                      child: const Icon(Icons.save_rounded)),
              ],
            ),
            elevation: 0,
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 224, 74, 74),
                Color.fromARGB(255, 213, 164, 29),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 30, 0),
                    child: Text(
                      "Personal Information",
                      style: TextStyle(
                        fontSize: contentFontSize + 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Focus(
                            onFocusChange: (hasFocus) {
                              setState(() {
                                if (hasFocus) {
                                  _isClick = true;
                                } else {
                                  _isClick = false;
                                }
                                return;
                              });
                            },
                            child: TextFormField(
                              controller: _userNameController,
                              focusNode: _focusNodeUserName,
                              keyboardType: TextInputType.text,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              style: TextStyle(fontSize: contentFontSize),
                              validator: (value) => (value != null &&
                                      userUsername
                                          .any((element) => element == value) &&
                                      value != currentUserName)
                                  ? "Username already exists"
                                  : _usernameValidation(value),
                              onFieldSubmitted: (v) {
                                FocusScope.of(context)
                                    .requestFocus(_focusNodeFullName);
                              },
                              onChanged: (value) {
                                setState(() {
                                  _getUserName();
                                });
                              },
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(0),
                                  errorStyle: TextStyle(
                                    letterSpacing: 0.3,
                                    fontSize: errorFontSize,
                                    color: _usernameErrorTextColorValidation(),
                                  ),
                                  labelStyle: TextStyle(
                                      letterSpacing: 0.3,
                                      fontSize: labelHintFontSize,
                                      color: _focusNodeUserName.hasFocus
                                          ? Colors.blue
                                          : null),
                                  hintStyle: TextStyle(
                                      letterSpacing: 0.3,
                                      fontSize: labelHintFontSize),
                                  labelText: "Username"),
                            ),
                          ),
                          const SizedBox(height: 5),
                          if (_isClick) _usernameValidationText(),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          TextFormField(
                            enabled: currentFullName.isNotEmpty ? false : true,
                            controller: _fullNameController,
                            focusNode: _focusNodeFullName,
                            style: TextStyle(fontSize: contentFontSize),
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              setState(() {
                                _getFullName();
                              });
                            },
                            onFieldSubmitted: (v) {
                              FocusScope.of(context)
                                  .requestFocus(_focusNodePhoneNumber);
                            },
                            decoration: InputDecoration(
                              suffixText: currentFullName.isEmpty ? '*' : null,
                              suffixStyle: TextStyle(
                                fontSize: contentFontSize,
                                color: Colors.red,
                              ),
                              labelStyle: TextStyle(
                                  fontSize: labelHintFontSize,
                                  color: _focusNodeFullName.hasFocus
                                      ? Colors.blue
                                      : null),
                              labelText: "Full Name as per NRIC",
                              hintStyle: TextStyle(fontSize: labelHintFontSize),
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _phoneNumberController,
                            keyboardType: TextInputType.number,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            style: TextStyle(fontSize: contentFontSize),
                            validator: (value) => (value != null &&
                                    userPhoneNumber
                                        .any((element) => element == value) &&
                                    value != currentPhoneNumber)
                                ? "Phone number already exists"
                                : _phoneNumberValidation(value),
                            focusNode: _focusNodePhoneNumber,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context)
                                  .requestFocus(_focusNodeEmail);
                            },
                            onChanged: (value) {
                              setState(() {
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
                              labelText: "Phone number",
                              hintStyle: TextStyle(fontSize: labelHintFontSize),
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _emailController,
                            focusNode: _focusNodeEmail,
                            style: TextStyle(fontSize: contentFontSize),
                            keyboardType: TextInputType.text,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) => (value != null &&
                                    userEmail
                                        .any((element) => element == value) &&
                                    value != currentEmailAddress)
                                ? "Email already exists"
                                : _emailValidation(value),
                            onFieldSubmitted: (v) {
                              FocusScope.of(context)
                                  .requestFocus(_focusNodeBirthDate);
                            },
                            onChanged: (value) {
                              setState(() {
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
                                  color: _focusNodeEmail.hasFocus
                                      ? Colors.blue
                                      : null),
                              labelText: "Email address",
                              hintStyle: TextStyle(fontSize: labelHintFontSize),
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _birthDateController,
                            focusNode: _focusNodeBirthDate,
                            style: TextStyle(fontSize: contentFontSize),
                            decoration: InputDecoration(
                              suffixText: currentBirthDate.isEmpty ? '*' : null,
                              suffixStyle: TextStyle(
                                fontSize: contentFontSize,
                                color: Colors.red,
                              ),
                              labelText: "Birth Date",
                              labelStyle: TextStyle(
                                fontSize: labelHintFontSize,
                              ),
                            ),
                            readOnly: true,
                            onFieldSubmitted: (v) {
                              _getBirthDate();
                              FocusScope.of(context)
                                  .requestFocus(_focusNodeNRIC);
                            },
                            onChanged: (value) {
                              setState(() {
                                _getBirthDate();
                              });
                            },
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(2015),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2015));
                              //DateTime.now() - not to allow to choose before today.
                              if (pickedDate != null) {
                                print(
                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate =
                                    DateFormat('dd-MM-yyyy').format(pickedDate);
                                print(
                                    formattedDate); //formatted date output using intl package =>  2021-03-16
                                setState(() {
                                  _birthDateController.text =
                                      formattedDate; //set output date to TextField value.
                                });
                              } else {
                                FocusManager.instance.primaryFocus?.unfocus();
                              }
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            enabled: currentNRIC.isNotEmpty ? false : true,
                            controller: _nRICController,
                            focusNode: _focusNodeNRIC,
                            keyboardType: TextInputType.number,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            style: TextStyle(fontSize: contentFontSize),
                            validator: (value) => (value != null &&
                                    userUsername
                                        .any((element) => element == value) &&
                                    value != currentNRIC)
                                ? "Invalid IC Number"
                                : _nRICValidation(value),
                            onFieldSubmitted: (v) {
                              FocusScope.of(context)
                                  .requestFocus(_focusNodeAddress);
                            },
                            onChanged: (value) {
                              setState(() {
                                _getNRIC();
                              });
                            },
                            decoration: InputDecoration(
                                suffixText: currentNRIC.isEmpty ? '*' : null,
                                suffixStyle: TextStyle(
                                  fontSize: contentFontSize,
                                  color: Colors.red,
                                ),
                                contentPadding: const EdgeInsets.all(0),
                                errorStyle: TextStyle(
                                  letterSpacing: 0.3,
                                  fontSize: errorFontSize,
                                  color: _nRICErrorTextColorValidation(),
                                ),
                                labelStyle: TextStyle(
                                    letterSpacing: 0.3,
                                    fontSize: labelHintFontSize,
                                    color: _focusNodeNRIC.hasFocus
                                        ? Colors.blue
                                        : null),
                                hintStyle: TextStyle(
                                    letterSpacing: 0.3,
                                    fontSize: labelHintFontSize),
                                labelText: "NRIC / Passport",
                                hintText: "000504-XX-XXXX"),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _addressController,
                            focusNode: _focusNodeAddress,
                            onChanged: (value) {
                              setState(() {
                                _getAddress();
                              });
                            },
                            style: TextStyle(fontSize: contentFontSize),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              suffixText: currentAddress.isEmpty ? '*' : null,
                              suffixStyle: TextStyle(
                                fontSize: contentFontSize,
                                color: Colors.red,
                              ),
                              labelStyle: TextStyle(
                                fontSize: labelHintFontSize,
                              ),
                              labelText: "Address",
                            ),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _vehicleNumberController,
                            focusNode: _focusNodeVehicleNumber,
                            onChanged: (value) {
                              setState(() {
                                _getVehicleNumber();
                              });
                            },
                            style: TextStyle(fontSize: contentFontSize),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                fontSize: labelHintFontSize,
                              ),
                              hintStyle: TextStyle(
                                fontSize: labelHintFontSize,
                              ),
                              labelText: "Vehicle No.",
                              hintText: "ex: ABE7000",
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /*----------------------------------------------------------------
--> Username validation*/

/*----------------------------------------------------------------
--> username validation*/
  Widget _usernameValidationText() {
    return Container(
      decoration: BoxDecoration(
        //color: const Color.fromARGB(255, 211, 209, 209),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        '''- Requires minimum of 3 character and a maximum of 30.\n- Accepted characters are: a-z A-Z 0-9 dot(.) underscore(_).\n- Allow "_" and "." in the middle of character only.\n- Numbers must not be the first character.\n- The dot (.) or underscore (_) must not appear\n  consecutively.''',
        style: TextStyle(
          fontSize: contentFontSize - 3,
          fontWeight: FontWeight.bold,
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
    }
  }

  _usernameErrorTextColorValidation() {
    if (((!UValidator.validateThis(
            pattern: RegPattern.strict, username: _userNameController.text))) ||
        _userNameController.text.trim().isEmpty ||
        !_focusNodeUserName.hasPrimaryFocus ||
        userUsername.any((element) => element == _userNameController.text) &&
            _userNameController.text != currentUserName) {
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

  _emailErrorTextColorValidation() {
    if ((!EmailValidator.validate(_userNameController.text)) ||
        _userNameController.text.trim().isEmpty ||
        !_focusNodeEmail.hasPrimaryFocus ||
        userEmail.any((element) => element == _userNameController.text)) {
      return Colors.red;
    } else {
      return Colors.green;
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
--> Username validation*/
  _nRICValidation(value) {
    RegExp regex = RegExp(
        r'(([[0-9]{2})(0[1-9]|1[0-2])(0[1-9]|[12][0-9]|3[01]))-([0-9]{2})-([0-9]{4})');
    if (value == null || value.trim().isEmpty) {
      if (!_focusNodeUserName.hasPrimaryFocus) {
        return null;
      }
      return 'This field is required';
    }

    if (value != null && !regex.hasMatch(value)) {
      return "Enter a valid IC Number";
    } else {
      if (!_focusNodeUserName.hasPrimaryFocus) {
        return null;
      }
    }
  }

  _nRICErrorTextColorValidation() {
    RegExp regex = RegExp(
        r'(([[0-9]{2})(0[1-9]|1[0-2])(0[1-9]|[12][0-9]|3[01]))-([0-9]{2})-([0-9]{4})');
    if (!regex.hasMatch(_nRICController.text) ||
        _nRICController.text.trim().isEmpty ||
        !_focusNodeNRIC.hasPrimaryFocus ||
        userNRIC.any((element) => element == _nRICController.text) &&
            _nRICController.text != currentNRIC) {
      return Colors.red;
    } else {
      return Colors.green;
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
--> Firebase retrieve all users phone number details*/
  void _getNRIC() {
    FirebaseFirestore.instance.collection("users").snapshots().listen((event) {
      for (var doc in event.docs) {
        userNRIC.add(doc.data()["NRIC"]);
      }
    });
  }

  void _getBirthDate() {
    FirebaseFirestore.instance.collection("users").snapshots().listen((event) {
      for (var doc in event.docs) {
        userBirthDate.add(doc.data()["Birth Date"]);
      }
    });
  }

  void _getAddress() {
    FirebaseFirestore.instance.collection("users").snapshots().listen((event) {
      for (var doc in event.docs) {
        userAddress.add(doc.data()["Address"]);
      }
    });
  }

  void _getVehicleNumber() {
    FirebaseFirestore.instance.collection("users").snapshots().listen((event) {
      for (var doc in event.docs) {
        userAddress.add(doc.data()["Vehicle Number"]);
      }
    });
  }

  void _getFullName() {
    FirebaseFirestore.instance.collection("users").snapshots().listen((event) {
      for (var doc in event.docs) {
        userAddress.add(doc.data()["Full Name"]);
      }
    });
  }

  void generateMemberID() {
    var rnd = Random();
    var next = rnd.nextInt(999999);
    while (next < 999999) {
      next *= 10;
    }
    memberID = next.toString();
    print(next.toInt());
  }

/*----------------------------------------------------------------
--> overall edit_profile validation*/
  void _editProfile() {
    if (!_formKey.currentState!.validate() ||
        _userNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneNumberController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Error saving the data..",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: contentFontSize);
      return;
    }
    if (currentFullName.isEmpty || currentNRIC.isEmpty) {
      generateMemberID();
    }

    Fluttertoast.showToast(
        msg: "Data Saved",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: contentFontSize);

    FirebaseFirestore.instance
        .collection('users')
        .doc((FirebaseAuth.instance.currentUser?.email))
        .update(
      {
        if (currentMemberID.isEmpty &&
            (currentNRIC.isNotEmpty || currentFullName.isNotEmpty))
          "Member ID": memberID,
        "Username": _userNameController.text,
        "Full Name": _fullNameController.text,
        "Phone Number": _phoneNumberController.text,
        "Email": _emailController.text,
        "Birth Date": _birthDateController.text,
        "NRIC": _nRICController.text,
        "Address": _addressController.text,
        "Vehicle Number": _vehicleNumberController.text,
      },
    );

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ProfilePage()));
  }

  Future<bool> _willPopCallback() async {
    Navigator.of(context).push(_createRoute());
    return true;
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const ProfilePage(),
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
