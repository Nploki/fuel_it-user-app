// import 'dart:math';

// import 'package:flutter/cupertino.dart';
// import 'package:geolocator/geolocator.dart';

// class LocationProvider with ChangeNotifier {
//   late double latitude;
//   late double longitude;
//   bool permissionAllowed = false;

//   Future<void> getCurrentPosition() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     if (position != null) {
//       this.latitude = position.latitude;
//       this.longitude = position.longitude;
//       this.permissionAllowed = true;
//       notifyListeners();
//     } else {
//       print("Could not fetch location");
//     }
//   }
// }
