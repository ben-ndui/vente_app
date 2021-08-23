

class Product{
  final String uid;
  final String title;
  final String price;
  final String img;
  int nbProd = 1;
  double total = 0.0;

  Product({required this.uid, required this.title, required this.price, required this.img});

  double getTotal(){
    return nbProd * total;
  }
}

class ProductBis{
  int number;
  String title;

  ProductBis({required this.number, required this.title});
}