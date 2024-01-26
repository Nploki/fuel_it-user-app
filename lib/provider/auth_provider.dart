import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fuel_it/screens/HomeScreen.dart';
import 'package:fuel_it/services/user_services.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String error = '';
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
          title: Column(
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
                    //create new user
                    _createUser(id: user.uid, number: user.phoneNumber ?? '');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('OTP Verified Successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, HomeScreen.id);
                  } else {
                    print("Login Failed");
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
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

  void _createUser({required String id, required String number}) {
    _userServices.createUserData({
      'id': id,
      'number': number,
    });
  }
}
