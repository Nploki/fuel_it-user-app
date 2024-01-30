import 'package:flutter/material.dart';
import 'package:fuel_it/services/store_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fuel_it/services/user_services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';

class TopPickStore extends StatefulWidget {
  const TopPickStore({Key? key}) : super(key: key);

  @override
  State<TopPickStore> createState() => _TopPickStoreState();
}

class _TopPickStoreState extends State<TopPickStore> {
  StoreServices _storeServices = StoreServices();
  UserServices _userServices = UserServices();
  User? user = FirebaseAuth.instance.currentUser;
  var _userLatitude = 0.0;
  var _userLongitude = 0.0;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      _userServices.getUserById(user!.uid).then((result) {
        if (result != null) {
          setState(() {
            Map<String, dynamic> userData =
                result.data() as Map<String, dynamic>;
            _userLatitude = userData['Latitude'];
            _userLongitude = userData['Longitude'];
          });
        }
      });
    }
  }

  String getDistance(location) {
    var distance = Geolocator.distanceBetween(
        _userLatitude, _userLongitude, location.latitude, location.longitude);
    var distanceInKm = distance / 1000;
    return distanceInKm.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _storeServices.getTopPickedStore(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<DocumentSnapshot> sortedDocs = snapshot.data!.docs.toList();
          sortedDocs.sort((a, b) {
            var distanceA = Geolocator.distanceBetween(
                _userLatitude,
                _userLongitude,
                a['location'].latitude,
                a['location'].longitude);
            var distanceB = Geolocator.distanceBetween(
                _userLatitude,
                _userLongitude,
                b['location'].latitude,
                b['location'].longitude);
            return distanceA.compareTo(distanceB);
          });

          //     if (!snapshot.hasData) {
          //   return const Center(child: CircularProgressIndicator());
          // }
          // List shopDistance = [];
          // for (var i = 0; i <= snapshot.data!.docs.length - 1; i++) {
          //   var distance = Geolocator.distanceBetween(
          //       _userLatitude,
          //       _userLongitude,
          //       snapshot.data?.docs[i]['location'].latitude,
          //       snapshot.data?.docs[i]['location'].longitude);
          //   var distanceInKm = distance / 1000;
          //   shopDistance.add(distanceInKm);
          // }
          // shopDistance.sort(); //sort by distance

          // if (shopDistance[0] > 18) {
          //   return Container(
          //     child: const SpinKitPouringHourGlassRefined(
          //       size: 50,
          //       color: Colors.red,
          //     ),
          //   );
          // }
          if (sortedDocs.isEmpty ||
              double.parse(getDistance(sortedDocs.first['location'])) > 18) {
            return Container(
              child: const SpinKitPouringHourGlassRefined(
                size: 50,
                color: Colors.red,
              ),
            );
          }

          return Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.near_me_rounded,
                    color: Color.fromARGB(255, 160, 3, 160),
                    size: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Top Picked !",
                    style: GoogleFonts.cookie(
                        color: Color.fromARGB(255, 18, 0, 211),
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Flexible(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: sortedDocs.map((DocumentSnapshot document) {
                    if (double.parse(getDistance(document['location'])) <= 18) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          color: Colors.orangeAccent.shade200,
                          width: 100,
                          child: Column(children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: Card(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25.0),
                                  child: Image.network(
                                    document['url'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                document['shopName'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '${getDistance(document['location'])} Km',
                              style: TextStyle(color: Colors.grey),
                            )
                          ]),
                        ),
                      );
                    } else {
                      return SizedBox();
                    }
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
