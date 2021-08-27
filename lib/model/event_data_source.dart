import 'package:flutter/material.dart';
import 'package:suividevente/utils/constants.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'my_event.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<MyEvent> appointments) {
    this.appointments = appointments;
  }

  MyEvent getEvent(int index) => appointments![index] as MyEvent;

  @override
  DateTime getStartTime(int index) {
    // TODO: implement getStartTime
    return getEvent(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    // TODO: implement getEndTime
    return getEvent(index).to;
  }

  @override
  String getSubject(int index) {
    // TODO: implement getSubject
    return getEvent(index).title;
  }

  @override
  Color getColor(int index) {
    // TODO: implement getColor
    return getEvent(index).panier.isEmpty &&
            getEvent(index).sun == false &&
            getEvent(index).cloud == false &&
            getEvent(index).tint == false &&
            getEvent(index).pooCloud == false &&
            getEvent(index).cloudSomething == false
        ? getEvent(index).color
        : kLightBackgroundColor;
  }

  @override
  bool isAllDay(int index) {
    // TODO: implement isAllDay
    return getEvent(index).isAllDay;
  }
}
