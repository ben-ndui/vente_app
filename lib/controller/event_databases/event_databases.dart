import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:suividevente/model/product.dart';

class EventDatabaseService {
  String uid;
  final FirebaseFirestore _firebaseInstance = FirebaseFirestore.instance;

  /// Collection user
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("events");

  EventDatabaseService({
    required this.uid,
  });

  /// Permet de récupérer les donnée de n'importe quel collection de firebase
  Future getAllProductsFromFirebase() async {
    QuerySnapshot snapshot = await _firebaseInstance.collection("events").get();

    return snapshot.docs;
  }

  /// Save user
  Future<void> saveEvent(
    String? title,
    String? description,
    DateTime? fromDate,
    DateTime? toDate,
    Color? color,
    bool? isAllDay,
    bool? sun,
    bool? cloud,
    bool? tint,
    bool? pooStorm,
    bool? cloudSomething,
  ) async {
    return await userCollection.doc(uid).set(
      {
        'title': title,
        'description': description,
        'from': fromDate,
        'to': toDate,
        'color': color,
        'isAllDay': isAllDay,
        'sun': sun,
        'cloud': cloud,
        'tint': tint,
        'pooStorm': pooStorm,
        'cloudSomething': cloudSomething,
        'searchKey': title!.substring(0, 1),
      },
    );
  }

  Future<void> updateProductInfo(
      String? uid, String? title, String? price, String? img) async {
    return await userCollection.doc(uid).update(
      {
        'uid': uid,
        'title': title,
        'price': price,
        'img': img,
        'searchKey': title!.substring(0, 1),
      },
    );
  }

  Product _userFromSnapShot(DocumentSnapshot snapshot) {
    final userData = (snapshot.data() as dynamic);
    return Product(
      uid: userData["uid"],
      title: userData["title"],
      price: userData["price"],
      img: userData["img"],
    );
  }

  /// Stream to get current user
  Stream<Product> get user {
    return userCollection.doc(uid).snapshots().map(_userFromSnapShot);
  }

  /// Stream list to get all users
  Stream<List<Product>> get allUser {
    return userCollection.snapshots().map(_userListFromSnapShot);
  }

  searchByName(searchField) {
    return _firebaseInstance
        .collection('users')
        .where('searchKey',
            isEqualTo: searchField.substring(0, 1).toUpperCase())
        .get();
  }

  searchByUserName(searchField) {
    return _firebaseInstance
        .collection('users')
        .where('searchKey',
            isEqualTo: searchField.substring(0, 1).toUpperCase())
        .get();
  }

  List<Product> _userListFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => _userFromSnapShot(doc)).toList();
  }
}
