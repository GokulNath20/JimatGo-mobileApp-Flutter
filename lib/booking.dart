import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jimatgo_app/homepage.dart';
import 'package:jimatgo_app/profile.dart';
import 'package:jimatgo_app/responsive.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _bookingDateController = TextEditingController();
  var _vehicleNumberController = TextEditingController();
  //final _bookingTimeController = TextEditingController();
  final FocusNode _focusNodeBookingDate = FocusNode();
  final FocusNode _focusNodeBookingTime = FocusNode();
  final FocusNode _focusNodeVehicleNumber = FocusNode();

  final _formKey = GlobalKey<FormState>();

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = const [
      DropdownMenuItem(value: "10.00am", child: Text("10.00am")),
      DropdownMenuItem(value: "11.00am", child: Text("11.00am")),
      DropdownMenuItem(value: "12.00pm", child: Text("12.00pm")),
      DropdownMenuItem(value: "2.00pm", child: Text("2.00pm")),
      DropdownMenuItem(value: "3.00pm", child: Text("3.00pm")),
      DropdownMenuItem(value: "4.00pm", child: Text("4.00pm")),
    ];
    return menuItems;
  }

  String selectedValue = "10.00am";

  @override
  void initState() {
    super.initState();

    _vehicleNumberController =
        TextEditingController(text: currentVehicleNumber);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: NewGradientAppBar(
          title: Text(
            "Basic Inspection",
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/car_service_icon.png",
                    scale: 3.0,
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color.fromARGB(255, 212, 211, 211)),
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "A car or vehicle inspection is a service offered by a specialist or expert provider where a trained inspector will inspect your vehicle inside and out to find any problems that are present or are even showing early stages of happening.",
                        style: TextStyle(
                          fontSize: contentFontSize,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: _bookingDateController,
                      focusNode: _focusNodeBookingDate,
                      style: TextStyle(
                          fontSize: contentFontSize,
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.calendar_month_outlined),
                        labelText: "Select your booking date",
                        labelStyle: TextStyle(
                          fontSize: labelHintFontSize,
                        ),
                      ),
                      readOnly: true,
                      onFieldSubmitted: (v) {
                        FocusScope.of(context)
                            .requestFocus(_focusNodeBookingTime);
                      },
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2024));
                        //DateTime.now() - not to allow to choose before today.
                        if (pickedDate != null) {
                          print(
                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate =
                              // DateFormat('yyyy-MM-dd').format(pickedDate);
                              DateFormat('dd-MM-yyyy').format(pickedDate);
                          print(
                              formattedDate); //formatted date output using intl package =>  2021-03-16
                          setState(() {
                            _bookingDateController.text =
                                formattedDate; //set output date to TextField value.
                          });
                        } else {
                          FocusManager.instance.primaryFocus?.unfocus();
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select your booking time",
                        style: TextStyle(
                          fontSize: contentFontSize,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 15, 50, 10),
                    child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        dropdownColor: Colors.white,
                        value: selectedValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue!;
                          });
                        },
                        items: dropdownItems),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextFormField(
                      enabled: false,
                      controller: _vehicleNumberController,
                      focusNode: _focusNodeVehicleNumber,
                      style: TextStyle(
                          fontSize: contentFontSize,
                          fontWeight: FontWeight.bold),
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 5),
                        ),
                        prefixIcon: Icon(
                          Icons.car_rental,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  /* Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: _bookingTimeController,
                      focusNode: _focusNodeBookingTime,
                      style: TextStyle(
                          fontSize: contentFontSize,
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.access_time),
                          labelText: "State your booking time",
                          labelStyle: TextStyle(
                            fontSize: labelHintFontSize,
                          ),
                          hintStyle: TextStyle(fontSize: labelHintFontSize),
                          hintText: ("ex: 2.30pm")),
                    ),
                  ), */
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(20)),
                        textStyle: MaterialStateProperty.all(const TextStyle(
                            fontSize: 14, color: Colors.white))),
                    onPressed: () {
                      _bookingService();
                    },
                    child: const Text('Book Now'),
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
--> overall booking validation*/
  void _bookingService() {
    if (!_formKey.currentState!.validate() ||
        _bookingDateController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please complete the booking details",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: contentFontSize);
      return;
    }

    FirebaseFirestore.instance
        .collection('bookings')
        .doc((FirebaseAuth.instance.currentUser?.email))
        .collection("Basic Inspection")
        .doc(_bookingDateController.text)
        .set(
      {
        "Vehicle Number": _vehicleNumberController.text,
        "Booking Date": _bookingDateController.text,
        "Booking Time": selectedValue,
      },
    );

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()));
    Fluttertoast.showToast(
        msg: "Booking Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: contentFontSize);
    return;
  }
}
