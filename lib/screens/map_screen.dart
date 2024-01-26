// map_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fuel_it/provider/location_provider.dart';

class MapScreen extends StatefulWidget {
  static String id = 'map-screen';

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng currentLocation;
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    currentLocation = LatLng(0.0, 0.0);
    _initCurrentLocation();
  }

  Future<void> _initCurrentLocation() async {
    final locationData = Provider.of<LocationProvider>(context, listen: false);
    await locationData.getCurrentPosition();
    setState(() {
      currentLocation = LatLng(locationData.latitude, locationData.longitude);
    });
  }

  void onCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Map Screen'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Text('${locationData.latitude} : ${locationData.latitude}'),
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentLocation,
                zoom: 14.0,
              ),
              //   zoomControlsEnabled: true,
              //   minMaxZoomPreference: MinMaxZoomPreference(1.5, 25),
              //   myLocationEnabled: true,
              //   myLocationButtonEnabled: true,
              //   mapType: MapType.normal,
              //   mapToolbarEnabled: true,
              //   onCameraMove: (CameraPosition position) {
              //     locationData.onCameraMove(position);
              //   },
              //   onMapCreated: onCreated,
              //   onCameraIdle: () {
              //     locationData.getMoveCamera();
              //   },
            ),
            // Positioned(
            //   top: 16.0,
            //   left: 16.0,
            //   child: Container(
            //     padding: EdgeInsets.all(8.0),
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(8.0),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.black26,
            //           offset: Offset(0, 2),
            //           blurRadius: 6.0,
            //         ),
            //       ],
            //     ),
            //     child: Text(
            //       'Location: ${locationData.selectedAddress?.addressLine ?? "Loading..."}',
            //       style: TextStyle(
            //         fontSize: 16.0,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
