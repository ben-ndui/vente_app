import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suividevente/utils/constants.dart';

class MenuItem extends StatelessWidget {
  final String title;
  final FaIcon icon;
  final dynamic func;

  const MenuItem({Key? key, required this.title, required this.icon, this.func})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: func,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 8.0,),
            Text(title, textAlign: TextAlign.start, style: const TextStyle(color: kWhiteColor,),)
          ],
        ),
      ),
    );
  }
}
