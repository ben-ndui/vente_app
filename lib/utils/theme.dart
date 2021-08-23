import 'package:flutter/material.dart';

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