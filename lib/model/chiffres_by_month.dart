import 'package:flutter/material.dart';

class ChiffresByMonth{
  String title;
  DateTime cfMonth;
  double chiffres;

  ChiffresByMonth({required this.title, required this.cfMonth, required this.chiffres});

  setChiffres(double newChiffres){
    this.chiffres = newChiffres;
  }

  double get getChiffres => chiffres;
}