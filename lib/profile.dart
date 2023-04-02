// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:jimatgo_app/auth.dart';
import 'package:jimatgo_app/edit_profile.dart';
import 'package:jimatgo_app/homepage.dart';
import 'package:jimatgo_app/logout_success.dart';
import 'package:jimatgo_app/mainpage.dart';
import 'package:jimatgo_app/responsive.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

String currentMemberID = "";
String currentUserName = "";
String currentFullName = "";
String currentPhoneNumber = "";
String currentEmailAddress = "";
String currentBirthDate = "";
String currentNRIC = "";
String currentAddress = "";
String currentVehicleNumber = "";

class _ProfilePageState extends State<ProfilePage> {
  //late String _memberID = "";

  @override
  void initState() {
    super.initState();
    _getCurrentUserData();
    //_getMemberId();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: NewGradientAppBar(
            elevation: 0,
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 224, 74, 74),
                Color.fromARGB(255, 213, 164, 29),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: screenHeight * 0.25,
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 20, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context)
                            .pushReplacement(_createRoute()),
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 27,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4.0),
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                      colors: [
                                        Color.fromARGB(255, 213, 164, 29),
                                        Color.fromARGB(255, 224, 74, 74),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.email_outlined,
                                    color: Colors.white,
                                    size: 27,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Inbox",
                                  style: TextStyle(
                                      fontSize: contentFontSize - 1,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  child: Image.asset(
                                    "assets/images/profile_icon.png",
                                    scale: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  currentUserName.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: contentFontSize,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const EditProfilePage())),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4.0),
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                        colors: [
                                          Color.fromARGB(255, 224, 74, 74),
                                          Color.fromARGB(255, 213, 164, 29),
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 27,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Edit info",
                                    style: TextStyle(
                                        fontSize: contentFontSize - 1,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          currentMemberID.isNotEmpty
                              ? Text(
                                  "Member ID: $currentMemberID",
                                  style: TextStyle(
                                    fontSize: contentFontSize,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  "Member ID: -",
                                  style: TextStyle(
                                    fontSize: contentFontSize,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                          if (currentMemberID.isNotEmpty)
                            const Icon(
                              Icons.verified_user_rounded,
                              color: Colors.yellow,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (currentFullName.isEmpty || currentNRIC.isEmpty)
                GestureDetector(
                  onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const EditProfilePage())),
                  child: Container(
                    height: screenHeight * 0.08,
                    width: screenWidth / 1.1,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      color: Colors.grey[300],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.person_2_outlined,
                          color: Colors.black.withOpacity(0.7),
                          size: 40,
                        ),
                        Text(
                          '''Complete your profile to enjoy\nmembership discounts..''',
                          style: TextStyle(
                            fontSize: contentFontSize,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          weight: 0.5,
                          size: 20,
                          color: Color.fromARGB(255, 224, 74, 74),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(
                height: screenHeight * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.receipt_long_outlined,
                                weight: 0.5,
                                size: 27,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Transaction History",
                                style: TextStyle(
                                  fontSize: contentFontSize,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            weight: 0.5,
                            size: 20,
                            color: Color.fromARGB(255, 224, 74, 74),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.credit_card_outlined,
                                weight: 0.5,
                                size: 27,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Manage Credit / Debit Cards",
                                style: TextStyle(
                                  fontSize: contentFontSize,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            weight: 0.5,
                            size: 20,
                            color: Color.fromARGB(255, 224, 74, 74),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.password,
                                weight: 0.5,
                                size: 27,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Password & Security",
                                style: TextStyle(
                                  fontSize: contentFontSize,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            weight: 0.5,
                            size: 20,
                            color: Color.fromARGB(255, 224, 74, 74),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.settings,
                                weight: 0.5,
                                size: 27,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Settings",
                                style: TextStyle(
                                  fontSize: contentFontSize,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            weight: 0.5,
                            size: 20,
                            color: Color.fromARGB(255, 224, 74, 74),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.tag_faces_sharp,
                                weight: 0.5,
                                size: 27,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Refer a Friend",
                                style: TextStyle(
                                  fontSize: contentFontSize,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            weight: 0.5,
                            size: 20,
                            color: Color.fromARGB(255, 224, 74, 74),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.headphones_outlined,
                                weight: 0.5,
                                size: 27,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Help & Support",
                                style: TextStyle(
                                  fontSize: contentFontSize,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            weight: 0.5,
                            size: 20,
                            color: Color.fromARGB(255, 224, 74, 74),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => signOut(),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.logout_rounded,
                              weight: 0.5,
                              size: 27,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Logout",
                              style: TextStyle(
                                fontSize: contentFontSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              /*  const Text("Successful Login"),
              ElevatedButton(
                //style: ElevatedButton.styleFrom(),
                child: const Text('Sign Out'),
                onPressed: () {
                  
                },
              ), */
            ],
          ),
        ),
      ),
    );
  }

  /*----------------------------------------------------------------
--> Firebase Authentication for SignOut account*/
  Future<void> signOut() async {
    await Auth().signOut().then((value) async => {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LogoutSuccess())),
        });
  }

  Future<void> _getCurrentUserData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc((FirebaseAuth.instance.currentUser?.email))
        .get()
        .then((value) {
      setState(() {
        currentMemberID = value.data()!['Member ID'].toString();
        currentUserName = value.data()!['Username'].toString();
        currentFullName = value.data()!['Full Name'].toString();
        currentPhoneNumber = value.data()!['Phone Number'].toString();
        currentEmailAddress = value.data()!['Email'].toString();
        currentBirthDate = value.data()!['Birth Date'].toString();
        currentNRIC = value.data()!['NRIC'].toString();
        currentAddress = value.data()!['Address'].toString();
        currentVehicleNumber = value.data()!['Vehicle Number'].toString();
      });
    });
  }

  /* Future<void> _getMemberId() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc((FirebaseAuth.instance.currentUser?.uid))
        .get()
        .then((value) {
      setState(() {
        _memberID = value.data().toString();
      });
    });
  }  */

  /*----------------------------------------------------------------
--> action to take if the return button in phone is clicked*/
  Future<bool> _willPopCallback() async {
    Navigator.of(context).pushReplacement(_createRoute());
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
            Tween(end: end, begin: begin).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
