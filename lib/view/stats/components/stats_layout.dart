import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suividevente/utils/constants.dart';
import 'package:suividevente/utils/menu_item.dart';
import 'package:suividevente/view/dashboard/dashboard.dart';
import 'package:suividevente/view/home/calendar_widget.dart';
import 'package:suividevente/view/layout/layout.dart';
import 'package:suividevente/view/stats/stats_widget.dart';

class StatLayout extends StatefulWidget {
  const StatLayout({Key? key}) : super(key: key);

  @override
  _StatLayoutState createState() => _StatLayoutState();
}

class _StatLayoutState extends State<StatLayout> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kDefaultBackgroundColor,
      body: FadeIn(
        child: Stack(
          children: [
            sideMenu(size),
            const StatsWidget(),
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
}
