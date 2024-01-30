import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreServices {
  getTopPickedStore() {
    return FirebaseFirestore.instance
        .collection('seller')
        .where('accVerified', isEqualTo: true) //verified seller
        .where('isTopPicked', isEqualTo: true) //top seller
        // .orderBy('shopName')
        .snapshots(); //sort by bunk name
  }
}
