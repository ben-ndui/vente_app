import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:suividevente/model/product.dart';
import 'package:suividevente/utils/constants.dart';
import 'package:suividevente/utils/utils.dart';
import 'package:table_calendar/table_calendar.dart';

class Home extends StatefulWidget {
  final String title;

  const Home({Key? key, required this.title}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Event matin = Event("Matin", kYellowColor);
  Event soir = Event("Soir", kBlueColor);

  TextEditingController prodname = TextEditingController();
  TextEditingController prodprice = TextEditingController();
  TextEditingController prodimg = TextEditingController();

  String? _nameprod;
  String? _priceprod;

  final List<Event> _selectedEvent = [];

  bool menuOpen = false;
  double tranx = 0, trany = 0, scale = 1.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadEvent();
  }

  _loadEvent() {
    _selectedEvent.add(matin);
    _selectedEvent.add(soir);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      transform: Matrix4.translationValues(tranx, trany, 0)..scale(scale),
      child: Scaffold(
        backgroundColor: kDefaultBackgroundColor,
        body: LayoutBuilder(
            builder: (context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  myAppBar(),
                  const SizedBox(height: 20.0),
                  calendar(),
                  const SizedBox(height: 30.0),
                  bottomMenu(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Padding bottomMenu() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          myButton("Marché du matin", kYellowColor, () {
            myDialog("Ajouter un produit", matin);
          }),
          const SizedBox(width: 30.0),
          myButton("Marché du soir", kBlueColor, () {
            myDialog("Ajouter un produit au soir", soir);
          }),
        ],
      ),
    );
  }

  myDialog(String title, prodList) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              textFormField(
                  "Nom de l'article", FontAwesomeIcons.tags, prodname),
              const SizedBox(height: 20.0),
              textFormField(
                  "Prix de l'article", FontAwesomeIcons.barcode, prodprice),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              final product = Product(
                  title: _nameprod!.trim(), price: _priceprod!.trim(), img: "");
              prodList.prodList.add(product);
              Navigator.of(context).pop();
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  TextFormField textFormField(
      String label, IconData icon, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.center,
      onChanged: (value) {
        if (label.contains("Nom de l'article")) {
          setState(() {
            _nameprod = value;
          });
        } else if (label.contains("Prix de l'article")) {
          _priceprod = value;
        }
      },
      validator: (value) {
        return value != null ? null : "Veuillez entrer une value";
      },
      decoration: InputDecoration(
        icon: FaIcon(icon),
        label: Text(label),
      ),
    );
  }

  Padding myAppBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          !menuOpen
              ? TextButton(
                  onPressed: () {
                    scale = 0.6;
                    tranx = 200;
                    trany = 100;
                    setState(() {
                      menuOpen = true;
                    });
                  },
                  child: const FaIcon(
                    FontAwesomeIcons.bars,
                    color: kWhiteColor,
                  ),
                )
              : TextButton(
                  onPressed: () {
                    scale = 1.0;
                    tranx = 0;
                    trany = 0;
                    setState(() {
                      menuOpen = false;
                    });
                  },
                  child: const FaIcon(
                    FontAwesomeIcons.arrowLeft,
                    color: kWhiteColor,
                  ),
                ),
          const SizedBox(
            width: 10.0,
          ),
          const Text(
            "Calendriers",
            style: TextStyle(color: kWhiteColor),
          ),
        ],
      ),
    );
  }

  Widget myButton(String title, Color color, onPressed) {
    var size = MediaQuery.of(context).size;
    return Expanded(
      child: TextButton(
        onPressed: onPressed,
        child: Container(
          color: kDarkGreyColor,
          height: 35.0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color,
                ),
                width: 8.0,
                height: size.height,
                child: const Text(""),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: kWhiteColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget calendar() {
    return TableCalendar(
      locale: 'fr_FR',
      headerStyle: headerStyle(),
      firstDay: kFirstDay,
      lastDay: kLastDay,
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: selectedDayPredicate,
      onDaySelected: onDaySelected,
      onFormatChanged: _onFormatChanged,
      onPageChanged: _onPageChange,
      calendarBuilders: calendarBuilders(),
      calendarStyle: const CalendarStyle(
        markersMaxCount: 2,
      ),
      eventLoader: (day) {
        return _selectedEvent;
      },
    );
  }

  bool selectedDayPredicate(day) {
    // Use `selectedDayPredicate` to determine which day is currently selected.
    // If this returns true, then `day` will be marked as selected.

    // Using `isSameDay` is recommended to disregard
    // the time-part of compared DateTime objects.
    return isSameDay(_selectedDay, day);
  }

  void onDaySelected(selectedDay, focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      // Call `setState()` when updating the selected day
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  void _onFormatChanged(format) {
    if (_calendarFormat != format) {
      // Call `setState()` when updating calendar format
      setState(() {
        _calendarFormat = format;
      });
    }
  }

  void _onPageChange(focusedDay) {
    // No need to call `setState()` here
    setState(() {
      _focusedDay = focusedDay;
    });
  }

  CalendarBuilders<Event> calendarBuilders() {
    return CalendarBuilders(
      markerBuilder: (context, day, events) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: events.map((e) {
            return Container(
              width: 10.0,
              height: 10.0,
              margin: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                  color: (e.title.contains("Matin") && e.prodList.isEmpty) ||
                          (e.title.contains("Soir") && e.prodList.isEmpty)
                      ? kDarkGreyColor
                      : e.color,
                  borderRadius: BorderRadius.circular(100.0)),
            );
          }).toList(),
        );
      },
      dowBuilder: (context, day) {
        final text = DateFormat.E("fr_FR").format(day);
        return Center(
          child: Text(
            text.replaceFirst(
              text.substring(0, 1),
              text.substring(0, 1).toUpperCase(),
            ),
            style: const TextStyle(color: kWhiteColor),
          ),
        );
      },
    );
  }

  HeaderStyle headerStyle() {
    return const HeaderStyle(
      titleCentered: true,
      formatButtonVisible: false,
      titleTextStyle: TextStyle(
        color: kWhiteColor,
      ),
    );
  }
}
