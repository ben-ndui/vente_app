import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suividevente/utils/constants.dart';
import 'package:suividevente/utils/menu_item.dart';
import 'package:suividevente/view/dashboard/dashboard.dart';
import 'package:suividevente/view/home/calendar_widget.dart';
import 'package:suividevente/view/stats/components/stats_layout.dart';
import 'package:suividevente/view/stats/stats_widget.dart';

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
      body: FadeIn(
        child: Stack(
          children: [
            sideMenu(size),
            const CalendarWidget(),
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
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => FadeIn(child: const Layout())));
            },
          ),
          MenuItem(
            title: "Produits",
            icon: const FaIcon(FontAwesomeIcons.store, color: kWhiteColor, size: 15.0,),
            func: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Dashboard()));
            },
          )
        ],
      ),
    );
  }
}
