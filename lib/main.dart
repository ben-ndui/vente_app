import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:suividevente/view/layout/layout.dart';

import 'view/home/home.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestionnaire de vente',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Layout(),
      debugShowCheckedModeBanner: false,
    );
  }
}