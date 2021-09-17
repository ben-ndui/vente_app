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
import 'components/vente_widget.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final databaseReference = FirebaseFirestore.instance;
  final CalendarController _calendarController = CalendarController();
  EventDataSource? events;

  final _calendarView = CalendarView.month;
  DateTime _initialDate = DateTime.now();
  final _cellBorder = Colors.transparent;
  final _firstDayOfWeek = 1;

  final Locale local = const Locale('fr', 'FR');

  bool menuOpen = false;
  bool visible = false;
  bool visible2 = false;
  bool mat = false;
  bool soi = false;

  List<MyEvent> marchesDuJour = [];

  DateTime isSelected = DateTime.now();
  MyEvent? selectedEvent;

  double tranx = 0, trany = 0, scale = 1.0;

  @override
  void initState() {
    // TODO: implement initState
    getDataFromFireStore().then((results) {
      SchedulerBinding.instance!.addPostFrameCallback((_intialDate) {
        setState(() {});
      });
    });
    getMarketOfTheDay();
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
                          Expanded(
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                calendar(),
                                buildPreviousAndNextButton(),
                              ],
                            ),
                          ),
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

  Container buildPreviousAndNextButton() {
    return Container(
      margin: const EdgeInsets.only(top: 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(30, 20, 0, 20),
            child: TextButton.icon(
              icon: const FaIcon(
                FontAwesomeIcons.chevronLeft,
                color: kWhiteColor,
              ),
              label: const Text(''),
              onPressed: () {
                _calendarController.backward!();
              },
            ),
          ),
          const SizedBox(
            width: 130.0,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(70, 20, 0, 20),
            child: TextButton.icon(
              label: const Text(''),
              icon: const FaIcon(
                FontAwesomeIcons.chevronRight,
                color: kWhiteColor,
              ),
              onPressed: () {
                _calendarController.forward!();
              },
            ),
          ),
          const SizedBox(
            width: 25.0,
          ),
        ],
      ),
    );
  }

  getMarketOfTheDay() {
    final eventOfDay = EventDatabaseService(month: _initialDate.month, year: _initialDate.year).allEvents;
    marchesDuJour.clear();

    eventOfDay.forEach((all) {
      for (var ev in all) {
        if (ev.from.day == DateTime.now().day) {
          setState(() {
            marchesDuJour.add(ev);
          });
        }
      }
    });
  }

  Widget calendar() {
    return SafeArea(
      child: StreamBuilder<List<MyEvent>>(
          stream: EventDatabaseService(
                  month: _initialDate.month, year: _initialDate.year)
              .allEvents,
          builder: (context, snapshot) {
            final marketOfTheDay = snapshot.data;

            return SfCalendar(
              controller: _calendarController,
              view: _calendarView,
              timeZone: "Central Europe Standard Time",
              dataSource: events,
              initialSelectedDate: _initialDate,
              cellBorderColor: _cellBorder,
              firstDayOfWeek: _firstDayOfWeek,
              showNavigationArrow: false,
              selectionDecoration: BoxDecoration(
                color: _cellBorder,
              ),
              backgroundColor: kDefaultBackgroundColor,
              blackoutDatesTextStyle: const TextStyle(
                color: kWhiteColor,
              ),
              onViewChanged: (details) {
                _initialDate = details.visibleDates.first;
                getDataFromFireStore();
              },
              todayTextStyle: const TextStyle(
                color: kWhiteColor,
              ),
              headerHeight: 70,
              scheduleViewMonthHeaderBuilder: (BuildContext buildContext,
                  ScheduleViewMonthHeaderDetails details) {
                return Container(
                  color: Colors.red,
                  child: Text(
                    details.date.month.toString() +
                        ' ,' +
                        details.date.year.toString(),
                  ),
                );
              },
              headerStyle: const CalendarHeaderStyle(
                backgroundColor: kDefaultBackgroundColor,
                textStyle: TextStyle(
                  color: kWhiteColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              headerDateFormat: 'MMMM, yyy',
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
                    color: selectedEvent!.getColor,
                  ),
                );
              },
              monthViewSettings: const MonthViewSettings(
                  appointmentDisplayMode: MonthAppointmentDisplayMode.none,
                  appointmentDisplayCount: 2,
                  showTrailingAndLeadingDates: false,
                  monthCellStyle: MonthCellStyle(
                    trailingDatesTextStyle:
                        TextStyle(color: kLightBackgroundColor),
                    textStyle: TextStyle(
                      color: kWhiteColor,
                    ),
                    leadingDatesTextStyle:
                        TextStyle(color: kLightBackgroundColor),
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
                          decoration: BoxDecoration(
                            //Cercle clair au fond
                            color: details.date.day == isSelected.day
                                ? const Color(0xFF6485AA).withOpacity(0.3)
                                : Colors.transparent,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100.0)),
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
                final provider =
                    Provider.of<EventProvider>(context, listen: false);
                provider.setDate(details.date!);

                marchesDuJour.clear();

                for (var ev in marketOfTheDay!) {
                  if (ev.from.day == details.date!.day) {
                    setState(() {
                      marchesDuJour.add(ev);
                    });
                  }
                }

                ///print(details.date!);
                ///print(marchesDuJour);
                ///print(marchesDuJour[0].sun);
                ///print(marchesDuJour[1].sun);

                setState(() {
                  isSelected = details.date!;
                  _initialDate = isSelected;
                  if (mat) {
                    selectedEvent = details.appointments!.first;
                  } else {
                    selectedEvent = details.appointments!.last;
                  }
                });

                //print(details.appointments!.first.panier.length);

                /*if (details.appointments!.isNotEmpty) {
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
              }*/
              },
              onLongPress: (details) {
                final provider =
                    Provider.of<EventProvider>(context, listen: false);

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
            );
          }),
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
                    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddEvent(matinOuSoir: "Marché du soir")));

                    if (marchesDuJour.isNotEmpty) {
                      if (title.contains("Marché du matin")) {
                        print("Voie 1");

                        await EventDatabaseService().updateEvent(
                          marchesDuJour[0].from,
                          marchesDuJour[0].title,
                          marchesDuJour[0].description,
                          marchesDuJour[0].from,
                          marchesDuJour[0].to,
                          marchesDuJour[0].color.value,
                          marchesDuJour[0].isAllDay,
                          marchesDuJour[0].sun,
                          marchesDuJour[0].cloud,
                          marchesDuJour[0].tint,
                          marchesDuJour[0].pooCloud,
                          marchesDuJour[0].cloudSomething,
                          marchesDuJour[0].panierCount,
                          marchesDuJour[0].month,
                          marchesDuJour[0].isActive,
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => VenteWidget(
                              selectedEvent: marchesDuJour[0],
                              title: title,
                            ),
                          ),
                        );
                      } else {
                        print("Voie 2");

                        await EventDatabaseService().updateEvent(
                          marchesDuJour[1].from,
                          marchesDuJour[1].title,
                          marchesDuJour[1].description,
                          marchesDuJour[1].from,
                          marchesDuJour[1].to,
                          marchesDuJour[1].color.value,
                          marchesDuJour[1].isAllDay,
                          marchesDuJour[1].sun,
                          marchesDuJour[1].cloud,
                          marchesDuJour[1].tint,
                          marchesDuJour[1].pooCloud,
                          marchesDuJour[1].cloudSomething,
                          marchesDuJour[1].panierCount,
                          marchesDuJour[1].month,
                          marchesDuJour[1].isActive,
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => VenteWidget(
                              selectedEvent: marchesDuJour[1],
                              title: title,
                            ),
                          ),
                        );
                      }
                    } else {
                      selectDatePopup();
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

  Future<void> selectDatePopup() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: const [
              FaIcon(
                FontAwesomeIcons.exclamationCircle,
                color: kRedColor,
              ),
              SizedBox(
                width: 4.0,
              ),
              Text(
                'ATTENTION ',
                style: TextStyle(fontWeight: FontWeight.bold, color: kRedColor),
              ),
            ],
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  "Veuillez sélectionner une date s'il vous plait !",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kDefaultBackgroundColor),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Je sélectionne une date !'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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

    final allEvents =
        EventDatabaseService(year: _initialDate.year, month: _initialDate.month)
            .allEvents;

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
        await EventDatabaseService(eventUid: "Marché du soir")
            .dontShow(false, "isActive", days[i].month, days[i]);
      }
    } else if (whichOne.contains("Marché du soir")) {
      for (var i = 0; i < days2.length; i++) {
        await EventDatabaseService(eventUid: "Marché du matin")
            .dontShow(false, "isActive", days[i].month, days[i]);
      }
    } else {
      setState(() {
        visible = !visible;
      });
      for (var i = 0; i < days2.length; i++) {
        await EventDatabaseService(eventUid: "Marché du matin")
            .dontShow(false, "isActive", days[i].month, days[i]);
        await EventDatabaseService(eventUid: "Marché du soir")
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
