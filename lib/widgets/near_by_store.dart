import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fuel_it/screens/map_screen.dart';
import 'package:fuel_it/screens/vendor_home_screen.dart';
import 'package:fuel_it/services/store_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fuel_it/provider/store_provider.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class NearByStore extends StatefulWidget {
  const NearByStore({Key? key}) : super(key: key);

  @override
  State<NearByStore> createState() => _NearByStoreState();
}

void _showPriceBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('price').doc('price').get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }

          var data = snapshot.data!.data()! as Map<String, dynamic>;

          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Price Indicator',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.chakraPetch(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                _buildPriceRow(
                  'Petrol',
                  'https://uxwing.com/wp-content/themes/uxwing/download/transportation-automotive/bike-motorcycle-icon.png',
                  data['petrol'], // Access nested field
                ),
                const SizedBox(height: 8.0),
                _buildPriceRow(
                  'Diesel',
                  'https://static.vecteezy.com/system/resources/previews/013/923/543/non_2x/blue-car-logo-png.png',
                  data['diesel'], // Access 'diesel' field
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildPriceRow(
  String itemName,
  String imagePath,
  String price,
) {
  return Container(
    height: 100,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            Image.network(
              imagePath,
              width: 90,
              height: 100,
            ),
            const SizedBox(width: 75.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  itemName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  '\Rs. $price (Per Liter)',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

Stream<QuerySnapshot> getPrice() {
  return FirebaseFirestore.instance.collection('price').snapshots();
}

class _NearByStoreState extends State<NearByStore> {
  StoreServices _storeServices = StoreServices();

  double latitude = 0.0;
  double longitude = 0.0;
  @override
  void didChangeDependencies() {
    final _storeData = Provider.of<storeProvider>(context);
    _storeData.determinePosition().then((position) {
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _storeData = Provider.of<storeProvider>(context);
    _storeData.getUserLocationData();

    String getDistance(location) {
      var distance = Geolocator.distanceBetween(
          latitude, longitude, location.latitude, location.longitude);
      var distanceInKm = distance / 1000;
      return distanceInKm.toStringAsFixed(2);
    }

    final auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _storeServices.getTopPickedStore(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Filter stores within 25 km
          var filteredDocs = snapshot.data!.docs.where((doc) {
            var distance = getDistance(doc['location']);
            return double.parse(distance) <= 25;
          }).toList();

          // Sort stores in ascending order based on distance
          filteredDocs.sort((a, b) {
            var distanceA = double.parse(getDistance(a['location']));
            var distanceB = double.parse(getDistance(b['location']));
            return distanceA.compareTo(distanceB);
          });

          if (filteredDocs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://cdn-icons-png.flaticon.com/512/8607/8607628.png',
                    width: 150,
                    height: 150,
                  ),
                  const Text(
                    'Sorry ! No nearby store was found.\nPlease try again later.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (user != null) {
                          Navigator.pushReplacementNamed(context, MapScreen.id,
                              arguments: {
                                'id': user.uid,
                                'number': user.phoneNumber
                              });
                        }
                      },
                      child: Text(
                        "Set Location ...",
                        style: GoogleFonts.tenorSans(fontSize: 25),
                      ))
                ],
              ),
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.store_outlined,
                          color: Color.fromARGB(255, 160, 3, 160),
                          size: 35,
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Near By Bunks !",
                            style: GoogleFonts.cookie(
                              color: const Color.fromARGB(255, 1, 99, 103),
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          _showPriceBottomSheet(context);
                        },
                        icon: Icon(
                          Icons.currency_rupee_outlined,
                          color: Colors.amber.shade900,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Builder(builder: (context) {
                return Flexible(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: filteredDocs.map((DocumentSnapshot document) {
                      var distance = getDistance(document['location']);

                      return InkWell(
                        onTap: () {
                          _storeData.getSelectedStore(
                              document['shopName'], document['uid'], distance);
                          Navigator.pushReplacementNamed(
                            context,
                            vendorHomeScreen.id,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            width: 100,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          document['shopName'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          document['address'],
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '$distance Km',
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                        RatingBarIndicator(
                                          rating: (document['rating'] ?? 0)
                                              .toDouble(),
                                          itemBuilder: (_, index) => const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 5,
                                          itemSize: 20,
                                          direction: Axis.horizontal,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
