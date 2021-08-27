import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FireStorageService extends ChangeNotifier{

  var uid;

  FireStorageService({this.uid});

  Future<dynamic> loadImage(BuildContext context, String image) async {
    return await FirebaseStorage.instance.ref("images").child(image).getDownloadURL();
  }
}