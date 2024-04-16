import 'package:cloud_firestore/cloud_firestore.dart';

class StoreServices {
  getTopPickedStore() {
    return FirebaseFirestore.instance.collection('seller').snapshots();
  }

  getPrice() {
    return FirebaseFirestore.instance.collection('price').snapshots();
  }
}
