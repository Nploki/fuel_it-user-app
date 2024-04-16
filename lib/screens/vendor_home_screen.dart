import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fuel_it/provider/store_provider.dart';
import 'package:fuel_it/widgets/storeDetails.dart';
import 'package:fuel_it/widgets/vendor_appbar.dart';
import 'package:fuel_it/widgets/vendor_products.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class vendorHomeScreen extends StatefulWidget {
  static const String id = "vendor-screen";
  const vendorHomeScreen({Key? key}) : super(key: key);

  @override
  State<vendorHomeScreen> createState() => _vendorHomeScreenState();
}

class _vendorHomeScreenState extends State<vendorHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final _storeData = Provider.of<storeProvider>(context);

    return Scaffold(
      appBar: vendor_appbar(storeData: _storeData),
      body: StreamBuilder<DocumentSnapshot>(
        stream: getStore(_storeData.selectedStoreId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            Map<String, dynamic> storeDetail =
                (snapshot.data!.data() as Map<String, dynamic>?) ?? {};
            num distanceInKm = _storeData.getDistance(storeDetail['location']);
            return Column(
              children: [
                StoreDetailWidget(storeDetail: storeDetail),
                // vendor_slider(vendorId: storeDetail['uid']),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                      width: double.infinity,
                      height: 400,
                      child: vendor_products(
                          sellerId: storeDetail['uid'], dist: distanceInKm)),
                )
              ],
            );
          }
        },
      ),
    );
  }

  Stream<DocumentSnapshot> getStore(String uid) {
    return FirebaseFirestore.instance.collection('seller').doc(uid).snapshots();
  }
}
