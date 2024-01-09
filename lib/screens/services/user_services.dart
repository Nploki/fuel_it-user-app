import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fuel_it/models/user_model.dart';

class UserServices {
  String collection = 'users';
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // create a new user
  Future<void> createUserData(Map<String, dynamic> values) async {
    String id = values['id'];
    await _firestore.collection(collection).doc(id).set(values);
  }

  // update user data
  Future<void> updateUserData(Map<String, dynamic> values) async {
    String id = values['id'];
    await _firestore.collection(collection).doc(id).set(values);
  }

  // get user data by user id
  Future<UserModel?> getUserById(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(collection).doc(id).get();

      if (doc.exists) {
        return UserModel.fromSnapshot(doc);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }
}
