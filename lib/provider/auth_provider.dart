import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fuel_it/screens/map_screen.dart';
import 'package:fuel_it/services/user_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String addr = "";
  String Name = "";
  String no = "";
  double latitude = 0.0;
  double longitude = 0.0;
  double ulatitude = 0.0;
  double ulongitude = 0.0;
  String address = '';
  String locationAddress = '';
  String error = '';
  bool _isLoged = false;
  String screeen = '';
  late String smsOtp;
  late String verificationId;
  UserServices _userServices = UserServices();

  Future<GeoPoint?> getUserLocation(String userId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        dynamic userData = snapshot.data();
        if (userData != null && userData['location'] != null) {
          Map<String, dynamic> locationData = userData['location'];
          double latitude = locationData['latitude'];
          double longitude = locationData['longitude'];
          return GeoPoint(latitude, longitude);
        }
      }
      print('User document does not exist or location data is missing');
      return null;
    } catch (e) {
      print('Error retrieving user location: $e');
      return null;
    }
  }

  void getadddr() async {
    final auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    GeoPoint? userLocation = await getUserLocation(user!.uid);

    if (userLocation != null) {
      this.ulatitude = userLocation.latitude;
      this.ulongitude = userLocation.longitude;
    } else {
      print('User location not found or unavailable');
    }
  }

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
        verificationId = verId;

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
    getadddr();
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
                    showNameDialog(context, user.uid);
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

  void showNameDialog(BuildContext context, String userId) {
    String userName = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Your Name'),
          content: TextField(
            onChanged: (value) {
              userName = value;
            },
            decoration: InputDecoration(hintText: 'Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                saveUserName(userId, userName);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserName(String userId, String userName) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'name': userName,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving user name: $e');
    }
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
      'location': const GeoPoint(0, 0),
      'address': 'address',
      'name': '',
      'gender': '',
      'bike_no': '',
      'lisence': '',
      'aadhar': '',
    });
    this._isLoged = true;
    Navigator.pushReplacementNamed(context, MapScreen.id,
        arguments: {'id': id, 'number': number});
  }

  Future<void> savepref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', this.latitude);
    prefs.setDouble('longitude', this.longitude);
    prefs.setString('address', this.address);
  }

  Future<void> addToCart(
      String name,
      String sku,
      int count,
      double price,
      String Id,
      String url,
      String shopName,
      String sellerId,
      var distance) async {
    String docId = DateTime.now().millisecondsSinceEpoch.toString();
    await FirebaseFirestore.instance.collection('cart').doc(docId).set({
      'userId': _userServices.userId(),
      'cartId': docId,
      'prdId': Id,
      'PrdName': name,
      'sku': sku,
      'count': count,
      'price': price,
      'url': url,
      'shopName': shopName,
      'shopId': sellerId,
      'distance': distance
    });
  }

  Future<void> removeFromCart(String userId, String sku) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('cart')
        .where('userId', isEqualTo: userId)
        .where('sku', isEqualTo: sku)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = querySnapshot.docs.first;
      await FirebaseFirestore.instance.collection('cart').doc(doc.id).delete();
    }
  }

  Future<bool> isInCart(String userId, String sku) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('cart')
        .where('userId', isEqualTo: userId)
        .where('sku', isEqualTo: sku)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  String generateRandomId(int length) {
    const _chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(random.nextInt(_chars.length))));
  }

  Future<void> getDetails() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('id', isEqualTo: user?.uid)
          .get();

      addr = querySnapshot.docs.first['address'];
      Name = querySnapshot.docs.first['name'];
      no = querySnapshot.docs.first['number'];
    } catch (e) {
      print('Error retrieving specific field: $e');
    }
  }

  void placeOrder(BuildContext context, Map<String, dynamic> productData) {
    int quantity = 1;
    num totalPrice = quantity * productData['price'];
    num charge = (4 * productData['distance']).round();
    getDetails();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'Confirm Order',
                style: TextStyle(color: Colors.green),
              ),
              insetPadding: const EdgeInsets.all(50.0),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text("Prd Name "),
                      const SizedBox(width: 20),
                      Text(':  ${productData['productName']}'),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Order Id "),
                      const SizedBox(width: 35),
                      Text(":  ${generateRandomId(6)}"),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Sku "),
                      const SizedBox(width: 70),
                      Text(':  ${productData['sku']}'),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Quantity        : '),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                              totalPrice = quantity * productData['price'];
                            });
                          }
                        },
                      ),
                      Text('$quantity'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quantity++;
                            totalPrice = quantity * productData['price'];
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Delivery charge'),
                      const SizedBox(width: 20),
                      Text(": ${charge}")
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Total Price'),
                      const SizedBox(width: 20),
                      Text(": ${totalPrice + charge}")
                    ],
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (productData['stockQty'] != 0) {
                      orderPrd(
                          name: productData['productName'],
                          sku: productData['sku'],
                          count: quantity,
                          price: (totalPrice + charge).toDouble(),
                          cartId: productData['cartId'] ??
                              DateTime.now().millisecondsSinceEpoch.toString(),
                          prdId: productData['productId'],
                          url: productData['url'],
                          shopName: productData['shopName'],
                          shopId: productData['shopId'],
                          distance: productData['distance'].toString(),
                          location: GeoPoint(productData['latitude'],
                              productData['longitude']));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Product Not Available'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Navigator.of(context).pop();
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text(
                            'Your Order is Added Wait for vendor to Proceed'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    removeFromCart(_userServices.userId(), productData['sku']);
                    notifyListeners();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Place Order'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> orderPrd({
    required String name,
    required String sku,
    required int count,
    required double price,
    required String cartId,
    required String prdId,
    required String url,
    required String shopName,
    required String shopId,
    required String distance,
    required GeoPoint location,
  }) async {
    DateTime now = DateTime.now();
    String time =
        '${now.day}-${now.month}-${now.year} & ${now.hour}:${now.minute}';
    await FirebaseFirestore.instance.collection('order').doc(cartId).set({
      'userId': _userServices.userId(),
      'orderId': cartId,
      'prdId': prdId,
      "done": false,
      'PrdName': name,
      'sku': sku,
      'count': count,
      'price': price,
      'paymentId': "",
      'url': url,
      'shopName': shopName,
      'shopId': shopId,
      'distance': distance,
      'orderStatus': "",
      'ready': false,
      'ofd': false,
      'delivered': false,
      'payment': false,
      'r_name': '',
      'r_no': '',
      'location': location,
      'rider': false,
      'rating': 0.5,
      'address': addr,
      'Name': Name,
      'no': no,
      'Time': time,
    });
    notifyListeners();
  }
}
