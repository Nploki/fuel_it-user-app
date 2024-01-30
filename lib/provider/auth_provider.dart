// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:fuel_it/provider/location_provider.dart';
import 'package:fuel_it/screens/HomeScreen.dart';
import 'package:fuel_it/screens/map_screen.dart';
import 'package:fuel_it/services/user_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  double latitude = 0.0;
  double longitude = 0.0;
  String address = '';
  String locationAddress = '';
  String error = '';
  bool _isLoged = false;
  String screeen = '';
  late String smsOtp;
  late String verificationId;
  UserServices _userServices = UserServices();

  Future<void> verifyPhone(BuildContext context, String number) async {
    try {
      final PhoneVerificationCompleted verificationCompleted =
          (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      };

      final PhoneVerificationFailed verificationFailed =
          (FirebaseAuthException e) {
        print(e.code);
      };

      final PhoneCodeSent smsOtpSend = (String verId, int? resendToken) async {
        this.verificationId = verId;

        // Dialog box to enter OTP
        await smsOtpDialog(context, number);
      };

      await _auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: smsOtpSend,
        codeAutoRetrievalTimeout: (String verId) {
          this.verificationId = verId;
        },
      );
    } catch (e) {
      print('Error during phone verification: $e');
    }
  }

  Future<void> smsOtpDialog(BuildContext context, String number) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Column(
            children: [
              Text("Verification Code"),
              SizedBox(
                height: 6,
              ),
              Text(
                "Enter 6 Digit OTP Received as SMS",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          content: Container(
            height: 85,
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 6,
              onChanged: (value) {
                this.smsOtp = value;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: verificationId,
                    smsCode: smsOtp,
                  );

                  final UserCredential userCredential =
                      await _auth.signInWithCredential(credential);

                  final User? user = userCredential.user;

                  if (user != null) {
                    _userServices.getUserById(user.uid).then((snapShot) {
                      if (snapShot.exists) {
                        //user data exists
                        if (this.screeen == 'login') {}
                      } else {
                        //user data dosen's exists
                      }
                    });

                    _createUserAndNavigateToMapScreen(
                      context: context,
                      id: user.uid,
                      number: user.phoneNumber ?? '',
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('OTP Verified Successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    print("Login Failed");
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid OTP'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "DONE",
                  style: TextStyle(color: Colors.amber.shade700),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _createUserAndNavigateToMapScreen({
    required BuildContext context,
    required String id,
    required String number,
  }) async {
    _userServices.createUserData({
      'id': id,
      'number': number,
      'Latitude': 0.0,
      'Longitude': 0.0,
      'location': GeoPoint(0, 0),
      'address': 'address',
      'locationAddress': 'loc_Addr',
    });
    this._isLoged = true;
    Navigator.pushReplacementNamed(context, MapScreen.id,
        arguments: {'id': id, 'number': number});
  }

  // Future<void> _updateUser({
  //   required BuildContext context, // Add BuildContext parameter
  //   required String id,
  //   required String number,
  //   required double latitude,
  //   required double longitude,
  //   required String address,
  // }) async {
  //   _userServices.updateUserData({
  //     'id': id,
  //     'number': number,
  //     'location': GeoPoint(latitude, longitude),
  //     'address': address,
  //   });
  // }

  Future<void> savepref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', this.latitude);
    prefs.setDouble('longitude', this.longitude);
    prefs.setString('address', this.address);
  }
}
