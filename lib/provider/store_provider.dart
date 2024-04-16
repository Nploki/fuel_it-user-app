import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fuel_it/services/store_services.dart';
import 'package:fuel_it/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class storeProvider with ChangeNotifier {
  StoreServices _storeService = StoreServices();
  UserServices _userServices = UserServices();
  User user = FirebaseAuth.instance.currentUser!;
  var userLatitude = 0.0;
  var userLongitude = 0.0;
  String storeDistance = '';
  String selectedStore = "";
  String selectedStoreId = "";

  getSelectedStore(storeName, storeId, distance) {
    this.selectedStore = storeName;
    this.selectedStoreId = storeId;
    this.storeDistance = distance;
    notifyListeners();
  }

  GeoPoint getAddr() {
    return GeoPoint(this.userLatitude, this.userLongitude);
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  num getDistance(location) {
    var distance = Geolocator.distanceBetween(
        userLatitude, userLongitude, location.latitude, location.longitude);
    var distanceInKm = distance / 1000;
    return distanceInKm;
  }

  Future<void> getUserLocationData() async {
    if (user != null) {
      _userServices.getUserById(user!.uid).then((result) {
        if (result != null) {
          Map<String, dynamic> userData = result.data() as Map<String, dynamic>;
          this.userLatitude = userData['Latitude'];
          this.userLongitude = userData['Longitude'];
        }
      });
    }
  }
}
