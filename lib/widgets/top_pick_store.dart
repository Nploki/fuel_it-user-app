import 'package:flutter/material.dart';
import 'package:fuel_it/services/store_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fuel_it/provider/store_provider.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class TopPickStore extends StatefulWidget {
  const TopPickStore({Key? key}) : super(key: key);

  @override
  State<TopPickStore> createState() => _TopPickStoreState();
}

class _TopPickStoreState extends State<TopPickStore> {
  StoreServices _storeServices = StoreServices();

  @override
  Widget build(BuildContext context) {
    final _storeData = Provider.of<storeProvider>(context);
    // _storeData.getUserLocationData(context);
    _storeData.getUserLocationData();

    String getDistance(location) {
      var distance = Geolocator.distanceBetween(_storeData.userLatitude,
          _storeData.userLongitude, location.latitude, location.longitude);
      var distanceInKm = distance / 1000;
      return distanceInKm.toStringAsFixed(2);
    }

    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _storeServices.getTopPickedStore(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          List shopDistance = [];
          for (var i = 0; i <= snapshot.data!.docs.length - 1; i++) {
            var distance = Geolocator.distanceBetween(
                _storeData.userLatitude,
                _storeData.userLongitude,
                snapshot.data?.docs[i]['location'].latitude,
                snapshot.data?.docs[i]['location'].longitude);
            var distanceInKm = distance / 1000;
            shopDistance.add(distanceInKm);
          }
          shopDistance.sort(); //sort by distance

          if (shopDistance[0] > 17) {
            return Container(
              child: const SpinKitPouringHourGlassRefined(
                size: 50,
                color: Colors.red,
              ),
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5, top: 0),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.near_me_outlined,
                      color: Color.fromARGB(255, 160, 3, 160),
                      size: 30,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Top Picked !",
                      style: GoogleFonts.cookie(
                          color: Color.fromARGB(255, 255, 0, 0),
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Flexible(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    if (double.parse(getDistance(document['location'])) <=
                        18) // show bunk with in 18 km
                    {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          width: 100,
                          // height: 300,
                          child: Column(children: [
                            SizedBox(
                              width: 90,
                              height: 90,
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
                                maxLines: 1,
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
                      return SizedBox(); // Widget returned when condition is not met
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
