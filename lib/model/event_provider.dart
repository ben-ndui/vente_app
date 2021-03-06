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

  MyEvent? getEvent(String title){
    for (var element in _events) {
      if(element.title.contains(title)){
        return element;
      }else{
        return null;
      }
    }
  }

  void setEvent(MyEvent event){
    if(_events.contains(event)){
      _events.where((element){
        if(element.title.contains(event.title)){
          element.panier = event.panier;
          return true;
        }
        return true;
      });
    }
    notifyListeners();
  }

}