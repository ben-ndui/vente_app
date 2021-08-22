import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:suividevente/model/event_provider.dart';
import 'package:suividevente/utils/constants.dart';
import 'package:suividevente/view/layout/layout.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventProvider(),
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          SfGlobalLocalizations.delegate
        ],
        supportedLocales: const [
          Locale('fr'),
        ],
        locale: const Locale('fr'),
        title: 'Gestionnaire de vente',
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Layout(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}