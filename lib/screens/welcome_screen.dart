import 'package:flutter/material.dart';
import 'package:fuel_it/screens/onboarding_screen.dart';

class welcome_screen extends StatelessWidget {
  const welcome_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Expanded(child: OnboardingScreen()),
          Text("Ready to Order from your near by Petrol Bump"),
          SizedBox(
            height: 20,
          )
        ]),
      ),
    );
  }
}
