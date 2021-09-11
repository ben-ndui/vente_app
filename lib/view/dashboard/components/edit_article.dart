import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suividevente/controller/product_databases/product_database.dart';
import 'package:suividevente/model/product.dart';
import 'package:suividevente/utils/constants.dart';
import 'package:suividevente/utils/theme.dart';

class EditArticle extends StatefulWidget {
  final Product product;

  const EditArticle({Key? key, required this.product}) : super(key: key);

  @override
  _EditArticleState createState() => _EditArticleState();
}

class _EditArticleState extends State<EditArticle> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController prodTitle = TextEditingController();
  final TextEditingController prodPrice = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDefaultBackgroundColor,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton.icon(onPressed: (){
              Navigator.of(context).pop();
            }, icon: const FaIcon(FontAwesomeIcons.chevronLeft, color: kWhiteColor,), label: const Text("RETOUR", style: TextStyle(color: kWhiteColor),)),
          ),
          body(),
        ],
      ),
    );
  }

  Widget body() {
    return Center(
      child: Container(
        width: 400.0,
        height: 400.0,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 10.0, spreadRadius: 2.0),
          ]
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  child: FutureBuilder(
                    future:
                    getImageFromStore(context, widget.product.img),
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
                  height: 20.0,
                ),
                Text(widget.product.title, style: const TextStyle(fontWeight: FontWeight.bold),),
                buildTextFieldForm(controller: prodTitle, title: widget.product.title),
                const SizedBox(height: 20.0,),
                buildTextFieldForm(controller: prodPrice, title: widget.product.price),
                const SizedBox(
                  height: 30.0,
                ),
                TextButton.icon(onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    await ProductDatabaseService(uid: widget.product.uid).updateProductInfo(widget.product.uid, prodTitle.text.trim(), prodPrice.text.trim(), widget.product.img, widget.product.nbProd).then((value){
                      Navigator.of(context).pop();
                    });
                  }
                }, icon: const FaIcon(FontAwesomeIcons.check, color: Colors.green,), label: const Text("Enregistrer"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
