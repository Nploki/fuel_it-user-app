import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fuel_it/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fuel_it/provider/location_provider.dart';
import 'package:fuel_it/provider/auth_provider.dart' as AuthProvider;

class MapScreen extends StatefulWidget {
  static const id = 'mapscreen';

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng currentLocation = const LatLng(9.9252, 78.1198);
  late GoogleMapController _mapController;
  bool loggedIn = false;
  late User user;

  Future<void> _initCurrentLocation() async {
    final locationData = Provider.of<LocationProvider>(context, listen: false);
    try {
      final Position position = await locationData.getCurrentPosition();
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error obtaining current location: $e');
    }
  }

  void onCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
      _initCurrentLocation();
    });
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        loggedIn = true;
        user = FirebaseAuth.instance.currentUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String userId = args['id'];
    final String userNumber = args['number'];
    final locationData = Provider.of<LocationProvider>(context);
    final auth = Provider.of<AuthProvider.AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, MainScreen.id);
            },
            icon: const Icon(CupertinoIcons.back)),
        title: const Text('SET DELIVERY ADDRESS'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.60,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: currentLocation,
                  zoom: 14.0,
                ),
                zoomControlsEnabled: true,
                minMaxZoomPreference: const MinMaxZoomPreference(1.5, 25),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                mapToolbarEnabled: true,
                markers: {
                  Marker(
                    markerId: const MarkerId('currentLocation'),
                    position: currentLocation,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue),
                  ),
                },
                onCameraMove: (CameraPosition position) {
                  locationData.onCameraMove(position);
                },
                onMapCreated: onCreated,
                onCameraIdle: () {
                  locationData.getMoveCamera();
                },
              ),
            ),
            const Center(
              child: Icon(
                Icons.person_pin,
                color: Color.fromARGB(255, 49, 36, 227),
              ),
            ),
            const Center(
              child: SpinKitRipple(
                color: Colors.blue,
                size: 100,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.60,
              left: MediaQuery.of(context).size.width * 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.30,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(210, 144, 237, 245),
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(66, 159, 200, 221),
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 2,
                      width: MediaQuery.of(context).size.width,
                      child: const LinearProgressIndicator(
                        backgroundColor: Colors.white,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(
                      height: 7.5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 100,
                        ),
                        const Icon(
                          Icons.house_outlined,
                          size: 40,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Location",
                          style: GoogleFonts.chakraPetch(
                            fontSize: 30,
                            color: const Color.fromARGB(255, 119, 4, 148),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 300,
                      child: Text(
                        '${locationData.selectedAddress ?? "Loading..."}',
                        style: const TextStyle(
                          fontSize: 17.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 230, 0)),
                        onPressed: () async {
                          auth.latitude = locationData.latitude;
                          auth.longitude = locationData.longitude;
                          auth.address = locationData.selectedAddress!;
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId)
                              .update({
                            'number': userNumber,
                            'Latitude': locationData.latitude,
                            'Longitude': locationData.longitude,
                            'location': GeoPoint(
                                locationData.latitude, locationData.longitude),
                            'address': locationData.selectedAddress,
                          });
                          auth.savepref();
                          Navigator.pop(context); // Pop the current route
                          Navigator.pushNamed(context,
                              MainScreen.id); // Push the HomeScreen route
                        },
                        child: const Text(
                          "Confirm Address",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
