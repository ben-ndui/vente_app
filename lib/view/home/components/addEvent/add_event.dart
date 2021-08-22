import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:suividevente/model/event_provider.dart';
import 'package:suividevente/model/meteo.dart';
import 'package:suividevente/model/my_event.dart';
import 'package:suividevente/model/product.dart';
import 'package:suividevente/utils/constants.dart';
import 'package:suividevente/utils/utils.dart';

class AddEvent extends StatefulWidget {
  final String matinOuSoir;
  final MyEvent? event;

  const AddEvent({Key? key, this.event, required this.matinOuSoir}) : super(key: key);

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  List<Meteo> meteo = [];
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController titleController;

  late DateTime fromD;
  late DateTime toD;

  bool _sun = false;
  bool _cloud = false;
  bool _tint = false;
  bool _pooStorm = false;
  bool _cloudMeatball = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    titleController = TextEditingController(text: widget.matinOuSoir);

    if (widget.event == null) {
      fromD = DateTime.now();
      toD = DateTime.now().add(const Duration(hours: 2));
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDefaultBackgroundColor,
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Image.asset(
            "assets/background/back1.jpeg",
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: const CloseButton(
                        color: kDefaultBackgroundColor,
                      ),
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    Row(
                      children: buildEditingActions(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 5,
              ),
              Center(
                child: Container(
                  width: 400.0,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: const [
                      BoxShadow(
                          color: kWhiteColor,
                          blurRadius: 8.0,
                          spreadRadius: 1.0),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildTitle(),
                        const SizedBox(
                          height: 12.0,
                        ),
                        buildDateTimePickers(),
                        const SizedBox(
                          height: 12.0,
                        ),
                        buildMeteo(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  List<Widget> buildEditingActions() {
    return [
      ElevatedButton.icon(
        onPressed: () => saveEventForm(),
        icon: const FaIcon(FontAwesomeIcons.check),
        label: const Text("Sauvegarder"),
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
      )
    ];
  }

  Widget buildTitle() {
    return TextFormField(
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 24),
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        hintText: 'Ajouter un titre',
      ),
      onFieldSubmitted: (_){},
      validator: (title) => title != null && title.isEmpty
          ? "Veuillez ajouter un titre s'il vous plait"
          : null,
      controller: titleController,
    );
  }

  Widget buildMeteo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Ajouter une météo",
            textAlign: TextAlign.center, style: TextStyle(fontSize: 24)),
        const SizedBox(
          height: 12.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildMeteoButton(FontAwesomeIcons.sun, "sun", _sun),
            buildMeteoButton(FontAwesomeIcons.cloud, "cloud", _cloud),
            buildMeteoButton(FontAwesomeIcons.tint, "tint", _tint),
            buildMeteoButton(FontAwesomeIcons.pooStorm, "pooStorm", _pooStorm),
            buildMeteoButton(FontAwesomeIcons.cloudMeatball, "cloudMeatball",
                _cloudMeatball),
          ],
        ),
      ],
    );
  }

  IconButton buildMeteoButton(IconData icon, String name, bool value) {
    return IconButton(
      onPressed: () {
        switch (name) {
          case "sun":
            setState(() {
              _sun = !_sun;
              final mete = Meteo("sun", FontAwesomeIcons.sun, _sun ? kYellowColor : kGreyColor, value: _sun);
              _sun ? meteo.add(mete) : meteo.remove(mete);
            });
            break;
          case "cloud":
            setState(() {
              _cloud = !_cloud;
              final mete = Meteo("cloud", FontAwesomeIcons.cloud, _cloud ? kYellowColor : kGreyColor, value: _cloud);
              _cloud ? meteo.add(mete) : meteo.remove(mete);
            });
            break;
          case "tint":
            setState(() {
              _tint = !_tint;
              final mete = Meteo("tint",FontAwesomeIcons.tint, _tint ? kYellowColor : kGreyColor, value: _tint);
              _tint ? meteo.add(mete) : meteo.remove(mete);
            });
            break;
          case "pooStorm":
            setState(() {
              _pooStorm = !_pooStorm;
              final mete = Meteo("pooStorm", FontAwesomeIcons.pooStorm, _pooStorm ? kYellowColor : kGreyColor, value: _pooStorm);
              _pooStorm ? meteo.add(mete) : meteo.remove(mete);
            });
            break;
          case "cloudMeatball":
            setState(() {
              _cloudMeatball = !_cloudMeatball;
              final mete = Meteo("cloudMeatball", FontAwesomeIcons.cloudMeatball, _cloudMeatball ? kYellowColor : kGreyColor, value: _cloudMeatball);
              _cloudMeatball ? meteo.add(mete) : meteo.remove(mete);
            });
            break;
        }
      },
      icon: FaIcon(
        icon,
        color: value ? kYellowColor : kDefaultBackgroundColor,
      ),
    );
  }

  Widget buildDateTimePickers() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildFrom(),
        buildTo(),
      ],
    );
  }

  Widget buildFrom() {
    return buildHeader(
      header: "De :",
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: buildDropDownField(
              text: Utils.toDate(fromD),
              onClicked: () => pickFromDateTime(pickDate: true),
            ),
          ),
          Expanded(
            child: buildDropDownField(
              text: Utils.toTime(fromD),
              onClicked: () => pickFromDateTime(pickDate: false),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTo() {
    return buildHeader(
      header: "À :",
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: buildDropDownField(
              text: Utils.toDate(toD),
              onClicked: () => pickToDateTime(pickDate: true),
            ),
          ),
          Expanded(
            child: buildDropDownField(
              text: Utils.toTime(toD),
              onClicked: () => pickToDateTime(pickDate: false),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropDownField(
      {required String text, required Null Function() onClicked}) {
    return ListTile(
      title: Text(text),
      trailing: const FaIcon(FontAwesomeIcons.sortDown),
      onTap: onClicked,
    );
  }

  Widget buildHeader({required String header, required Row child}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(header),
        child,
      ],
    );
  }

  pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromD, pickDate: pickDate);

    if (date == null) return null;

    if (date.isAfter(toD)) {
      toD = DateTime(date.year, date.month, date.day, toD.hour, toD.minute);
    }

    setState(() {
      fromD = date;
    });
  }

  pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(
      toD,
      pickDate: pickDate,
      firstDate: pickDate ? fromD : null,
    );

    if (date == null) return null;

    setState(() {
      toD = date;
    });
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2015, 8),
        lastDate: DateTime(2101),
      );
      if (date == null) return null;

      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);

      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (timeOfDay == null) return null;

      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

      return date.add(time);
    }
  }

  saveEventForm() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      if(widget.matinOuSoir.contains("matin")){
        final MyEvent event = MyEvent(
          titleController.text,
          kYellowColor,
          "Marté du matin",
          fromD,
          toD,
          false,
        );

        final provider = Provider.of<EventProvider>(context, listen: false);

        setState(() {
          event.meteo1 = _sun;
          event.meteo2 = _cloud;
          event.meteo3 = _tint;
          event.meteo4 = _pooStorm;
          event.meteo4 = _cloudMeatball;
        });

        provider.addEvent(event);
        Navigator.of(context).pop();
      }

      if(widget.matinOuSoir.contains("soir")){
        final event = MyEvent(
          titleController.text,
          kBlueColor,
          "Marté du soir",
          fromD,
          toD,
          false,
        );

        final product1 = Product(title: "Pull en laine", price: "30.90", img: "assets/background/back1.jpeg");
        final product2 = Product(title: "Pull en cuir", price: "90.90", img: "assets/background/back1.jpeg");
        final product3 = Product(title: "Pull en bois", price: "123.90", img: "assets/background/back1.jpeg");

        event.listProduit.add(product1);
        event.listProduit.add(product2);
        event.listProduit.add(product3);

        final provider = Provider.of<EventProvider>(context, listen: false);

        provider.addEvent(event);
        Navigator.of(context).pop();
      }
    }
  }
}
