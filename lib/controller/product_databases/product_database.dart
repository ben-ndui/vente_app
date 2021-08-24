import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suividevente/model/product.dart';

class ProductDatabaseService {
  var uid;
  final FirebaseFirestore _firebaseInstance = FirebaseFirestore.instance;

  /// Collection user
  final CollectionReference productCollection =
      FirebaseFirestore.instance.collection("products");

  ProductDatabaseService({this.uid});

  /// Permet de récupérer les donnée de n'importe quel collection de firebase
  Future getAllProductsFromFirebase() async {
    QuerySnapshot snapshot = await _firebaseInstance.collection("products").get();

    return snapshot.docs;
  }

  /// Save user
  Future<void> saveProduct(String? uid, String? title, String? price, String? img) async {
    return await _firebaseInstance.collection("products").doc(uid).set(
      {
        'uid': uid,
        'title': title,
        'price': price,
        'img': img,
        'searchKey': title!.substring(0, 1),
      },
    ).then((value) => print("Ajout réussi")).catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateProductInfo(String? uid, String? title, String? price,String? img) async {
    return await productCollection.doc(uid).update(
      {
        'uid': uid,
        'title': title,
        'price': price,
        'img': img,
        'searchKey': title!.substring(0, 1),
      },
    );
  }

  Product _productFromSnapShot(DocumentSnapshot snapshot) {
    final userData = (snapshot.data() as dynamic);
    return Product(
      uid: userData["uid"],
      title: userData["title"],
      price: userData["price"],
      img: userData["img"],
    );
  }

  /// Stream to get current user
  Stream<Product> get product {
    return productCollection.doc(uid).snapshots().map(_productFromSnapShot);
  }

  /// Stream list to get all users
  Stream<List<Product>> get allProducts {
    return productCollection.snapshots().map(_productListFromSnapShot);
  }

  searchByName(searchField) {
    return _firebaseInstance
        .collection('products')
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

  List<Product> _productListFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => _productFromSnapShot(doc)).toList();
  }
}
