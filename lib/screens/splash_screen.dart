import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fuel_it/screens/main_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fuel_it/screens/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  static const id = 'splash-screen';
  const SplashScreen({Key? key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      // Navigator.pushReplacementNamed(context, welcome_screen.id);
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          Navigator.pushReplacementNamed(context, welcome_screen.id);
        } else {
          Navigator.pushReplacementNamed(context, MainScreen.id);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double w = size.width;
    double h = size.height;

    return Scaffold(
      body: Container(
        child: Column(children: [
          const SizedBox(
            height: 100,
          ),
          const Image(
            image: NetworkImage(
                "https://cdni.iconscout.com/illustration/premium/thumb/fuel-payment-using-mobile-phone-7365838-6027095.png?f=webp"),
            width: 500,
            height: 400,
          ),
          Text(
            "Skip the pump, fill your tank.\n Effortless fuel delivery\n Just a tap away",
            textAlign: TextAlign.center,
            style: GoogleFonts.quantico(fontSize: 17),
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 30,
          ),
          Text("FUEL-IT",
              style: GoogleFonts.viga(
                letterSpacing: 5,
                fontSize: 50,
                color: const Color.fromARGB(255, 0, 58, 50),
                shadows: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 55, 233, 150)
                        .withOpacity(1), // Matching color
                    blurRadius: 5,
                    spreadRadius: 5,
                  ),
                ],
              )),
        ]),
      ),
    );
  }
}
