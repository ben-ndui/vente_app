import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:suividevente/controller/event_databases/event_databases.dart';
import 'package:suividevente/controller/event_provider_data/event_provider_data.dart';
import 'package:suividevente/model/event_data_source.dart';
import 'package:suividevente/model/event_provider.dart';
import 'package:suividevente/model/my_event.dart';
import 'package:suividevente/model/product.dart';
import 'package:suividevente/utils/constants.dart';
import 'package:suividevente/view/home/components/addEvent/add_event.dart';
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
  final _initialDate = DateTime.now();
  final _cellBorder = Colors.transparent;
  final _firstDayOfWeek = 1;

  final Locale local = const Locale('fr', 'FR');

  bool menuOpen = false;
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
        child: Container(
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
                  child: SafeArea(
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
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget calendar() {
    return Expanded(
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
              height: 30.0,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    details.date.day.toString(),
                    style: const TextStyle(
                      color: kWhiteColor,
                    ),
                  ),
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
                          height: 15.0,
                          margin: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            color: occurrenceAppointment.getColor,
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                        );
                      }).toList(),
                    ),
                  )
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
          if (details.appointments!.isNotEmpty) {
            await EventDatabaseService().updateEvent(
              details.appointments!.first.uid,
              details.appointments!.first.title,
              details.appointments!.first.description,
              details.appointments!.first.from,
              details.appointments!.first.to,
              details.appointments!.first.color.value,
              details.appointments!.first.isAllDay,
              details.appointments!.first.sun,
              details.appointments!.first.cloud,
              details.appointments!.first.tint,
              details.appointments!.first.pooCloud,
              details.appointments!.first.cloudSomething,
              details.appointments!.first.panierCount,
            );
            showModalBottomSheet(
              context: context,
              builder: (context) => TasksWidget(
                initialDate: details.date!, title: details.appointments!.first.title,
              ),
            );
          } else {
            Text("RAF");
          }
        },
        onLongPress: (details) {
          final provider = Provider.of<EventProvider>(context, listen: false);

          provider.setDate(details.date!);
          showModalBottomSheet(
              context: context,
              builder: (context) => TasksWidget(
                    initialDate: details.date!, title: details.appointments!.first.uid,
                  ));
        },
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
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => nextScreen));
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

  Future<void> getDataFromFireStore() async {
    var snapShotsValue = await databaseReference.collection("events").get();

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
      );
    }).toList();
    setState(() {
      events = EventDataSource(list);
    });
  }
}
