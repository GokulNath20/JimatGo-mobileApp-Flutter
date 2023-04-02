// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jimatgo_app/booking.dart';
import 'package:jimatgo_app/booking_history.dart';
import 'package:jimatgo_app/loading_screen.dart';
import 'package:jimatgo_app/logout_success.dart';
import 'package:jimatgo_app/mainpage.dart';
import 'package:jimatgo_app/register.dart';
import 'package:jimatgo_app/responsive.dart';
import 'package:jimatgo_app/profile.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

String bookingHistoryDate = "";
String bookingHistoryTime = "";
late final bookings = [];

class _HomePageState extends State<HomePage> {
  List<String> numbersList = NumberGenerator().numbers;

  bool stackIsGo = true;

  late String _currentUserName = "";
  var _currentIndex = 0;
  late final _images = []; //store images

  @override
  void initState() {
    super.initState();
    _getData();
    getCurrentUserData();
    _getBookingData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool iconVisible = stackIsGo;
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
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: _pullRefresh,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      height: screenWidth <= 410
                          ? 175
                          : screenWidth > 410 && screenWidth <= 700
                              ? 190
                              : 240,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Color.fromARGB(255, 224, 74, 74),
                            Color.fromARGB(255, 213, 164, 29),
                          ],
                        ),
                        //color: Color.fromARGB(255, 227, 203, 85),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 12, 12, 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(_createRoute());
                              },
                              child: Align(
                                alignment: Alignment.topRight,
                                child: currentMemberID.isEmpty
                                    ? Badge(
                                        smallSize: screenWidth <= 410
                                            ? 7.0
                                            : screenWidth > 410 &&
                                                    screenWidth <= 700
                                                ? 10.0
                                                : 12.0,
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white),
                                          child: Image.asset(
                                            "assets/images/profile_icon.png",
                                            scale: screenWidth <= 410
                                                ? 2.5
                                                : screenWidth > 410 &&
                                                        screenWidth <= 700
                                                    ? 2.0
                                                    : 1.5,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                        child: Image.asset(
                                          "assets/images/profile_icon.png",
                                          scale: screenWidth <= 410
                                              ? 2.5
                                              : screenWidth > 410 &&
                                                      screenWidth <= 700
                                                  ? 2.0
                                                  : 1.5,
                                        ),
                                      ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Hi $_currentUserName",
                                style: TextStyle(
                                  fontSize: contentFontSize + 6,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Welcome Back",
                                    style: TextStyle(
                                      fontSize: contentFontSize + 8,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Image.asset("assets/images/hand_icon.png",
                                    scale: screenWidth <= 410
                                        ? 10.0
                                        : screenWidth > 410 &&
                                                screenWidth <= 700
                                            ? 8.0
                                            : 6.0),
                              ],
                            ),
                            Container(
                              width: screenWidth,
                              padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: screenHeight * 0.035,
                                        width: screenHeight * 0.035,
                                        child: const Image(
                                            image: AssetImage(
                                                "assets/images/points_icon.png")),
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Text(
                                          "50 points",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: contentFontSize,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: screenWidth * 0.05),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const BookingHistory()));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5.0),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomLeft,
                                          end: Alignment.topRight,
                                          colors: [
                                            Color.fromARGB(255, 229, 33, 33),
                                            Color.fromARGB(255, 233, 173, 10)
                                          ],
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Booking History",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: contentFontSize,
                                                color: Colors.white),
                                          ),
                                          const Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(3, 15, 3, 0),
                              child: SizedBox(
                                height: screenHeight / 5,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            print(userUsername.toString());
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const BookingPage()));
                                          },
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                "assets/images/car_service_icon.png",
                                                scale: 14.0,
                                              ),
                                              const SizedBox(height: 5),
                                              Text("Basic Inspection",
                                                  style: TextStyle(
                                                      fontSize:
                                                          contentFontSize - 3,
                                                      fontWeight:
                                                          FontWeight.w300)),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Image.asset(
                                              "assets/images/car_alignment_icon.png",
                                              scale: 14.0,
                                            ),
                                            const SizedBox(height: 5),
                                            Text("Tyre Alignment",
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize:
                                                        contentFontSize - 3,
                                                    fontWeight:
                                                        FontWeight.w300)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Image.asset(
                                              "assets/images/OBD2_Inspection_icon.png",
                                              scale: 14.0,
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              "OBD2 Inspection",
                                              style: TextStyle(
                                                  fontSize: contentFontSize - 3,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Image.asset(
                                              "assets/images/car_battery_icon.png",
                                              scale: 14.0,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "Car Battery",
                                              style: TextStyle(
                                                  fontSize: contentFontSize - 3,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Image.asset(
                                              "assets/images/car_insurance_icon.png",
                                              scale: 14.0,
                                            ),
                                            const SizedBox(height: 5),
                                            Text("Insurance",
                                                style: TextStyle(
                                                    fontSize:
                                                        contentFontSize - 3,
                                                    fontWeight:
                                                        FontWeight.w300)),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Image.asset(
                                              "assets/images/claiming_icon.png",
                                              scale: 14.0,
                                            ),
                                            const SizedBox(height: 5),
                                            Text("Claiming",
                                                style: TextStyle(
                                                    fontSize:
                                                        contentFontSize - 3,
                                                    fontWeight:
                                                        FontWeight.w300)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Image.asset(
                                              "assets/images/aircond_service_icon.png",
                                              scale: 14.0,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "Aircond Service",
                                              style: TextStyle(
                                                  fontSize: contentFontSize - 3,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Image.asset(
                                              "assets/images/more_icon.png",
                                              scale: 14.0,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "More",
                                              style: TextStyle(
                                                  fontSize: contentFontSize - 3,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                            height: screenWidth * 0.08,
                            width: screenWidth / 2.7,
                            padding: const EdgeInsets.fromLTRB(7, 5, 7, 5),
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 221, 184, 81),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Unlimited",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: contentFontSize,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      "Go Package",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: contentFontSize,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Image.asset(
                                      "assets/images/jimatGo_GoPackage.png",
                                      height: screenWidth * 0.2,
                                      width: screenWidth * 0.2,
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
                            )),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Highlights",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: contentFontSize),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  "More >",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: contentFontSize,
                                    color: const Color.fromARGB(
                                        226, 108, 131, 234),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          height: screenWidth * 0.5,
                          width: double.maxFinite,
                          child: CarouselSlider(
                            items: [
                              for (int i = 0; i < _images.length - 4; i++)
                                CachedNetworkImage(
                                  imageUrl: _images[i],
                                  fadeInDuration: const Duration(seconds: 1),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(30)),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: const Color.fromARGB(
                                        255, 239, 237, 237),
                                    highlightColor: const Color.fromARGB(
                                        255, 199, 198, 198),
                                    child: Container(
                                      color: const Color.fromARGB(
                                          255, 215, 214, 214),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Shimmer.fromColors(
                                    baseColor: const Color.fromARGB(
                                        255, 239, 237, 237),
                                    highlightColor: const Color.fromARGB(
                                        255, 199, 198, 198),
                                    child: Container(
                                      color: const Color.fromARGB(
                                          255, 215, 214, 214),
                                    ),
                                  ),
                                ),
                            ],
                            options: CarouselOptions(
                              aspectRatio: 2.0,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 6),
                              autoPlayAnimationDuration:
                                  const Duration(seconds: 1),
                              autoPlayCurve: Curves.easeInOut,
                              enlargeCenterPage: true,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < _images.length - 4; i++)
                          Container(
                            height: screenWidth * 0.01,
                            width: screenWidth * 0.03,
                            margin: const EdgeInsets.all(1.5),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                                color: _currentIndex == i
                                    ? const Color.fromARGB(255, 208, 153, 43)
                                    : const Color.fromARGB(255, 234, 208, 155)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Promotions",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: contentFontSize),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  "More >",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: contentFontSize,
                                      color: const Color.fromARGB(
                                          226, 108, 131, 234)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: _images[5],
                                  fadeInDuration: const Duration(seconds: 1),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: screenWidth * 0.35,
                                    width: screenWidth * 0.3,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: const Color.fromARGB(
                                        255, 239, 237, 237),
                                    highlightColor: const Color.fromARGB(
                                        255, 199, 198, 198),
                                    child: Container(
                                      color: const Color.fromARGB(
                                          255, 215, 214, 214),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Shimmer.fromColors(
                                    baseColor: const Color.fromARGB(
                                        255, 239, 237, 237),
                                    highlightColor: const Color.fromARGB(
                                        255, 199, 198, 198),
                                    child: Container(
                                      color: const Color.fromARGB(
                                          255, 215, 214, 214),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                CachedNetworkImage(
                                  imageUrl: _images[6],
                                  fadeInDuration: const Duration(seconds: 1),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: screenWidth * 0.35,
                                    width: screenWidth * 0.3,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: const Color.fromARGB(
                                        255, 239, 237, 237),
                                    highlightColor: const Color.fromARGB(
                                        255, 199, 198, 198),
                                    child: Container(
                                      color: const Color.fromARGB(
                                          255, 215, 214, 214),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Shimmer.fromColors(
                                    baseColor: const Color.fromARGB(
                                        255, 239, 237, 237),
                                    highlightColor: const Color.fromARGB(
                                        255, 199, 198, 198),
                                    child: Container(
                                      color: const Color.fromARGB(
                                          255, 215, 214, 214),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                CachedNetworkImage(
                                  imageUrl: _images[7],
                                  fadeInDuration: const Duration(seconds: 1),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: screenWidth * 0.35,
                                    width: screenWidth * 0.3,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: const Color.fromARGB(
                                        255, 239, 237, 237),
                                    highlightColor: const Color.fromARGB(
                                        255, 199, 198, 198),
                                    child: Container(
                                      color: const Color.fromARGB(
                                          255, 215, 214, 214),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Shimmer.fromColors(
                                    baseColor: const Color.fromARGB(
                                        255, 239, 237, 237),
                                    highlightColor: const Color.fromARGB(
                                        255, 199, 198, 198),
                                    child: Container(
                                      color: const Color.fromARGB(
                                          255, 215, 214, 214),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                CachedNetworkImage(
                                  imageUrl: _images[8],
                                  fadeInDuration: const Duration(seconds: 1),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: screenWidth * 0.35,
                                    width: screenWidth * 0.3,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: const Color.fromARGB(
                                        255, 239, 237, 237),
                                    highlightColor: const Color.fromARGB(
                                        255, 199, 198, 198),
                                    child: Container(
                                      color: const Color.fromARGB(
                                          255, 215, 214, 214),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Shimmer.fromColors(
                                    baseColor: const Color.fromARGB(
                                        255, 239, 237, 237),
                                    highlightColor: const Color.fromARGB(
                                        255, 199, 198, 198),
                                    child: Container(
                                      color: const Color.fromARGB(
                                          255, 215, 214, 214),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Follow us",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: contentFontSize),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: screenWidth * 0.08,
                                    width: screenWidth * 0.08,
                                    padding: const EdgeInsets.all(0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0.0,
                                          backgroundColor:
                                              Colors.white.withOpacity(0.1),
                                          padding: const EdgeInsets.all(3)),
                                      onPressed: _facebookUrlLaunch,
                                      child: const Image(
                                          image: AssetImage(
                                              "assets/images/facebook_icon.png")),
                                    ),
                                  ),
                                  Container(
                                    height: screenWidth * 0.08,
                                    width: screenWidth * 0.08,
                                    padding: const EdgeInsets.all(0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0.0,
                                          backgroundColor:
                                              Colors.white.withOpacity(0.1),
                                          padding: const EdgeInsets.all(3)),
                                      onPressed: _instagramUrlLaunch,
                                      child: const Image(
                                          image: AssetImage(
                                              "assets/images/instagram_icon.png")),
                                    ),
                                  ),
                                  Container(
                                    height: screenWidth * 0.08,
                                    width: screenWidth * 0.08,
                                    padding: const EdgeInsets.all(0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0.0,
                                          backgroundColor:
                                              Colors.white.withOpacity(0.1),
                                          padding: const EdgeInsets.all(3)),
                                      onPressed: _whatsappUrlLaunch,
                                      child: const Image(
                                          image: AssetImage(
                                              "assets/images/whatsapp_icon.png")),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Copyright © 2022. All Rights Reserved.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: contentFontSize,
                                      color: const Color.fromARGB(
                                          255, 136, 133, 133)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Image.asset(
                            "assets/images/JimatGO_FooterLogo.png",
                            scale: 5.0,
                          ),
                        ],
                      ),
                    ),
                    Container(height: 20),
                  ],
                ),
              ),
              Positioned(
                right: 5,
                bottom: 50,
                height: 100,
                width: 100,
                child: Visibility(
                  visible: iconVisible,
                  maintainSize: true,
                  maintainState: true,
                  maintainAnimation: true,
                  replacement: Container(),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            stackIsGo = !stackIsGo;
                          });
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            height: 22,
                            padding: const EdgeInsets.all(2.0),
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close,
                                size: 20, color: Colors.white),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const LoadingScreen())),
                        child: SizedBox(
                          height: 73,
                          child: Stack(
                            children: [
                              Container(
                                height: 60,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 2,
                                      color: const Color.fromARGB(
                                          255, 213, 164, 29),
                                    ),
                                    shape: BoxShape.circle,
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          "assets/images/car_moving.gif"),
                                    )),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(3.0),
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color.fromARGB(255, 224, 74, 74),
                                        Color.fromARGB(255, 213, 164, 29),
                                      ],
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    shape: BoxShape.rectangle,
                                    color: Colors.blue,
                                  ),
                                  child: const Text(
                                    "FREE SERVICE",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _facebookUrlLaunch() async {
    final Uri facebookUrl =
        Uri.parse('https://www.facebook.com/jimatgoservice');
    if (!await launchUrl(facebookUrl)) {
      throw Exception('Could not launch $facebookUrl');
    }
  }

  Future<void> _instagramUrlLaunch() async {
    final Uri instagramUrl = Uri.parse(
        'https://www.instagram.com/jimatgo/?fbclid=IwAR2itkhCszYTC76nQ9GHcPX_KsZUJo1Hw0kOjrxhLq9qEW0PnCAN3YGUlFI');

    if (!await launchUrl(instagramUrl)) {
      throw Exception('Could not launch $instagramUrl');
    }
  }

  Future<void> _whatsappUrlLaunch() async {
    String appUrl;
    String phone = '+601136044399'; // phone number to send the message to
    String message = 'JimatGo,'; // message to send
    if (Platform.isAndroid) {
      appUrl =
          "whatsapp://send?phone=$phone&text=${Uri.parse(message)}"; // URL for Android devices
    } else {
      appUrl =
          "https://api.whatsapp.com/send?phone=$phone=${Uri.parse(message)}"; // URL for non-Android devices
    }

    // check if the URL can be launched
    if (await canLaunchUrl(Uri.parse(appUrl))) {
      // launch the URL
      await launchUrl(Uri.parse(appUrl));
    } else {
      // throw an error if the URL cannot be launched
      throw 'Could not launch $appUrl';
    }
  }

  Future<void> _getData() async {
    FirebaseFirestore.instance
        .collection("app_images")
        .snapshots()
        .listen((event) {
      setState(() {
        for (var doc in event.docs) {
          _images.add(doc.data()["img_path"]);
        }
        return;
      });
    });
  }

  Future<dynamic> getCurrentUserData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc((FirebaseAuth.instance.currentUser?.email))
        .get()
        .then((value) {
      _currentUserName = value.data()!['Username'].toString();
    });
  }

  Future<void> _getBookingData() async {
    /* FirebaseFirestore.instance
        .collection("bookings")
        .doc((FirebaseAuth.instance.currentUser?.email))
        .collection("Basic Inspection")
        .snapshots()
        .listen((event) {
      for (var doc in event.docs) {
        bookings.add(doc.data()[0]['Booking Date']);
      }
    }); */

    await FirebaseFirestore.instance
        .collection('bookings')
        .doc((FirebaseAuth.instance.currentUser?.email))
        .collection("Basic Inspection")
        .doc('30-03-2023')
        .get()
        .then((value) {
      setState(() {
        bookingHistoryDate = value.data()!['Booking Date'].toString();
        bookingHistoryTime = value.data()!['Booking Time'].toString();
      });
    });
  }

  Future<void> _pullRefresh() async {
    List<String> freshNumbers = await NumberGenerator().slowNumbers();
    setState(() {
      numbersList = freshNumbers;
    });
    // why use freshNumbers var? https://stackoverflow.com/a/52992836/2301224
  }

  /*----------------------------------------------------------------
--> action to take if the return button in phone is clicked*/
  Future<bool> _willPopCallback() async {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
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

class NumberGenerator {
  Future<List<String>> slowNumbers() async {
    return Future.delayed(
      const Duration(milliseconds: 1000),
      () => numbers,
    );
  }

  List<String> get numbers => List.generate(5, (index) => number);

  String get number => Random().nextInt(99999).toString();
}
