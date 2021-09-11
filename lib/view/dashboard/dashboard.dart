import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:suividevente/controller/FirebaseApi/firebase_api.dart';
import 'package:suividevente/controller/product_databases/product_database.dart';
import 'package:suividevente/model/product.dart';
import 'package:suividevente/utils/constants.dart';
import 'package:suividevente/utils/theme.dart';
import 'package:suividevente/view/dashboard/components/edit_layout.dart';
import 'package:file_picker/file_picker.dart';

import 'components/edit_products_widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _formKey = GlobalKey<FormState>();
  File? file;
  PickedFile? _imageFile;
  UploadTask? task;

  late String _fileName = "";

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
                  child: body(context),
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

  Widget body(BuildContext context){
    return Stack(
      children: [
        myAppBar(context),
        choiceButton(context),
      ],
    );
  }

  Widget myAppBar(BuildContext context) {
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

  Widget choiceButton(BuildContext context){
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => _addProduct(context),
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
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EditLayout())),
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

  Future<void> _addProduct(BuildContext context) async {
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
                  const SizedBox(height: 30.0,),
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                      boxShadow: [
                        BoxShadow(color: kWhiteColor, spreadRadius: 2.0, blurRadius: 2.0),
                        BoxShadow(color: kWhiteColor, spreadRadius: 2.0, blurRadius: 2.0),
                      ]
                    ),
                    child: Center(child: TextButton.icon(onPressed: (){
                      _selectFile();
                    }, icon: const FaIcon(FontAwesomeIcons.image), label: const Text("Importer"))),
                  ),
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

  Future<void> saveProduct() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid){
      final Product product = Product(uid: titleController.value.text, title: titleController.value.text, price: priceController.text.trim(), img: _fileName, nbProd: 1);
      ProductDatabaseService provider = ProductDatabaseService(uid: product.uid);
      await ProductDatabaseService(uid: product.uid).saveProduct(product.uid, product.title, product.price, product.img, product.nbProd);
    }else{
      print("Une erreur s'est produite lors de l'ajout du produit");
    }
  }

  Future _selectFile() async {
    final selected = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (selected == null) return;
    final path = selected.files.single.path;

    setState(() {
      file = File(path);
    });
    uploadFile();
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'images/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {
      _fileName = fileName;
    });

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
  }
}
