import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:suividevente/model/chiffres_by_month.dart';
import 'package:suividevente/model/my_event.dart';
import 'package:suividevente/model/product.dart';
import 'package:suividevente/utils/constants.dart';
import 'package:suividevente/utils/theme.dart';

class EventDatabaseService extends ChangeNotifier {
  var eventUid;
  var month;
  var year;
  var date;
  final FirebaseFirestore _firebaseInstance = FirebaseFirestore.instance;

  /// Collection user
  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection("events");

  final CollectionReference chiffresCollection =
      FirebaseFirestore.instance.collection("chiffres");

  EventDatabaseService({this.eventUid, this.month, this.year, this.date});

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
    int month,
    bool? isActive,
  ) async {
    return await eventCollection
        .doc('$month - ${fromDate!.year}')
        .collection("all")
        .doc(title! +
            ' - ${fromDate.day} - ${fromDate.month} - ${fromDate.year}')
        .set(
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
        'month': month,
        'isActive': isActive,
        'searchKey': title.substring(0, 1),
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
    int? month,
    bool isActive,
  ) async {
    switch (title) {
      case "Marché du matin":
        await eventCollection
            .doc('$month - ${fromDate!.year}')
            .collection("all")
            .doc(title! +
                ' - ${fromDate.day} - ${fromDate.month} - ${fromDate.year}')
            .update(
          {
            'title': title,
            'description': description,
            'from': fromDate,
            'to': toDate,
            'color': '${kYellowColor.value}',
            'isAllDay': isAllDay,
            'sun': sun,
            'cloud': cloud,
            'tint': tint,
            'pooStorm': pooStorm,
            'cloudSomething': cloudSomething,
            'panier': panier,
            'month': month,
            'isActive': isActive,
            'searchKey': title.substring(0, 1),
          },
        );
        break;
      case "Marché du soir":
        await eventCollection
            .doc('$month - ${fromDate!.year}')
            .collection("all")
            .doc(title! +
                ' - ${fromDate.day} - ${fromDate.month} - ${fromDate.year}')
            .update(
          {
            'title': title,
            'description': description,
            'from': fromDate,
            'to': toDate,
            'color': '${kBlueColor.value}',
            'isAllDay': isAllDay,
            'sun': sun,
            'cloud': cloud,
            'tint': tint,
            'pooStorm': pooStorm,
            'cloudSomething': cloudSomething,
            'panier': panier,
            'month': month,
            'isActive': isActive,
            'searchKey': title.substring(0, 1),
          },
        );
        break;
    }
  }

  Future<void> updateEventMeteo(
    bool? cloud,
    String title,
    int month,
    DateTime? fromDate,
  ) async {
    return await eventCollection
        .doc('$month - ${fromDate!.year}')
        .collection("all")
        .doc(eventUid +
            ' - ${fromDate.day} - ${fromDate.month} - ${fromDate.year}')
        .update(
      {
        title: cloud,
      },
    );
  }

  Future<void> updateEventTotalPanier(
    double? total,
    String title,
    int month,
    DateTime? fromDate,
  ) async {
    return await eventCollection
        .doc('$month - ${fromDate!.year}')
        .collection("all")
        .doc(eventUid +
            ' - ${fromDate.day} - ${fromDate.month} - ${fromDate.year}')
        .update(
      {
        title: total,
      },
    );
  }

  Future<void> dontShow(
    bool? cloud,
    String title,
    int month,
    DateTime? fromDate,
  ) async {
    return await eventCollection
        .doc('$month - ${fromDate!.year}')
        .collection("all")
        .doc(eventUid +
            ' - ${fromDate.day} - ${fromDate.month} - ${fromDate.year}')
        .update(
      {
        title: cloud,
      },
    );
  }

  Future<void> addEventToCart(
    String? title,
    String? prodUid,
    String? prodTitle,
    String? prodPrice,
    String? prodImg,
    int? prodNb,
    int? month,
    DateTime? day,
      bool? isHidden,
  ) async {
    if (prodNb == 0) {
      return await eventCollection
          .doc('$month - ${day!.year}')
          .collection("all")
          .doc(title! + ' - ${day.day} - ${day.month} - ${day.year}')
          .collection('panier')
          .doc(prodUid)
          .delete();
    } else {
      return await eventCollection
          .doc('$month - ${day!.year}')
          .collection("all")
          .doc(title! + ' - ${day.day} - ${day.month} - ${day.year}')
          .collection('panier')
          .doc(prodUid)
          .set(
        {
          'prodUid': prodUid,
          'prodTitle': prodTitle,
          'prodPrice': prodPrice,
          'prodImg': prodImg,
          'prodNb': prodNb,
          'isHidden': isHidden,
          'searchKey': prodTitle!.substring(0, 1),
        },
      );
    }
  }

  Future<void> updateAddEventToCart(
    String? title,
    String? prodUid,
    String? prodTitle,
    String? prodPrice,
    String? prodImg,
    int? prodNb,
    int? month,
    DateTime? day,
      bool? isHidden,
  ) async {
    if (prodNb == 0) {
      return await eventCollection
          .doc('$month - ${day!.year}')
          .collection("all")
          .doc(title! + ' - ${day.day} - ${day.month} - ${day.year}')
          .collection('panier')
          .doc(prodUid)
          .delete();
    } else {
      return await eventCollection
          .doc('$month - ${day!.year}')
          .collection("all")
          .doc(title! + ' - ${day.day} - ${day.month} - ${day.year}')
          .collection('panier')
          .doc(prodUid)
          .update(
        {
          'prodUid': prodUid,
          'prodTitle': prodTitle,
          'prodPrice': prodPrice,
          'prodImg': prodImg,
          'prodNb': prodNb,
          'isHidden': isHidden,
          'searchKey': prodTitle!.substring(0, 1),
        },
      );
    }
  }

  Future<void> saveChiffres(
    String? title,
    int? cfMonth,
    double? chiffres,
    DateTime? day,
  ) async {
    return await chiffresCollection
        .doc("$year").collection("all").doc('$month - $title')
        .set(
      {
        'title': title,
        'cfMonth': cfMonth,
        'chiffres': chiffres,
      },
    );
  }

  Future<void> updateChiffres(
    String? title,
    int? cfMonth,
    double? chiffres,
    DateTime? day,
  ) async {
    return await chiffresCollection
        .doc("$year").collection("all").doc('$cfMonth - $title')
        .update(
      {
        'title': title,
        'cfMonth': cfMonth,
        'chiffres': chiffres,
      },
    );
  }

  Future<void> updateEventPanier(
    String? title,
    String? prodUid,
    String? prodTitle,
    String? prodPrice,
    String? prodImg,
    int? prodNb,
    int? month,
    DateTime? day,
      bool? isHidden,
  ) async {
    return await eventCollection
        .doc('$month - ${day!.year}')
        .collection("all")
        .doc(title! + ' - ${day.day} - ${day.month} - ${day.year}')
        .collection('panier')
        .doc(prodUid)
        .set(
      {
        'prodUid': prodUid,
        'prodTitle': prodTitle,
        'prodPrice': prodPrice,
        'prodImg': prodImg,
        'prodNb': prodNb,
        'isHidden': isHidden,
        'searchKey': prodTitle!.substring(0, 1),
      },
    );
  }

  MyEvent _eventsFromSnapShot(DocumentSnapshot snapshot) {
    final userData = (snapshot.data() as dynamic);
    return MyEvent(
      userData['uid'].toDate(),
      userData['title'],
      Color(int.parse(userData['color'])),
      userData['description'],
      userData['from'].toDate(),
      userData['to'].toDate(),
      userData['isAllDay'],
      userData['sun'],
      userData['cloud'],
      userData['tint'],
      userData['pooStorm'],
      userData['cloudSomething'],
      userData['panier'],
      userData['month'],
      userData['isActive'],
    );
  }

  Product _productFromSnapShot(DocumentSnapshot snapshot) {
    final userData = (snapshot.data() as dynamic);

    return Product(
      uid: userData['prodUid'],
      title: userData['prodTitle'],
      price: userData['prodPrice'],
      img: userData['prodImg'],
      nbProd: userData['prodNb'],
      isHidden: userData['isHidden'],
    );
  }

  ChiffresByMonth _chiffresFromSnapShot(DocumentSnapshot snapshot) {
    final userData = (snapshot.data() as dynamic);

    return ChiffresByMonth(
      title: userData['title'],
      cfMonth: DateTime(year, userData['cfMonth'],),
      chiffres: userData['chiffres'],
    );
  }

  /// Stream to get current user
  Stream<MyEvent> get anEvent {
    return eventCollection.doc('$month - $year').collection("all").doc(eventUid).snapshots().map(_eventsFromSnapShot);
  }

  Stream<ChiffresByMonth> getChiffre(DateTime? mois){
    return chiffresCollection.doc("${mois!.year}").collection("all").doc("${mois.month} - $eventUid").snapshots().map(_chiffresFromSnapShot);
  }

  /// Stream list to get all users
  Stream<List<MyEvent>> get allEvents {
    return eventCollection
        .doc("$month - $year")
        .collection("all")
        .snapshots()
        .map(_eventListFromSnapShot);
  }

  Stream<List<ChiffresByMonth>> get allMonth {
    return chiffresCollection
        .doc('$year')
        .collection("all")
        .snapshots()
        .map(_chiffresListFromSnapShot);
  }

  /// Stream list to get all users
  Stream<List<MyEvent>> get allEventByMonthAndYear {
    return eventCollection
        .doc("$month - $year")
        .collection("all")
        .snapshots()
        .map(_eventListFromSnapShot);
  }

  /// Stream list to get all users
  Stream<List<MyEvent>> get allEventsOfTheYear {
    var dateMap = {
      "start": DateTime(year, 1, 1, 8, 0, 0),
      "end": DateTime(year + 1, 1, 1, 0, 0, 0)
    };

    var days = calculateDaysInterval(dateMap);

    return eventCollection
        .doc('$month - $year')
        .collection("all")
        .snapshots()
        .map((event) {
      return event.docs.map((e) => _eventsFromSnapShot(e)).toList();
    });
  }

  /// Stream list to get all users
  Stream<List<Product>> get allPanier {
    return eventCollection
        .doc("$month - $year")
        .collection("all")
        .doc(eventUid)
        .collection("panier")
        .snapshots()
        .map(_productListFromSnapShot);
  }

  searchByName(searchField) {
    return _firebaseInstance
        .collection('events')
        .where('searchKey',
            isEqualTo: searchField.substring(0, 1).toUpperCase())
        .get();
  }

  searchByUserName(searchField) {
    return _firebaseInstance
        .collection('events')
        .where('searchKey',
            isEqualTo: searchField.substring(0, 1).toUpperCase())
        .get();
  }

  List<MyEvent> _eventListFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => _eventsFromSnapShot(doc)).toList();
  }

  List<ChiffresByMonth> _chiffresListFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => _chiffresFromSnapShot(doc)).toList();
  }

  List<MyEvent> _eventListByYearFromSnapShot(QuerySnapshot snapshot) {
    List<MyEvent> list = [];

    var dateMap = {
      "start": DateTime(year, 1, 1, 8, 0, 0),
      "end": DateTime(year + 1, 1, 1, 0, 0, 0)
    };

    var days = calculateDaysInterval(dateMap);
    //print(days.length);

    for (int i = 0; i < days.length; i++) {
      list.add(
          snapshot.docs.map((doc) => _eventsFromSnapShot(doc)).elementAt(i));
      //print(list.length);
    }
    return list;
  }

  List<Product> _productListFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => _productFromSnapShot(doc)).toList();
  }
}
