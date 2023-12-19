import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeDataFirestore {
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users_db')
        .doc(id)
        .set(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getProduct(String category) async {
    return FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: category)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getAllProducts() async {
    return FirebaseFirestore.instance.collection('products').snapshots();
  }

  Future<Stream<QuerySnapshot>> getCartItems(User? user) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users_db')
        .where('email', isEqualTo: user!.email)
        .get();
    if (snapshot.docs.isNotEmpty) {
      String ref = snapshot.docs.first.reference.id;
      return await FirebaseFirestore.instance
          .collection('users_db')
          .doc(ref)
          .collection('cart')
          .snapshots();
    } else {
      return const Stream.empty();
    }
  }
}
