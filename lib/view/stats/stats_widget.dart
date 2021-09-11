import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:suividevente/controller/event_databases/event_databases.dart';
import 'package:suividevente/model/chiffres_by_month.dart';
import 'package:suividevente/model/my_event.dart';
import 'package:suividevente/utils/constants.dart';
import 'package:suividevente/utils/menu_item.dart';
import 'package:suividevente/utils/theme.dart';
import 'package:suividevente/utils/utils.dart';
import 'package:suividevente/view/dashboard/dashboard.dart';
import 'package:suividevente/view/layout/layout.dart';
import 'package:suividevente/view/stats/components/stats_layout.dart';

class StatsWidget extends StatefulWidget {
  const StatsWidget({Key? key}) : super(key: key);

  @override
  _StatsWidgetState createState() => _StatsWidgetState();
}

class _StatsWidgetState extends State<StatsWidget> {
  final databaseReference = FirebaseFirestore.instance;

  final DateTime _initialDate = DateTime.now();

  double tranx = 0, trany = 0, scale = 1.0;
  bool menuOpen = false;
  bool yearIsActive = false;
  bool visible = false;
  bool visible2 = false;
  bool matinOuSoir = false;

  List<MyEvent> eventss = [];

  List<double> aout = [];

  double total = 0.0;

  DateTime dateTime = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      transform: Matrix4.translationValues(tranx, trany, 0)..scale(scale),
      child: Scaffold(
        backgroundColor: kDefaultBackgroundColor,
        body: ZoomIn(
          child: SafeArea(
            child: LayoutBuilder(
                builder: (context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Column(
                    children: [
                      myAppBar(),
                      body(size),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget body(Size size) {
    return SafeArea(
      child: Container(
        color: kDefaultBackgroundColor,
        width: size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton.icon(
                      onPressed: () {
                        setState(() {
                          if (yearIsActive) {
                            dateTime = DateTime(
                              dateTime.year - 1,
                            );
                          } else {
                            dateTime =
                                DateTime(dateTime.year, dateTime.month - 1);
                          }
                        });
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.arrowCircleLeft,
                        color: kWhiteColor,
                      ),
                      label: const Text("")),
                  Text(
                    yearIsActive
                        ? '${dateTime.year}'
                        : Utils.toDate3(dateTime) + ' ${dateTime.year}',
                    style: const TextStyle(color: kWhiteColor, fontSize: 25.0),
                  ),
                  TextButton.icon(
                      onPressed: () {
                        setState(() {
                          if (yearIsActive) {
                            dateTime = DateTime(
                              dateTime.year + 1,
                            );
                          } else {
                            dateTime =
                                DateTime(dateTime.year, dateTime.month + 1);
                          }
                        });
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.arrowCircleRight,
                        color: kWhiteColor,
                      ),
                      label: const Text("")),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(child: button(size, kYellowColor, "Marché du matin")),
                  Expanded(child: button(size, kBlueColor, "Marché du soir")),
                ],
              ),
            ),
            SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: yearIsActive
                  ? buildDayForCurrentYear()
                  : buildMonthStats(),
            ),
            StreamBuilder<List<ChiffresByMonth>>(
                stream: EventDatabaseService(
                        month: dateTime.month, year: dateTime.year)
                    .allMonth,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text("Rien à afficher");
                  return Text(
                    "SOLD: $total",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: kWhiteColor, fontSize: 30.0),
                  );
                }),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  /// True = Left panel
  /// False = Rigth panel
  Widget screenDisplay(Size size, Color color, String text, bool leftOrRight) {
    return SafeArea(
      child: Stack(
        ///Marché du matin
        children: [
          leftOrRight ? buildStatsLeftPanel() : buildStatsRightPanel(),
        ],
      ),
    );
  }

  Widget button(Size size, Color color, String text) {
    return Card(
      color: kLightBackgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 10.0,
            height: 50.0,
            color: color,
          ),
          Expanded(
            child: TextButton(
              onPressed: () {
                if (text.contains("Marché du matin")) {
                  //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddEvent(matinOuSoir: "Marché du matin")));

                  setState(() {
                    visible = !visible;
                    visible2 = !visible2;
                    matinOuSoir = !matinOuSoir;
                  });
                } else if (text.contains("Marché du soir")) {
                  //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddEvent(matinOuSoir: "Marché du soir")));
                  setState(() {
                    visible = !visible;
                    visible2 = !visible2;
                    matinOuSoir = !matinOuSoir;
                  });
                }
              },
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget myAppBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          !menuOpen
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
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
                    ),
                    const Text(
                      "Statistiques",
                      style: TextStyle(color: kWhiteColor, fontSize: titleSize),
                    ),
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
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
                    const Text(
                      "Statistiques",
                      style: TextStyle(color: kWhiteColor, fontSize: titleSize),
                    )
                  ],
                ),
          const SizedBox(
            width: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () {
                setState(() {
                  yearIsActive = !yearIsActive;
                  getTotal();
                  //getAllEventsByMonthAndYear();
                });
              },
              child: Text(
                yearIsActive
                    ? "Afficher les chiffres du mois en cours"
                    : "Afficher les chiffres sur l'année",
                style: const TextStyle(
                  color: kWhiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sideMenu(Size size) {
    return Container(
      color: kDefaultBackgroundColor,
      padding: const EdgeInsets.only(
          top: 50.0, left: 10.0, right: 10.0, bottom: 10.0),
      alignment: Alignment.topCenter,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MenuItem(
            title: "Statistiques",
            icon: const FaIcon(
              FontAwesomeIcons.chartBar,
              color: kWhiteColor,
              size: 15.0,
            ),
            func: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const StatLayout()));
            },
          ),
          MenuItem(
            title: "Calendriers",
            icon: const FaIcon(
              FontAwesomeIcons.calendar,
              color: kWhiteColor,
              size: 15.0,
            ),
            func: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Layout()));
            },
          ),
          MenuItem(
            title: "Dashboard",
            icon: const FaIcon(
              FontAwesomeIcons.user,
              color: kWhiteColor,
              size: 15.0,
            ),
            func: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Dashboard()));
            },
          )
        ],
      ),
    );
  }

  Widget buildStatsLeftPanel() {
    return StreamBuilder<List<MyEvent>>(
      stream: EventDatabaseService(month: dateTime.month, year: dateTime.year)
          .allEvents,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        final events = snapshot.data;
        events!.sort((a, b) {
          return a.from.day.compareTo(b.from.day);
        });

        return SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.only(top: 50.0, bottom: 80.0),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: events.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return events[index].description == "Marché du matin"
                    ? ListTile(
                        title: Text(
                          Utils.toDate2(events[index].from) +
                              ' ${events[index].from.day} : ${events[index].panierCount} €',
                          style: const TextStyle(
                              color: kWhiteColor, fontWeight: FontWeight.bold),
                        ),
                        trailing: buildMeteo(events[index]),
                      )
                    : Container();
              },
            ),
          ),
        );
      },
    );
  }

  Widget buildStatsRightPanel() {
    return StreamBuilder<List<MyEvent>>(
      stream: EventDatabaseService(month: dateTime.month, year: dateTime.year)
          .allEvents,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        final events = snapshot.data;

        events!.sort((a, b) {
          return a.from.day.compareTo(b.from.day);
        });

        return SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.only(top: 50.0, bottom: 80.0),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: events.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return events[index].description == "Marché du soir"
                    ? ListTile(
                        title: Text(
                          Utils.toDate2(events[index].from) +
                              ' ${events[index].from.day} : ${events[index].panierCount} €',
                          style: const TextStyle(
                              color: kWhiteColor, fontWeight: FontWeight.bold),
                        ),
                        trailing: buildMeteo(events[index]),
                      )
                    : Container();
              },
            ),
          ),
        );
      },
    );
  }

  Widget buildMeteo(MyEvent event) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        event.sun
            ? FaIcon(
                FontAwesomeIcons.sun,
                color: event.title == "Marché du matin"
                    ? kYellowColor
                    : kBlueColor,
              )
            : Container(),
        const SizedBox(
          width: 10.0,
        ),
        event.cloud
            ? FaIcon(
                FontAwesomeIcons.cloud,
                color: event.title == "Marché du matin"
                    ? kYellowColor
                    : kBlueColor,
              )
            : Container(),
        const SizedBox(
          width: 10.0,
        ),
        event.tint
            ? FaIcon(
                FontAwesomeIcons.tint,
                color: event.title == "Marché du matin"
                    ? kYellowColor
                    : kBlueColor,
              )
            : Container(),
        const SizedBox(
          width: 10.0,
        ),
        event.pooCloud
            ? FaIcon(
                FontAwesomeIcons.pooStorm,
                color: event.title == "Marché du matin"
                    ? kYellowColor
                    : kBlueColor,
              )
            : Container(),
        const SizedBox(
          width: 10.0,
        ),
        event.cloudSomething
            ? FaIcon(
                FontAwesomeIcons.cloudMeatball,
                color: event.title == "Marché du matin"
                    ? kYellowColor
                    : kBlueColor,
              )
            : Container(),
      ],
    );
  }

  Widget buildMonthStats() {
    return matinOuSoir ? buildSoir() : buildMatin();
  }

  Widget buildMatin() {
    return StreamBuilder<List<MyEvent>>(
      stream: EventDatabaseService(month: dateTime.month, year: dateTime.year)
          .allEvents,
      builder: (context, events) {
        if (!events.hasData) return const CircularProgressIndicator();
        return Container(
          padding: const EdgeInsets.all(10.0),
          alignment: Alignment.center,
          child: GridView.builder(
            physics: const ScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              childAspectRatio: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 0,
            ),
            shrinkWrap: true,
            itemCount: events.data!.length,
            itemBuilder: (context, index) {
              return events.data![index].title.contains("Marché du matin") ? Container(
                //color: Colors.grey,
                padding: const EdgeInsets.all(6.0),
                child: GridTile(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utils.toDate2(events.data![index].from) +
                                ' ${events.data![index].from.day} : ${events.data![index].panierCount} €',
                            style: const TextStyle(
                                color: kWhiteColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            events.data![index].title.contains("soir")
                                ? "Soir"
                                : "Matin",
                            style: const TextStyle(
                              color: kWhiteColor,
                            ),
                          ),
                        ],
                      ),
                      buildMeteo(events.data![index]),
                    ],
                  ),
                ),
              ) : Container();
            },
          ),
        );
      },
    );
  }
  
  Widget buildSoir() {
    return StreamBuilder<List<MyEvent>>(
      stream: EventDatabaseService(month: dateTime.month, year: dateTime.year).allEvents,
      builder: (context, events) {

        if (!events.hasData) return const CircularProgressIndicator();

        return GridView.builder(
          physics: const ScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400,
            childAspectRatio: 5,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
          ),
          shrinkWrap: true,
          itemCount: events.data!.length,
          itemBuilder: (context, index) {
            return events.data![index].title.contains("Marché du soir") ? Container(
              //color: Colors.grey,
              padding: const EdgeInsets.all(6.0),
              child: GridTile(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Utils.toDate2(events.data![index].from) +
                              ' ${events.data![index].from.day} : ${events.data![index].panierCount} €',
                          style: const TextStyle(
                              color: kWhiteColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          events.data![index].title.contains("soir")
                              ? "Soir"
                              : "Matin",
                          style: const TextStyle(
                            color: kWhiteColor,
                          ),
                        ),
                      ],
                    ),
                    buildMeteo(events.data![index]),
                  ],
                ),
              ),
            ) : Container();
          },
        );
      },
    );
  }

  Widget buildDayForCurrentMonth() {
    return StreamBuilder<List<MyEvent>>(
      stream: EventDatabaseService(month: dateTime.month, year: dateTime.year)
          .allEvents,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        final events = snapshot.data;

        events!.sort((a, b) {
          return a.from.day.compareTo(b.from.day);
        });

        return Container(
          padding: const EdgeInsets.all(15.0),
          child: GridView.builder(
            physics: const ScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              childAspectRatio: 5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: events.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                //color: Colors.grey,
                padding: const EdgeInsets.all(6.0),
                child: GridTile(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utils.toDate2(events[index].from) +
                                ' ${events[index].from.day} : ${events[index].panierCount} €',
                            style: const TextStyle(
                                color: kWhiteColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            events[index].title.contains("soir")
                                ? "Soir"
                                : "Matin",
                            style: const TextStyle(
                              color: kWhiteColor,
                            ),
                          ),
                        ],
                      ),
                      buildMeteo(events[index]),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  getTotal() async {
    final chiffresss =
        EventDatabaseService(month: dateTime.month, year: dateTime.year)
            .allMonth;

    chiffresss.forEach((chifList) {
      for (var element in chifList) {
        setState(() {
          total = total + element.chiffres;
        });
      }
    });

    if (total < 0) {
      total = 0.0;
    }
  }

  Widget buildDayForCurrentYear() {
    return StreamBuilder<List<ChiffresByMonth>>(
      stream: EventDatabaseService(month: dateTime.month, year: dateTime.year)
          .allMonth,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        final data = snapshot.data;

        data!.sort((a, b) {
          return a.cfMonth.month.compareTo(b.cfMonth.month);
        });

        return GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 500,
            childAspectRatio: 5,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final Object chiffress;
            if (data[index].chiffres < 0) {
              EventDatabaseService(
                      year: _initialDate.year, month: data[index].cfMonth.month)
                  .updateChiffres(data[index].title, data[index].cfMonth.month,
                      0.0, _initialDate);
            }
            chiffress = data[index].chiffres;

            return GridTile(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    Utils.toMonth(data[index].cfMonth) + " : $chiffress",
                    style: const TextStyle(
                      color: kWhiteColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> getDataFromFireStore() async {
    var snapShotsValue;

    var dateMap = {
      "start": DateTime(2021, dateTime.month, 1, 0, 0, 0),
      "end": DateTime(2022, dateTime.month, 1, 0, 0, 0)
    };

    var days = calculateDaysInterval(dateMap);

    for (var i = 0; i < days.length; i++) {
      snapShotsValue = await databaseReference
          .collection("events")
          .doc('${days[i].month} - ${days[i].year}')
          .collection("all")
          .get();
    }

    List<MyEvent> list = snapShotsValue.docs.map((e) {
      //print("TEST : ${e.data()['panier']}");
      return MyEvent(
        e.data()['from'].toDate(),
        e.data()['title'],
        Color(int.parse(e.data()['color'])),
        e.data()['description'],
        e.data()['from'].toDate(),
        e.data()['to'].toDate(),
        e.data()['isAllDay'],
        e.data()['sun'],
        e.data()['cloud'],
        e.data()['tint'],
        e.data()['pooStorm'],
        e.data()['cloudSomething'],
        e.data()['panier'],
        e.data()['month'],
        e.data()['isActive'],
      );
    }).toList();

    setState(() {
      eventss = list;
    });
  }

  dontShow(String whichOne) async {
    var snapShotsValue = await databaseReference
        .collection("events")
        .doc('${_initialDate.month} - ${_initialDate.year}')
        .collection("all")
        .get();

    var dateMap = {
      "start": DateTime(_initialDate.year, _initialDate.month, 1, 8, 0, 0),
      "end": DateTime(_initialDate.year, _initialDate.month, 31, 14, 0, 0)
    };

    var dateMap2 = {
      "start": DateTime(_initialDate.year, _initialDate.month, 1, 18, 0, 0),
      "end": DateTime(_initialDate.year, _initialDate.month, 31, 23, 0, 0)
    };

    //return compute(calculateDaysInterval, dateMap);
    var days = calculateDaysInterval(dateMap);
    var days2 = calculateDaysInterval(dateMap2);

    if (whichOne.contains("Marché du matin")) {
      for (var i = 0; i < days.length; i++) {
        //print("${days[i].day} - ${days[i].month} - ${days[i].year}");
        await EventDatabaseService(eventUid: whichOne)
            .dontShow(false, "isActive", days[i].month, days[i]);
      }
    } else {
      for (var i = 0; i < days2.length; i++) {
        //print("${days[i].day} - ${days[i].month} - ${days[i].year}");
        await EventDatabaseService(eventUid: whichOne)
            .dontShow(false, "isActive", days[i].month, days[i]);
      }
    }

    List<MyEvent> list = snapShotsValue.docs.map((e) {
      return MyEvent(
        e.data()['from'].toDate(),
        e.data()['title'],
        Color(int.parse(e.data()['color'])),
        e.data()['description'],
        e.data()['from'].toDate(),
        e.data()['to'].toDate(),
        e.data()['isAllDay'],
        e.data()['sun'],
        e.data()['cloud'],
        e.data()['tint'],
        e.data()['pooStorm'],
        e.data()['cloudSomething'],
        e.data()['panier'],
        e.data()['month'],
        e.data()['isActive'],
      );
    }).toList();
  }
}
