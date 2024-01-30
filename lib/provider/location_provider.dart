import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  double latitude = 0.0;
  double longitude = 0.0;
  String? selectedAddress;
  bool permissionAllowed = false;
  bool locating = false;

  Future<Position> getCurrentPosition() async {
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
    permissionAllowed = true;
    return await Geolocator.getCurrentPosition();
  }

  void onCameraMove(CameraPosition cameraPosition) {
    this.latitude = cameraPosition.target.latitude;
    this.longitude = cameraPosition.target.longitude;
    notifyListeners();
  }

  Future<void> getMoveCamera() async {
    final List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    final Placemark place = placemarks.first;
    selectedAddress =
        "${place.name}, ${place.locality} \n${place.administrativeArea} ${place.postalCode}, ${place.country}";
    //  ${place.thoroughfare}, ${place.subLocality}
    print(selectedAddress);
  }
}
