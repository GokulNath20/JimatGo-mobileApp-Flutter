// ignore_for_file: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jimatgo_app/responsive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String? errorMessage = '';
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
Stream<User?> get authStateChanges => _firebaseAuth.userChanges();
/* User? get currentUser => _firebaseAuth.currentUser;
final uid = currentUser?.uid;
final email = currentUser?.email; */
Map<String, dynamic>? _userData;

class Auth {
  AccessToken? _accessToken;
  late String link;
  late String birthday;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential googleAuthCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    await _firebaseAuth.signInWithCredential(googleAuthCredential);
  }

  Future<dynamic> signInWithFacebook() async {
    try {
      final accessToken = await FacebookAuth.instance.accessToken;

      if (accessToken != null) {
        final userData = await FacebookAuth.instance.getUserData();
        _accessToken = accessToken;
        _userData = userData;
      } else {
        final LoginResult result = await FacebookAuth.instance.login();

        if (result.status == LoginStatus.success) {
          _accessToken = result.accessToken;

          final userData = await FacebookAuth.instance.getUserData();
          _userData = userData;

          final AuthCredential facebookAuthCredential =
              FacebookAuthProvider.credential(result.accessToken!.token);

          await _firebaseAuth.signInWithCredential(facebookAuthCredential);
          FirebaseFirestore.instance
              .collection('users')
              .doc(_userData!['email'])
              .set(
            {
              "Username": _userData!['name'],
              "Access Token": _accessToken,
              "Email": _userData!['email'],
              "User_ID": _userData!['id'],
            },
          );
          Fluttertoast.showToast(
              msg: "Login Successful",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: contentFontSize);

          return "Login Successful";
        }
        if (result.status == LoginStatus.cancelled) {
          Fluttertoast.showToast(
              msg: "Login cancelled",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: contentFontSize);
          return;
        }
        if (result.status == LoginStatus.operationInProgress) {
          Fluttertoast.showToast(
              msg: "Logging in",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: contentFontSize);
          return;
        }

        if (result.status == LoginStatus.failed) {
          Fluttertoast.showToast(
              msg: "Login error",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: contentFontSize);
          return;
        }
      }
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      Fluttertoast.showToast(
          msg: '$errorMessage',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: contentFontSize);
      return;
    }
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    await _firebaseAuth.sendPasswordResetEmail(
      email: email,
    );
  }

  Future<void> signOut() async {
    //Facebook Account Logout
    await FacebookAuth.instance.logOut();
    _accessToken = null;
    _userData = null;

    //Google Account Logout
    await _googleSignIn.signOut();

    //Firebase Account Logout
    await _firebaseAuth.signOut();
  }
}
