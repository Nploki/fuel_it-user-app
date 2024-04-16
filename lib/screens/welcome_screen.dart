import 'package:flutter/material.dart';
import 'package:fuel_it/provider/auth_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fuel_it/screens/onboarding_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class welcome_screen extends StatefulWidget {
  static const id = 'welcome-screen';

  @override
  State<welcome_screen> createState() => _welcome_screenState();
}

class _welcome_screenState extends State<welcome_screen> {
  @override
  Widget build(BuildContext context) {
    checkPermission(Permission.location);
    Size size = MediaQuery.of(context).size;
    double w = size.width;
    double h = size.height;

    // final auth = Provider.of<AuthProvider>(context);
    AuthProvider auth = AuthProvider();

    bool validphonenumber = false;
    var phoneNumberController = TextEditingController();

    void showBottomSheet(context) {
      showModalBottomSheet(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, StateSetter mystate) {
          return SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                      visible: auth.error == 'Invalid OTP' ? true : false,
                      child: SizedBox(
                        child: Column(
                          children: [
                            Text(auth.error),
                            const SizedBox(
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
                      suffixIcon: validphonenumber
                          ? const Icon(Icons.check_circle_outlined,
                              color: Colors.green)
                          : const Icon(Icons.close, color: Colors.red),
                    ),
                    autofocus: false,
                    maxLength: 10,
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.length != 10) return "Invalid Phone Number ";
                      return null;
                    },
                    onChanged: (value) {
                      if (value.length == 10) {
                        mystate(() {
                          validphonenumber = true;
                        });
                      } else {
                        mystate(() {
                          validphonenumber = false;
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
                          absorbing: validphonenumber ? false : true,
                          child: OutlinedButton(
                            onPressed: () {
                              String number =
                                  '+91${phoneNumberController.text}';
                              auth
                                  .verifyPhone(context, number)
                                  .then((value) => null);
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: validphonenumber
                                  ? const Color.fromARGB(255, 10, 172, 53)
                                  : const Color.fromARGB(255, 158, 3, 29),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: Text(
                              validphonenumber
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

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(children: [
          Positioned(
            right: 0.0,
            top: 10.0,
            child: ElevatedButton(
              child: const Text(
                'SKIP',
                style: TextStyle(color: Colors.lightBlue),
              ),
              onPressed: () {},
            ),
          ),
          Column(children: [
            Expanded(child: OnboardingScreen()),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    horizontal: w * 0.15, vertical: h * 0.02),
                side:
                    const BorderSide(color: Color.fromARGB(255, 223, 203, 197)),
                backgroundColor: const Color.fromARGB(255, 6, 80, 102),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: () {
                setState(() {
                  auth.screeen = 'login';
                });
                showBottomSheet(
                  context,
                );
              },
              child: const Text(
                "Proceed to Login",
                style: TextStyle(color: Color.fromARGB(255, 108, 240, 167)),
              ),
            ),
            const SizedBox(
              height: 10,
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

Future<void> checkPermission(Permission permission) async {
  final status = await permission.request();
  if (!status.isGranted) {
    await permission.request();
  }
}
