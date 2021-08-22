import 'package:flutter/material.dart';

import 'my_event.dart';

class EventProvider extends ChangeNotifier{

  final List<MyEvent> _events = [];

  List<MyEvent> get events => _events;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime newDate) => _selectedDate = newDate;

  List<MyEvent> get eventsOfSelectedDate => _events;

  void addEvent(MyEvent event){
    _events.add(event);

    notifyListeners();
  }

  void setEvent(MyEvent event){
    if(_events.contains(event)){
      for (var event2 in _events) {
        if(event2.title == event.title){
          event2.panier = event.panier;
        }
      }
    }
    notifyListeners();
  }

}