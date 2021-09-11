

class Product{
  final String uid;
  final String title;
  final String price;
  final String img;
  int nbProd = 0;
  double total = 0.0;

  Product({required this.uid, required this.title, required this.price, required this.img, required this.nbProd});

  double getTotal(){
    return nbProd * total;
  }

  setProdNb(int leNb){
    nbProd += leNb;
  }
}

class ProductBis{
  int number;
  String title;

  ProductBis({required this.number, required this.title});
}