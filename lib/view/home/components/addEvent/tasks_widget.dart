import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:suividevente/model/event_data_source.dart';
import 'package:suividevente/model/my_event.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../vente_widget.dart';

class TasksWidget extends StatefulWidget {
  final DateTime initialDate;
  final String title;
  final EventDataSource events;


  const TasksWidget({Key? key, required this.initialDate, required this.title, required this.events})
      : super(key: key);

  @override
  _TasksWidgetState createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  final databaseReference = FirebaseFirestore.instance;
  EventDataSource? events;

  late DateTime _initD;

  @override
  void initState() {
    // TODO: implement initState
    _initD = widget.initialDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: SfCalendar(
        view: CalendarView.day,
        dataSource: widget.events,
        initialDisplayDate: _initD,
        appointmentBuilder: appointmentBuilder,
      ),
    );

    /*return StreamBuilder<List<MyEvent>>(
        stream: EventDatabaseService().allEvents,
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return const Center(
              child: Text("Aucun évènement à charger pour ce jour !"),
            );
          }
          return FadeIn(
            child: SfCalendar(
              view: CalendarView.day,
              dataSource: EventDataSource(snapshot.data!),
              initialDisplayDate: snapshot.data!.first.from,
              appointmentBuilder: appointmentBuilder,
            ),
          );
        }
    );*/
  }

  Widget appointmentBuilder(
      BuildContext context, CalendarAppointmentDetails details) {
    final eventy = details.appointments.first;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VenteWidget(
              selectedEvent: eventy,
              title: widget.title,
            ),
          ),
        );
      },
      child: Container(
        width: details.bounds.width,
        height: details.bounds.height,
        decoration: BoxDecoration(
          color: eventy.color,
        ),
        child: Center(
          child: Text(
            eventy.title,
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Future<void> getDataFromFireStore() async {
    var snapShotsValue = await databaseReference.collection("events").get();

    List<MyEvent> list = snapShotsValue.docs.map((e) {
      return MyEvent(
        e.data()['uid'].toDate(),
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
      );
    }).toList();
    setState(() {
      events = EventDataSource(list);
    });
  }
}
