import 'package:flutter/material.dart';

class Meteo {
  final String title;
  final IconData icon;
  final Color color;
  bool value;

  Meteo(this.title, this.icon, this.color,{required this.value});

  @override
  String toString() => title;
}