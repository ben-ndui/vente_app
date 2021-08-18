import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suividevente/utils/constants.dart';
import 'package:suividevente/utils/menu_item.dart';
import 'package:suividevente/view/home/home.dart';

class Layout extends StatefulWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kDefaultBackgroundColor,
      body: Stack(
        children: [
          sideMenu(size),
          const Home(title: 'Home',),
        ],
      ),
    );
  }

  Widget sideMenu(Size size) {
    return Container(
      color: kDarkGreyColor,
      padding: const EdgeInsets.all(10.0),
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MenuItem(
            title: "Statistiques",
            icon: const FaIcon(FontAwesomeIcons.chartBar),
            func: () {},
          ),
          MenuItem(
            title: "Calendriers",
            icon: const FaIcon(FontAwesomeIcons.calendar),
            func: () {},
          )
        ],
      ),
    );
  }
}
