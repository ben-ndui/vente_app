import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suividevente/utils/constants.dart';

class MenuItem extends StatelessWidget {
  final String title;
  final FaIcon icon;
  final func;

  const MenuItem({Key? key, required this.title, required this.icon, this.func}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      child: TextButton.icon(onPressed: func, icon: icon, label: Text(title, style: const TextStyle(color: kWhiteColor),)),
    );
  }
}
