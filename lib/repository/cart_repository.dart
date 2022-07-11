import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartRepository {
  final _db = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> loadCartOfTheUser(String id) {
    return _db.collection('cart').doc(id).snapshots();
  }
}
