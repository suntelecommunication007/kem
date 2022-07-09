import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kem/model/product.dart';

class ProductsReposiotry {
  final db = FirebaseFirestore.instance;
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts(int limit) {
    return db.collection('products').orderBy('name').limit(limit).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMoreAllProducts(
      DocumentSnapshot product, int limit) {
    return db
        .collection('products')
        .orderBy('name')
        .startAfterDocument(product)
        .limit(limit)
        .snapshots();
  }

  Future<DocumentSnapshot<Object?>> getProductDocumentSnapshot(
      Product product) async {
    return await db.collection('products').doc(product.id).get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMoreProductsByCategory(
      {required String category,
      DocumentSnapshot? product,
      required int limit}) {
    if (product != null) {
      return db
          .collection('products')
          .where('category', isEqualTo: category)
          .orderBy('name')
          .startAfterDocument(product)
          .limit(limit)
          .snapshots();
    } else {
      return db
          .collection('products')
          .where('category', isEqualTo: category)
          .orderBy('name')
          .limit(limit)
          .snapshots();
    }
  }
}
