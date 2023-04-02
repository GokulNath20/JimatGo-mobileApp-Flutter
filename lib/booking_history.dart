import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jimatgo_app/homepage.dart';
import 'package:jimatgo_app/mainpage.dart';
import 'package:jimatgo_app/profile.dart';
import 'package:jimatgo_app/responsive.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class BookingHistory extends StatefulWidget {
  const BookingHistory({super.key});

  @override
  State<BookingHistory> createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
  late final bookingHistory = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: NewGradientAppBar(
          title: Text(
            "Booking history",
            style: TextStyle(
              fontSize: contentFontSize,
            ),
          ),
          elevation: 0,
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 224, 74, 74),
              Color.fromARGB(255, 213, 164, 29),
            ],
          ),
        ),
        body: SafeArea(
          child: Center(
            child: bookingHistoryDate.isNotEmpty &&
                    bookingHistoryTime.isNotEmpty
                ? Column(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        /* Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const EditProfilePage()) )*/
                        child: Container(
                          height: screenHeight * 0.1,
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 240, 238, 238),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            //color: Colors.grey[300],
                          ),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    /* Container(
                                        child: ListView(
                                      children: bookings.map((strone) {
                                        return Container(
                                          child: Text(strone),
                                          margin: EdgeInsets.all(5),
                                          padding: EdgeInsets.all(15),
                                          color: Colors.green[100],
                                        );
                                      }).toList(),
                                    )), */
                                    Text(
                                      "Basic Inspection",
                                      style: TextStyle(
                                        fontSize: contentFontSize,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Booking Date: $bookingHistoryDate",
                                      style: TextStyle(
                                        fontSize: contentFontSize,
                                      ),
                                    ),
                                    Text(
                                      "Booking Time: $bookingHistoryTime",
                                      style: TextStyle(
                                        fontSize: contentFontSize,
                                      ),
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "No booking history found..",
                        style: TextStyle(
                          fontSize: contentFontSize,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
