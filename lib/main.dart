import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:suividevente/controller/event_databases/event_databases.dart';
import 'package:suividevente/controller/event_provider_data/event_provider_data.dart';
import 'package:suividevente/controller/product_databases/product_database.dart';
import 'package:suividevente/model/event_data_source.dart';
import 'package:suividevente/model/event_provider.dart';
import 'package:suividevente/model/my_event.dart';
import 'package:suividevente/utils/constants.dart';
import 'package:suividevente/view/layout/layout.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

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
    return StreamBuilder<List<MyEvent>>(
        stream: EventDatabaseService().allEvents,
        builder: (context, snapshot) {
          return ChangeNotifierProvider(
            create: (context) => EventProvider(),
            child: MultiProvider(
              providers: [
                Provider<ProductDatabaseService>(
                    create: (_) => ProductDatabaseService()),
                StreamProvider.value(
                  value: ProductDatabaseService(uid: "").allProducts,
                  initialData: const [],
                ),
                StreamProvider.value(
                  value: EventProviderData().allEventsByDay,
                  initialData: const [],
                ),
                StreamProvider.value(
                  value: EventDatabaseService().allPanier,
                  initialData: const [],
                ),
                Provider<EventDataSource>(
                    create: (_) => EventDataSource(snapshot.data!)),
                Provider<EventDatabaseService>(
                    create: (_) => EventDatabaseService()),
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
                  backgroundColor: kDefaultBackgroundColor,
                ),
                home: AnimatedSplashScreen(
                  backgroundColor: kDefaultBackgroundColor,
                  nextScreen: const Layout(),
                  splash: Container(
                    color: kDefaultBackgroundColor,
                    width: 300.0,
                    height: 300.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        SpinKitRipple(color: Colors.white),
                      ],
                    ),
                  ),
                ),
                debugShowCheckedModeBanner: false,
              ),
            ),
          );
        });
  }
}
