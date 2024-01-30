import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class locate_bunk extends StatefulWidget {
  static String id = 'locate_bunk';
  @override
  _locate_bunkState createState() => _locate_bunkState();
}

class _locate_bunkState extends State<locate_bunk> {
  GoogleMapController? _controller;
  LatLng? _userPosition;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initializeUserPosition();
    _getSellersLocations();
  }

  void _initializeUserPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _userPosition = LatLng(position.latitude, position.longitude);
    });
  }

  void _getSellersLocations() async {
    QuerySnapshot sellersSnapshot =
        await FirebaseFirestore.instance.collection('seller').get();
    setState(() {
      _markers.addAll(sellersSnapshot.docs.map((DocumentSnapshot document) {
        GeoPoint sellerLocation = document['location'];
        LatLng latLng =
            LatLng(sellerLocation.latitude, sellerLocation.longitude);
        return Marker(
          markerId: MarkerId(document.id),
          position: latLng,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: document['shopName']),
        );
      }).toSet());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map with User and Sellers'),
      ),
      body: _userPosition != null
          ? GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              initialCameraPosition: CameraPosition(
                target: _userPosition!,
                zoom: 12,
              ),
              markers: _markers.union({
                Marker(
                  markerId: MarkerId('userLocation'),
                  position: _userPosition!,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure), // Custom icon for user
                  infoWindow: InfoWindow(title: 'Your Location'),
                ),
              }),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
