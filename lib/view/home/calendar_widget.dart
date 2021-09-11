import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:suividevente/controller/event_databases/event_databases.dart';
import 'package:suividevente/model/event_data_source.dart';
import 'package:suividevente/model/event_provider.dart';
import 'package:suividevente/model/my_event.dart';
import 'package:suividevente/utils/constants.dart';
import 'package:suividevente/view/home/components/addEvent/add_event.dart';
import 'package:suividevente/view/layout/layout.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'components/addEvent/tasks_widget.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final databaseReference = FirebaseFirestore.instance;
  EventDataSource? events;

  final _calendarView = CalendarView.month;
  DateTime _initialDate = DateTime.now();
  final _cellBorder = Colors.transparent;
  final _firstDayOfWeek = 1;

  final Locale local = const Locale('fr', 'FR');

  bool menuOpen = false;
  bool visible = false;
  bool visible2 = false;

  double tranx = 0, trany = 0, scale = 1.0;

  @override
  void initState() {
    // TODO: implement initState
    getDataFromFireStore().then((results) {
      SchedulerBinding.instance!.addPostFrameCallback((_intialDate) {
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      transform: Matrix4.translationValues(tranx, trany, 0)..scale(scale),
      child: ZoomIn(
        child: Stack(
          children: [
            Container(
              color: kDefaultBackgroundColor,
              child: LayoutBuilder(
                  builder: (context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: Container(
                      width: size.width,
                      height: size.height,
                      decoration: BoxDecoration(
                        color: kDefaultBackgroundColor,
                        borderRadius: menuOpen
                            ? BorderRadius.circular(20.0)
                            : BorderRadius.circular(0.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          myAppBar(),
                          calendar(),
                          bottomMenu(),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
            Visibility(
              visible: visible,
              child: Container(
                color: kDefaultBackgroundColor,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: const SpinKitChasingDots(
                  color: Colors.white,
                  duration: Duration(milliseconds: 300),
                ),
              ),
            ),
            Visibility(
              visible: visible2,
              child: Container(
                color: kDefaultBackgroundColor,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: const SpinKitChasingDots(
                  color: Colors.white,
                  duration: Duration(milliseconds: 300),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget calendar() {
    return Expanded(
      child: SafeArea(
        child: SfCalendar(
          view: _calendarView,
          timeZone: "Central Europe Standard Time",
          dataSource: events,
          initialSelectedDate: _initialDate,
          cellBorderColor: _cellBorder,
          firstDayOfWeek: _firstDayOfWeek,
          selectionDecoration: BoxDecoration(
            color: _cellBorder,
          ),
          backgroundColor: kDefaultBackgroundColor,
          blackoutDatesTextStyle: const TextStyle(
            color: kWhiteColor,
          ),
          onViewChanged: (details){
            _initialDate = details.visibleDates.first;
            getDataFromFireStore();
          },
          todayTextStyle: const TextStyle(
            color: kWhiteColor,
          ),
          headerHeight: 70,
          headerDateFormat: 'MMMM, yyy',
          headerStyle: const CalendarHeaderStyle(
            textStyle: TextStyle(
              color: kWhiteColor,
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          viewHeaderStyle: ViewHeaderStyle(
            dayTextStyle: TextStyle(
              color: kWhiteColor,
              locale: local,
            ),
          ),
          viewHeaderHeight: 40.0,
          todayHighlightColor: kLightBackgroundColor,
          appointmentBuilder:
              (BuildContext context, CalendarAppointmentDetails details) {
            return Center(
              child: Container(
                color: details.appointments.first.color,
              ),
            );
          },
          monthViewSettings: const MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.none,
              appointmentDisplayCount: 2,
              showTrailingAndLeadingDates: false,
              monthCellStyle: MonthCellStyle(
                trailingDatesTextStyle: TextStyle(color: kLightBackgroundColor),
                textStyle: TextStyle(
                  color: kWhiteColor,
                ),
                leadingDatesTextStyle: TextStyle(color: kLightBackgroundColor),
              )),
          monthCellBuilder:
              (BuildContext buildContext, MonthCellDetails details) {
            if (details.appointments.isNotEmpty) {
              return Container(
                //color: kRedColor,
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 40.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: details.appointments.map((e) {
                          final dynamic occurrenceAppointment = e;
                          return Container(
                            width: 13.0,
                            height: 13.0,
                            margin: const EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              color: occurrenceAppointment.getColor,
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(//Cercle clair au fond
                        color: details.date.day == DateTime.now().day ? const Color(0xFF6485AA).withOpacity(0.3) : Colors.transparent,
                        borderRadius: const BorderRadius.all(Radius.circular(100.0)),
                      ),
                      width: 40.0,
                      height: 40.0,
                      alignment: Alignment.center,
                      child: Text(
                        details.date.day.toString(),
                        style: const TextStyle(
                          color: kWhiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Center(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  details.date.day.toString(),
                  style: const TextStyle(
                    color: kWhiteColor,
                  ),
                ),
              ),
            );
          },
          onTap: (details) async {
            /*final provider = Provider.of<EventProvider>(context, listen: false);
            provider.setDate(details.date!);*/

            if (details.appointments!.isNotEmpty) {
              showModalBottomSheet(
                context: context,
                builder: (context) => TasksWidget(
                  initialDate: details.date!,
                  title: details.appointments!.first.title,
                  events: events!,
                ),
              );
            } else {
              const Text("RAF");
            }
          },
          onLongPress: (details) {
            final provider = Provider.of<EventProvider>(context, listen: false);

            provider.setDate(details.date!);
            showModalBottomSheet(
              context: context,
              builder: (context) => TasksWidget(
                initialDate: details.date!,
                title: details.appointments!.first.title,
                events: events!,
              ),
            );
          },
        ),
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

  Widget bottomMenu() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          myButton(
              "Marché du matin",
              kYellowColor,
              const AddEvent(
                matinOuSoir: "Marché du matin",
              )),
          const SizedBox(
            width: 20.0,
          ),
          myButton(
              "Marché du soir",
              kBlueColor,
              const AddEvent(
                matinOuSoir: "Marché du soir",
              )),
        ],
      ),
    );
  }

  Widget myButton(String title, Color color, nextScreen) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: kLightBackgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                width: 7.0,
                height: 45.0,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.2),
                child: GestureDetector(
                  onTap: () async {

                    if (title.contains("Marché du matin")) {

                      //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddEvent(matinOuSoir: "Marché du matin")));

                      setState(() {
                        visible = !visible;
                      });

                      dontShow("Marché du matin");/// DON'T SHOW

                      Future.delayed(const Duration(seconds: 3), (){
                        Navigator.pushAndRemoveUntil(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (BuildContext context,
                                  Animation animation,
                                  Animation secondaryAnimation) {
                                return const Layout();
                              },
                              transitionDuration:
                              const Duration(milliseconds: 1000),
                              transitionsBuilder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secondaryAnimation,
                                  Widget child) {
                                animation = CurvedAnimation(
                                    curve: Curves.easeInOutCubic,
                                    parent: animation);

                                return ScaleTransition(
                                  scale: animation,
                                  child: child,
                                );
                              },
                            ),
                                (Route route) => false);
                      });
                    } else if (title.contains("Marché du soir")) {
                      //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddEvent(matinOuSoir: "Marché du soir")));
                      setState(() {
                        visible = !visible;
                        visible2 = !visible2;
                      });


                      dontShow("Marché du soir");
                      Future.delayed(const Duration(seconds: 3), (){
                        Navigator.pushAndRemoveUntil(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (BuildContext context,
                                  Animation animation,
                                  Animation secondaryAnimation) {
                                return const Layout();
                              },
                              transitionDuration:
                              const Duration(milliseconds: 1000),
                              transitionsBuilder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secondaryAnimation,
                                  Widget child) {
                                animation = CurvedAnimation(
                                    curve: Curves.easeInOutCubic,
                                    parent: animation);

                                return ScaleTransition(
                                  scale: animation,
                                  child: child,
                                );
                              },
                            ),
                                (Route route) => false);
                      });
                    }
                  },
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: kWhiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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

  dontShow(String whichOne) async {
    var snapShotsValue = await databaseReference
        .collection("events")
        .doc('${_initialDate.month} - ${_initialDate.year}')
        .collection("all")
        .get();

    final allEvents = EventDatabaseService(year: _initialDate.year, month: _initialDate.month).allEvents;

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

    if(whichOne.contains("Marché du matin")){
      for (var i = 0; i < days.length; i++) {
        await EventDatabaseService(eventUid: "Marché du soir")
            .dontShow(false, "isActive", days[i].month, days[i]);
      }
    }else if(whichOne.contains("Marché du soir")){
      for (var i = 0; i < days2.length; i++) {
        await EventDatabaseService(eventUid: "Marché du matin")
            .dontShow(false, "isActive", days[i].month, days[i]);
      }
    }else{
      setState(() {
        visible = !visible;
      });
      for (var i = 0; i < days2.length; i++) {
        await EventDatabaseService(eventUid: "Marché du matin").dontShow(false, "isActive", days[i].month, days[i]);
        await EventDatabaseService(eventUid: "Marché du soir").dontShow(false, "isActive", days[i].month, days[i]);
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

    setState(() {
      events = EventDataSource(list);
    });
  }

  Future<void> getDataFromFireStore() async {
    var snapShotsValue = await databaseReference
        .collection("events")
        .doc('${_initialDate.month} - ${_initialDate.year}')
        .collection("all")
        .get();

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
      events = EventDataSource(list);
    });
  }
}
