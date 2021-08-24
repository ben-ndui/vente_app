import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:suividevente/model/my_event.dart';
import 'package:suividevente/model/product.dart';

class EventDatabaseService extends ChangeNotifier {
  var uid;
  final FirebaseFirestore _firebaseInstance = FirebaseFirestore.instance;

  /// Collection user
  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection("events");

  EventDatabaseService({this.uid});

  /// Permet de récupérer les donnée de n'importe quel collection de firebase
  Future getAllEventFromFirebase() async {
    QuerySnapshot snapshot = await _firebaseInstance.collection("events").get();

    return snapshot.docs;
  }

  /// Save user
  Future<void> saveEvent(
    DateTime? uid,
    String? title,
    String? description,
    DateTime? fromDate,
    DateTime? toDate,
    int? color,
    bool? isAllDay,
    bool? sun,
    bool? cloud,
    bool? tint,
    bool? pooStorm,
    bool? cloudSomething,
    double? panier,
  ) async {
    return await eventCollection.doc(title).set(
      {
        'title': title,
        'description': description,
        'from': fromDate,
        'to': toDate,
        'color': '$color',
        'isAllDay': isAllDay,
        'sun': sun,
        'cloud': cloud,
        'tint': tint,
        'pooStorm': pooStorm,
        'cloudSomething': cloudSomething,
        'panier': panier,
        'uid': fromDate,
        'searchKey': title!.substring(0, 1),
      },
    );
  }

  Future<void> updateEvent(
    DateTime? uid,
    String? title,
    String? description,
    DateTime? fromDate,
    DateTime? toDate,
    int? color,
    bool? isAllDay,
    bool? sun,
    bool? cloud,
    bool? tint,
    bool? pooStorm,
    bool? cloudSomething,
    double? panier,
  ) async {
    return await eventCollection.doc(title).update(
      {
        'title': title,
        'description': description,
        'from': fromDate,
        'to': toDate,
        'color': '$color',
        'isAllDay': isAllDay,
        'sun': sun,
        'cloud': cloud,
        'tint': tint,
        'pooStorm': pooStorm,
        'cloudSomething': cloudSomething,
        'panier': panier,
        'searchKey': title!.substring(0, 1),
      },
    );
  }

  Future<void> updateEventPanier(
    String? title,
    String? prodUid,
    String? prodTitle,
    String? prodPrice,
    String? prodImg,
  ) async {
    return await eventCollection
        .doc(title)
        .collection('panier')
        .doc(prodUid)
        .set(
      {
        'prodUid': prodUid,
        'prodTitle': prodTitle,
        'prodPrice': prodPrice,
        'prodImg': prodImg,
        'searchKey': prodTitle!.substring(0, 1),
      },
    );
  }

  MyEvent _eventsFromSnapShot(DocumentSnapshot snapshot) {
    final userData = (snapshot.data() as dynamic);
    return MyEvent(
      userData['uid'],
      userData['title'],
      userData['color'],
      userData['description'],
      userData['from'],
      userData['to'],
      userData['isAllDay'],
      userData['sun'],
      userData['cloud'],
      userData['tint'],
      userData['pooStorm'],
      userData['cloudSomething'],
      userData['panier'],
    );
  }

  Product _productFromSnapShot(DocumentSnapshot snapshot) {
    final userData = (snapshot.data() as dynamic);
    return Product(
      uid: userData['prodUid'],
      title: userData['prodTitle'],
      price: userData['prodPrice'],
      img: userData['prodImg'],
    );
  }

  /// Stream to get current user
  Stream<MyEvent> get anEvent {
    return eventCollection.doc(uid).snapshots().map(_eventsFromSnapShot);
  }

  /// Stream list to get all users
  Stream<List<MyEvent>> get allEvents {
    return eventCollection.snapshots().map(_eventListFromSnapShot);
  }

  /// Stream list to get all users
  Stream<List<Product>> get allPanier {
    return eventCollection.doc(uid).collection("panier").snapshots().map(_productListFromSnapShot);
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

  List<MyEvent> _eventListFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => _eventsFromSnapShot(doc)).toList();
  }

  List<Product> _productListFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => _productFromSnapShot(doc)).toList();
  }
}
