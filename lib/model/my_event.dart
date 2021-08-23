import 'package:flutter/material.dart';
import 'package:suividevente/utils/constants.dart';

import 'product.dart';

class MyEvent {
  final String title;
  final String description;
  DateTime from;
  final DateTime to;
  final Color color;
  final bool isAllDay;
  List<Product> listProduit = [
    Product(title: "Pull en laine", price: "30.90", img: "assets/background/back1.jpeg"),
    Product(title: "Pull en laine", price: "30.90", img: "assets/background/back1.jpeg"),
    Product(title: "Pantalon en laine", price: "30.90", img: "assets/background/back1.jpeg"),
    Product(title: "Pantalon en laine", price: "30.90", img: "assets/background/back1.jpeg"),
    Product(title: "Short en laine", price: "30.90", img: "assets/background/back1.jpeg"),
    Product(title: "Short en laine", price: "30.90", img: "assets/background/back1.jpeg"),
    Product(title: "Gants en laine", price: "30.90", img: "assets/background/back1.jpeg"),
    Product(title: "Gants en laine", price: "30.90", img: "assets/background/back1.jpeg"),
  ];

  bool sun = false;
  bool cloud = false;
  bool tint = false;
  bool pooCloud = false;
  bool cloudSomething = false;

  List<ProductBis> sortProdList = [];
  List<Product> panier = [];

  MyEvent(
    this.title,
    this.color,
    this.description,
    this.from,
    this.to,
    this.isAllDay,
  );

  displayProduct(){
    listProduit.map((e){
      return ListTile(
        title: Card(child: Image.asset(e.img),),
      );
    });
  }

  List<ProductBis> sortProductList(){
    int mysum = 0;
    int i;
    int j;

    for(i = 0; i < listProduit.length; i++){
      if(listProduit[i].title == listProduit[i+1].title){
        for(j = i; j < sortProdList.length; j++){
          if(sortProdList[j].title == listProduit[i+1].title){
            sortProdList[j].number = mysum;
          }
          sortProdList.add(ProductBis(number: mysum, title: listProduit[i].title));
        }
        mysum++;
      }
    }
    return sortProdList;
  }

  String getTotalPanier(){
    double summm = 0;
    panier.forEach((element) {
      summm = summm + (double.parse(element.price) * element.nbProd);
    });

    return summm.toStringAsFixed(2);
  }

  void addProductToPanier(Product product){
    panier.forEach((element) {
      if(element.title == product.title){
        element.nbProd = element.nbProd + 1;
      }else{
        panier.add(product);
      }
    });
  }

  Color get getColor => panier.isNotEmpty ? color : kLightBackgroundColor;

  @override
  String toString() => title;
}
