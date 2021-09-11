import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suividevente/utils/constants.dart';
import 'package:suividevente/utils/menu_item.dart';
import 'package:suividevente/view/dashboard/components/edit_products_widget.dart';
import 'package:suividevente/view/layout/layout.dart';
import 'package:suividevente/view/stats/components/stats_layout.dart';

import '../dashboard.dart';

class EditLayout extends StatefulWidget {
  const EditLayout({Key? key}) : super(key: key);

  @override
  _EditLayoutState createState() => _EditLayoutState();
}

class _EditLayoutState extends State<EditLayout> {

  double tranx = 0, trany = 0, scale = 1.0;
  bool menuOpen = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kDefaultBackgroundColor,
      body: FadeIn(
        child: Stack(
          children: [
            sideMenu(size),
            const EditProductsWidget(),
          ],
        ),
      ),
    );
  }

  Widget sideMenu(Size size) {
    return Container(
      color: kDefaultBackgroundColor,
      padding: const EdgeInsets.only(top: 50.0, left: 10.0, right: 10.0, bottom: 10.0),
      alignment: Alignment.topCenter,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MenuItem(
            title: "Statistiques",
            icon: const FaIcon(FontAwesomeIcons.chartBar, color: kWhiteColor, size: 15.0,),
            func: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const StatLayout()));
            },
          ),
          MenuItem(
            title: "Calendriers",
            icon: const FaIcon(FontAwesomeIcons.calendar, color: kWhiteColor, size: 15.0,),
            func: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Layout()));
            },
          ),
          MenuItem(
            title: "Dashboard",
            icon: const FaIcon(FontAwesomeIcons.user, color: kWhiteColor, size: 15.0,),
            func: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Dashboard()));
            },
          )
        ],
      ),
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
}
