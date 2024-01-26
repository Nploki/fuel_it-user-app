import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fuel_it/provider/auth_provider.dart';
import 'package:fuel_it/provider/location_provider.dart';
import 'package:fuel_it/screens/map_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fuel_it/screens/onboarding_screen.dart';

class welcome_screen extends StatelessWidget {
  static const id = 'welcome-screen';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double w = size.width;
    double h = size.height;

    final auth = Provider.of<AuthProvider>(context);

    bool _validphonenumber = false;
    var _phoneNumberController = TextEditingController();

    void showBottomSheet(context) {
      showModalBottomSheet(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, StateSetter mystate) {
          return Container(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                      visible: auth.error == 'Invalid OTP' ? true : false,
                      child: Container(
                        child: Column(
                          children: [
                            Text(auth.error),
                            SizedBox(
                              height: 3,
                            )
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'LOGIN',
                    style: GoogleFonts.tektur(fontSize: 30),
                  ),
                  const SizedBox(
                    height: 7.5,
                  ),
                  const Text(
                    "Enter Your Mobile Number To Proceed",
                    style: TextStyle(fontSize: 17),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      prefixText: "+91  ",
                      labelText: '10 Digit Mobile Number',
                      suffixIcon: _validphonenumber
                          ? const Icon(Icons.check_circle_outlined,
                              color: Colors.green)
                          : const Icon(Icons.close, color: Colors.red),
                    ),
                    autofocus: false,
                    maxLength: 10,
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.length != 10) return "Invalid Phone Number ";
                      return null;
                    },
                    onChanged: (value) {
                      if (value.length == 10) {
                        mystate(() {
                          _validphonenumber = true;
                        });
                      } else {
                        mystate(() {
                          _validphonenumber = false;
                        });
                      }
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AbsorbPointer(
                          absorbing: _validphonenumber ? false : true,
                          child: OutlinedButton(
                            onPressed: () {
                              String number =
                                  '+91${_phoneNumberController.text}';
                              auth
                                  .verifyPhone(context, number)
                                  .then((value) => null);
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: _validphonenumber
                                  ? Color.fromARGB(255, 10, 172, 53)
                                  : Color.fromARGB(255, 158, 3, 29),
                              padding: EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: Text(
                              _validphonenumber
                                  ? 'CONTINUE'
                                  : 'Enter Mobile Number ',
                              style: const TextStyle(
                                fontSize: 17.5,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        }),
      );
    }

    final locationData = Provider.of<LocationProvider>(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(children: [
          Positioned(
            right: 0.0,
            top: 10.0,
            child: ElevatedButton(
              child: Text(
                'SKIP',
                style: TextStyle(color: Colors.lightBlue),
              ),
              onPressed: () {},
            ),
          ),
          Column(children: [
            Expanded(child: OnboardingScreen()),
            const Text(
              "Ready To Order Form Nearest Petrol Bunk",
              style: TextStyle(fontSize: 17),
            ),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    horizontal: w * 0.15, vertical: h * 0.02),
                side: BorderSide(color: Color.fromARGB(255, 223, 203, 197)),
                backgroundColor: Color.fromARGB(255, 6, 80, 102),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: () async {
                await locationData.getCurrentPosition();
                if (locationData.permissionAllowed == true) {
                  Navigator.pushReplacementNamed(context, MapScreen.id);
                } else {
                  print('Permission Not Allowed');
                }
              },
              child: const Text(
                "Set Your Loction !",
                style: TextStyle(color: Color.fromARGB(255, 108, 240, 167)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                showBottomSheet(
                  context,
                );
              },
              child: RichText(
                text: const TextSpan(
                    text: "Existing User ? ",
                    style:
                        TextStyle(fontFamily: 'NotoSans', color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Login",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      )
                    ]),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ]),
        ]),
      ),
    );
  }
}
