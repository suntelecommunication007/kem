import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kem/model/product.dart';

class ProductsReposiotry {
  final db = FirebaseFirestore.instance;
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() {
    return db.collection('products').limit(15).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMoreAllProducts(
      DocumentSnapshot product) {
    return db
        .collection('products')
        .startAfterDocument(product)
        .limit(15)
        .snapshots();
  }

  Future<DocumentSnapshot<Object?>> getProductDocumentSnapshot(
      Product product) async {
    return await db.collection('products').doc(product.id).get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getProductsByCategory(
      String category) {
    return db
        .collection('products')
        .where('category', isEqualTo: category)
        .limit(15)
        .snapshots();
  }

  getMoreProductsByCategory(String category, DocumentSnapshot product) async {
    return db
        .collection('products')
        .where('category', isEqualTo: category)
        .startAfterDocument(product)
        .limit(15)
        .snapshots();
  }
}
