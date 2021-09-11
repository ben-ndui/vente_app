import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:suividevente/controller/FirebaseApi/firebase_api.dart';
import 'package:suividevente/controller/FirebaseStorage/storage.dart';
import 'package:image_picker/image_picker.dart';

BoxDecoration defaultDecoration(Color bgColor){
  return BoxDecoration(
    color: bgColor,
  );
}

theShowDialog(BuildContext context, String title, content, nextScreen){
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center,),
      content: content,
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: (){
            Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                  pageBuilder: (BuildContext context, Animation animation,
                      Animation secondaryAnimation) {
                    return nextScreen;
                  },
                  transitionDuration: const Duration(milliseconds: 300),
                  transitionsBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child) {
                    animation = CurvedAnimation(
                        curve: Curves.easeInOutCubic, parent: animation);

                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                ),
                    (Route route) => false);
          },
          child: const Text('Ajouter un évènement'),
        ),
      ],
    ),
  );
}

List<DateTime> calculateDaysInterval(dynamic dateMap) {
  var startDate = dateMap["start"];
  var endDate = dateMap["end"];

  List<DateTime> days = [];
  for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
    days.add(startDate.add(Duration(days: i)));
  }

  /* for (var i=0; i<days.length; i++) {
    print(days[i]);
  }*/
  return days;
}

Future<Image> getImageFromStore(
    BuildContext context, String? imageName) async {
  Image image;
  return await FireStorageService()
      .loadImage(context, imageName!)
      .then((value) {
    image = Image.network(
      value.toString(),
      fit: BoxFit.cover,
      width: MediaQuery.of(context).size.width,
      height: 115.0,
    );
    return image;
  });
}

Widget buildTextFieldForm({required TextEditingController controller, required String title}) {
  return TextFormField(
    controller: controller,
    textAlign: TextAlign.center,
    validator: (value) => value != null && value.isEmpty ? "Vous avez rien saisie comme $title" : null,
    decoration: InputDecoration(
      label: Center(child: Text(title, textAlign: TextAlign.center,)),
    ),
  );
}