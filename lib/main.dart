import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:suividevente/controller/event_databases/event_databases.dart';
import 'package:suividevente/controller/event_provider_data/event_provider_data.dart';
import 'package:suividevente/controller/product_databases/product_database.dart';
import 'package:suividevente/model/event_provider.dart';
import 'package:suividevente/model/product.dart';
import 'package:suividevente/view/layout/layout.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

import 'model/my_event.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventProvider(),
      child: MultiProvider(
        providers: [
          Provider<ProductDatabaseService>(
              create: (_) => ProductDatabaseService()),
          StreamProvider.value(
            value: ProductDatabaseService(uid: "").allProducts,
            initialData: [],
          ),
          StreamProvider.value(
            value: EventProviderData().allEventsByDay,
            initialData: [],
          ),
          Provider<EventProvider>(
              create: (_) => EventProvider()),
        ],
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
      ),
    );
  }
}
