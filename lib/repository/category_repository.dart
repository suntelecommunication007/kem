import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryRepository {
  final db = FirebaseFirestore.instance;
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategory() {
    return db.collection('category').orderBy('category').snapshots();
  }
}
