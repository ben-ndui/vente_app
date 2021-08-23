import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suividevente/model/event_data_source.dart';
import 'package:suividevente/model/event_provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../vente_widget.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({Key? key}) : super(key: key);

  @override
  _TasksWidgetState createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context, listen: false);
    final selectedEvents = provider.eventsOfSelectedDate;

    if (selectedEvents.isEmpty) {
      return const Center(
        child: Text(
          "Vous avez entré aucun évènement !",
        ),
      );
    }
    return SfCalendar(
      view: CalendarView.day,
      dataSource: EventDataSource(provider.events),
      initialDisplayDate: provider.selectedDate,
      appointmentBuilder: appointmentBuilder,
    );
  }

  Widget appointmentBuilder(
      BuildContext context, CalendarAppointmentDetails details) {
    final eventy = details.appointments.first;
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => VenteWidget(selectedEvent: eventy,)));
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
}
