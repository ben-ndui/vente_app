import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:suividevente/controller/product_databases/product_database.dart';
import 'package:suividevente/model/product.dart';
import 'package:suividevente/utils/constants.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _formKey = GlobalKey<FormState>();

  bool menuOpen = false;
  double tranx = 0, trany = 0, scale = 1.0;

  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final imageController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    priceController.dispose();
    imageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDefaultBackgroundColor,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.translationValues(tranx, trany, 0)..scale(scale),
        child: LayoutBuilder(
          builder: (context, BoxConstraints viewportConstraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
              child: FadeInRight(
                child: Container(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: body(),
                  decoration: BoxDecoration(
                    color: kDefaultBackgroundColor,
                    borderRadius: menuOpen ? BorderRadius.circular(20.0) : BorderRadius.circular(0.0),
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  Widget body(){
    return Stack(
      children: [
        myAppBar(),
        choiceButton(),
      ],
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
              Navigator.of(context).pop();
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
            "Dashboard",
            style: TextStyle(color: kWhiteColor, fontSize: titleSize),
          ),
        ],
      ),
    );
  }

  Widget choiceButton(){
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => _addProduct(),
            child: SizedBox(
              width: 150.0,
              height: 150.0,
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    FaIcon(FontAwesomeIcons.plusSquare, color: kDefaultBackgroundColor,),
                    SizedBox(height: 10.0,),
                    Text("Ajouter\nun produit", textAlign: TextAlign.center,style: TextStyle(color: kDefaultBackgroundColor, fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 50.0,),
          GestureDetector(
            onTap: () => _addProduct(),
            child: SizedBox(
              width: 150.0,
              height: 150.0,
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    FaIcon(FontAwesomeIcons.edit, color: kDefaultBackgroundColor,),
                    SizedBox(height: 10.0,),
                    Text("Editer / Suppimer\nun produit", textAlign: TextAlign.center,style: TextStyle(color: kDefaultBackgroundColor, fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addProduct() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter un produit', textAlign: TextAlign.center, style: TextStyle(color: kDefaultBackgroundColor, fontWeight: FontWeight.bold),),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: ListBody(
                children: <Widget>[
                  buildTextFieldForm(controller: titleController, title: "Nom du produit"),
                  buildTextFieldForm(controller: priceController, title: "Prix du produit"),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ajouter'),
              onPressed: () {
                saveProduct();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildTextFieldForm({required TextEditingController controller, required String title}) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.center,
      validator: (value) => value != null && value.isEmpty ? "Vous avez rien saisie comme $title" : null,
    );
  }

  Future<void> saveProduct() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid){
      final Product product = Product(uid: titleController.value.text, title: titleController.value.text, price: priceController.text.trim(), img: "", nbProd: 1);
      ProductDatabaseService provider = ProductDatabaseService(uid: product.uid);
      await ProductDatabaseService(uid: product.uid).saveProduct(product.uid, product.title, product.price, product.img, product.nbProd);
    }else{
      print("Une erreur s'est produite lors de l'ajout du produit");
    }
  }
}
