import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suividevente/controller/product_databases/product_database.dart';
import 'package:suividevente/model/product.dart';
import 'package:suividevente/utils/constants.dart';
import 'package:suividevente/utils/theme.dart';

import 'edit_article.dart';

class EditProductsWidget extends StatefulWidget {
  const EditProductsWidget({Key? key}) : super(key: key);

  @override
  _EditProductsWidgetState createState() => _EditProductsWidgetState();
}

class _EditProductsWidgetState extends State<EditProductsWidget> {
  double tranx = 0, trany = 0, scale = 1.0;
  bool menuOpen = false;
  bool isHidden = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      transform: Matrix4.translationValues(tranx, trany, 0)..scale(scale),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              color: kDefaultBackgroundColor,
            ),
            child: Stack(
              children: [
                myAppBar(),
                Container(child: buildBody(), margin: const EdgeInsets.only(top: 70.0),),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          displayProd(),
        ],
      ),
    );
  }

  Widget displayProd() {
    return StreamBuilder<List<Product>>(
      stream: ProductDatabaseService().allProducts,
      builder: (context, prodList) {
        if (!prodList.hasData) return const CircularProgressIndicator();

        final products = prodList.data;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            physics: const ScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              childAspectRatio: 2.3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            shrinkWrap: true,
            itemCount: products!.length,
            itemBuilder: (context, index) {
              return Card(
                child: GridTile(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: FutureBuilder(
                                future:
                                    getImageFromStore(context, products[index].img),
                                builder: (context, snap) {
                                  if (!snap.hasData) {
                                    return const CircularProgressIndicator();
                                  }
                                  return snap.data as Image;
                                },
                              ),
                              width: 100.0,
                              height: 100.0,
                            ),
                            const SizedBox(
                              width: 20.0,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(products[index].title.length > 12
                                      ? products[index].title.replaceFirst(" ", "\n")
                                      : products[index].title),
                                  Text(products[index].price),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextButton.icon(onPressed: (){
                              // Hide product
                              setState(() {
                                isHidden = !isHidden;
                              });
                              ProductDatabaseService(uid: products[index].uid).updateProductInfo(products[index].uid, products[index].title, products[index].price, products[index].img, products[index].nbProd, isHidden);
                            }, icon: FaIcon(products[index].isHidden ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye, color: products[index].isHidden ? kRedColor : Colors.green, size: 18.0,), label: const Text("Cacher", style: TextStyle(color: kDefaultBackgroundColor),)),
                            TextButton.icon(onPressed: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => FadeIn(child: EditArticle(product: products[index],))));
                            }, icon: const FaIcon(FontAwesomeIcons.edit, color: kDefaultBackgroundColor, size: 18.0,), label: const Text("Editer", style: TextStyle(color: kDefaultBackgroundColor),)),
                            TextButton.icon(onPressed: (){
                              showDialog<void>(
                                context: context,
                                barrierDismissible: true, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Center(child: FaIcon(FontAwesomeIcons.exclamationTriangle, color: kRedColor, size: 40.0,)),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          const Text("Vous allez supprimer l'article", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
                                          const SizedBox(height: 4.0,),
                                          Text("'" + products[index].uid + "'", textAlign: TextAlign.center, style: const TextStyle(color: kRedColor),),
                                          const SizedBox(height: 4.0,),
                                          SizedBox(
                                            child: FutureBuilder(
                                              future:
                                              getImageFromStore(context, products[index].img),
                                              builder: (context, snap) {
                                                if (!snap.hasData) {
                                                  return const CircularProgressIndicator();
                                                }
                                                return snap.data as Image;
                                              },
                                            ),
                                            width: 100.0,
                                            height: 100.0,
                                          )
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Annuler', style: TextStyle(color: Colors.green),),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Supprimer', style: TextStyle(color: kRedColor),),
                                        onPressed: () async {
                                          await ProductDatabaseService(uid: products[index].uid).delProdBy();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }, icon: const FaIcon(FontAwesomeIcons.trash, color: kRedColor, size: 18.0,), label: const Text("Supprimer", style: TextStyle(color: kRedColor),)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget myAppBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          !menuOpen
              ? TextButton(
                  onPressed: () {
                    scale = 0.7;
                    tranx = 150;
                    trany = 100;
                    setState(() {
                      menuOpen = true;
                    });
                  },
                  child: const FaIcon(
                    FontAwesomeIcons.bars,
                    color: kWhiteColor,
                  ),
                )
              : TextButton(
                  onPressed: () {
                    scale = 1.0;
                    tranx = 0;
                    trany = 0;
                    setState(() {
                      menuOpen = false;
                    });
                  },
                  child: const FaIcon(
                    FontAwesomeIcons.arrowLeft,
                    color: kWhiteColor,
                  ),
                ),
          const SizedBox(
            width: 10.0,
          ),
          const Text(
            "Calendriers",
            style: TextStyle(color: kWhiteColor, fontSize: titleSize),
          ),
        ],
      ),
    );
  }

  Future<void> _showMyDialog(func, articleName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const FaIcon(FontAwesomeIcons.stop, color: kRedColor,),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text("Vous allez supprimer l'article"),
                Text(articleName),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Supprimer'),
              onPressed: func,
            ),
          ],
        );
      },
    );
  }
}
