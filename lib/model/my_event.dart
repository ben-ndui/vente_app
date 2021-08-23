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
  List<Product> listProduit = [];

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
    for (var element in panier) {
      summm = summm + (double.parse(element.price) * element.nbProd);
    }

    return summm.toStringAsFixed(2);
  }

  void addProductToPanier(Product product){
    for (var element in panier) {
      if(element.title == product.title){
        element.nbProd = element.nbProd + 1;
      }else{
        panier.add(product);
      }
    }
  }

  Color get getColor => panier.isNotEmpty || sun || cloud || tint || pooCloud || cloudSomething ? color : kLightBackgroundColor;

  @override
  String toString() => title;
}
