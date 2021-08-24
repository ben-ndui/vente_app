import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:suividevente/model/event_provider.dart';
import 'package:suividevente/model/my_event.dart';

class EventProviderData extends ChangeNotifier {
  var uid;
  final FirebaseFirestore _firebaseInstance = FirebaseFirestore.instance;

  /// Collection user
  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection("events");

  EventProviderData({this.uid});

  /// Permet de récupérer les donnée de n'importe quel collection de firebase
  Future getAllEventFromFirebase() async {
    QuerySnapshot snapshot = await _firebaseInstance.collection("events").get();

    return snapshot.docs;
  }

  /// Save user
  Future<void> saveEvent(String title, events) async {
    return await eventCollection.doc(title).set(
      {
        'events': events,
        'searchKey': title.substring(0, 1),
      },
    );
  }

  Future<void> updateEvent(String title, events) async {
    return await eventCollection.doc(title).update(
      {
        'events': events,
        'searchKey': title.substring(0, 1),
      },
    );
  }

  EventProvider _eventsFromSnapShot(DocumentSnapshot snapshot) {
    final userData = (snapshot.data() as dynamic);
    return EventProvider();
  }

  /// Stream to get current user
  Stream<EventProvider> get anEvent {
    return eventCollection.doc(uid).snapshots().map(_eventsFromSnapShot);
  }

  /// Stream list to get all users
  Stream<List<EventProvider>> get allEventsByDay {
    return eventCollection.snapshots().map(_eventListFromSnapShot);
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

  List<EventProvider> _eventListFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => _eventsFromSnapShot(doc)).toList();
  }
}
