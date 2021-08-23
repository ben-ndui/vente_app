import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:suividevente/model/event_provider.dart';
import 'package:suividevente/model/meteo.dart';
import 'package:suividevente/model/my_event.dart';
import 'package:suividevente/model/product.dart';
import 'package:suividevente/utils/constants.dart';
import 'package:suividevente/utils/utils.dart';

class VenteWidget extends StatefulWidget {
  final MyEvent selectedEvent;

  const VenteWidget({Key? key, required this.selectedEvent}) : super(key: key);

  @override
  _VenteWidgetState createState() => _VenteWidgetState();
}

class _VenteWidgetState extends State<VenteWidget>
    with SingleTickerProviderStateMixin {
  bool menuOpen = false;
  bool delprod = false;
  bool openPrice = false;
  double tranx = 0, trany = 0, scale = 1.0;

  bool reverse = false, reverse1 = false;

  List<Meteo> meteo = [];
  List<Product> panier = [];

  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this)
      ..addListener(() => setState(() {}));
    animation = Tween(begin: 400.0, end: 0.0).animate(controller);
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kDefaultBackgroundColor,
      body: SafeArea(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            leftPanel(size),
            rightPanel(context),
          ],
        ),
      ),
    );
  }

  Widget rightPanel(BuildContext context) {
    return SizedBox(
      width: 250.0,
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          delprod = !delprod;
                        });
                      },
                      icon: delprod
                          ? const FaIcon(
                              FontAwesomeIcons.moneyBillAlt,
                              color: Colors.green,
                            )
                          : const FaIcon(
                              FontAwesomeIcons.trashAlt,
                              color: kWhiteColor,
                            )),
                ),
                decoration: const BoxDecoration(
                  color: kLightBackgroundColor,
                  border: Border(
                    bottom: BorderSide(
                      color: kGreyColor,
                      width: 0.2,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: 250.0,
                    height: MediaQuery.of(context).size.height,
                    color: kLightBackgroundColor,
                    padding: const EdgeInsets.all(12.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.selectedEvent.panier.length,
                      itemBuilder: (context, index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          child: Card(
                            elevation: 0.0,
                            color: kLightBackgroundColor,
                            child: ListTile(
                              leading: Text(
                                "${widget.selectedEvent.panier[index].nbProd == 0 ? widget.selectedEvent.panier[index].nbProd = 1 : widget.selectedEvent.panier[index].nbProd}",
                                style: const TextStyle(color: kWhiteColor),
                              ),
                              title: Text(
                                widget.selectedEvent.panier[index].title,
                                style: const TextStyle(color: kWhiteColor),
                              ),
                              trailing: delprod
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          widget.selectedEvent.panier[index]
                                              .nbProd = widget.selectedEvent
                                                  .panier[index].nbProd -
                                              1;
                                          if (widget.selectedEvent.panier[index]
                                                  .nbProd ==
                                              0) {
                                            widget.selectedEvent.panier.remove(
                                                widget.selectedEvent
                                                    .panier[index]);
                                          }
                                        });
                                      },
                                      icon: const FaIcon(
                                        FontAwesomeIcons.times,
                                        color: kRedColor,
                                      ))
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (openPrice)
            SlideInRight(
              child: Padding(
                padding: const EdgeInsets.only(right: 0.0, bottom: 20.0),
                child: Container(
                  width: 130.0,
                  height: 60.0,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: kBtnSelectedColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: kLightBackgroundColor,
                        spreadRadius: 8.0,
                        blurRadius: 8.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                          },
                          child: const FaIcon(
                            FontAwesomeIcons.wallet,
                            color: kWhiteColor,
                            size: 30.0,
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          widget.selectedEvent.getTotalPanier() +
                              "€".toUpperCase(),
                          style: const TextStyle(
                              fontSize: 20.0, color: kWhiteColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 0.0, bottom: 20.0),
              child: Container(
                width: 60.0,
                height: 60.0,
                alignment: Alignment.center,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      openPrice = !openPrice;
                    });
                    Future.delayed(const Duration(seconds: 3), (){
                      setState(() {
                        openPrice = !openPrice;
                      });
                    });
                  },
                  icon: const FaIcon(
                    FontAwesomeIcons.caretLeft,
                    color: kDefaultBackgroundColor,
                    size: 40.0,
                  ),
                ),
                decoration: const BoxDecoration(
                  color: kLightBackgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                      color: kLightBackgroundColor,
                      spreadRadius: 8.0,
                      blurRadius: 8.0,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /*Padding(
  padding: const EdgeInsets.only(right: 0.0, bottom: 20.0),
  child: Container(
  width: 60.0,
  height: 60.0,
  color: kBtnSelectedColor,
  alignment: Alignment.center,
  child: const FaIcon(FontAwesomeIcons.caretLeft, color: kDefaultBackgroundColor, size: 30.0,),
  ),
  )*/

  sortList() {
    int i;
    for (i = 0; i < widget.selectedEvent.listProduit.length; i++) {
      if (widget.selectedEvent.listProduit[i].title
          .contains(widget.selectedEvent.listProduit[i + 1].title)) {}
    }
  }

  Widget leftPanel(Size size) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            myAppBar(),
            Container(
              width: size.width,
              height: size.height,
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: widget.selectedEvent.listProduit.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      final provider =
                          Provider.of<EventProvider>(context, listen: false);

                      setState(() {
                        if (widget.selectedEvent.panier.contains(
                            widget.selectedEvent.listProduit[index])) {
                          widget.selectedEvent.panier[index].nbProd += 1;
                        } else {
                          widget.selectedEvent.panier
                              .add(widget.selectedEvent.listProduit[index]);
                        }
                      });
                      provider.setEvent(widget.selectedEvent);
                    },
                    child: SizedBox(
                      width: 300.0,
                      height: 100.0,
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image.asset(
                              widget.selectedEvent.listProduit[index].img,
                              fit: BoxFit.cover,
                              width: size.width,
                              height: 115.0,
                            ),
                            const SizedBox(
                              height: 6.0,
                            ),
                            Text(
                              widget.selectedEvent.listProduit[index].title,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: widget.selectedEvent
                                            .listProduit[index].title.length <
                                        12
                                    ? 18.0
                                    : 13.0,
                              ),
                            ),
                            const SizedBox(
                              height: 1.0,
                            ),
                            GridTile(
                              child: Text(
                                "€" +
                                    widget
                                        .selectedEvent.listProduit[index].price,
                              ),
                            ),
                          ],
                        ), //just for testing, will fill with image later
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getTotalPanier() {
    double somme = 0.0;
    for (var element in panier) {
      somme = somme + element.getTotal();
    }
    return somme.toStringAsFixed(2);
  }

  Widget myAppBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 40.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  !menuOpen
                      ? TextButton(
                          onPressed: () {
                            scale = 0.7;
                            tranx = 150;
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
                            Navigator.of(context).pop();
                          },
                          child: const FaIcon(
                            FontAwesomeIcons.arrowLeft,
                            color: kWhiteColor,
                          ),
                        ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    Utils.toDate(widget.selectedEvent.from) +
                        " - " +
                        widget.selectedEvent.title,
                    style: const TextStyle(color: kWhiteColor, fontSize: 14),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildMeteoButton(
                    FontAwesomeIcons.solidSun, "sun", widget.selectedEvent.sun),
                buildMeteoButton(FontAwesomeIcons.cloud, "cloud",
                    widget.selectedEvent.cloud),
                buildMeteoButton(
                    FontAwesomeIcons.tint, "tint", widget.selectedEvent.tint),
                buildMeteoButton(FontAwesomeIcons.pooStorm, "pooStorm",
                    widget.selectedEvent.pooCloud),
                buildMeteoButton(FontAwesomeIcons.cloudMeatball,
                    "cloudMeatball", widget.selectedEvent.cloudSomething),
              ],
            )
          ],
        ),
      ),
    );
  }

  IconButton buildMeteoButton(IconData icon, String name, bool value) {
    return IconButton(
      onPressed: () {
        switch (name) {
          case "sun":
            final provider = Provider.of<EventProvider>(context, listen: false);
            setState(() {
              widget.selectedEvent.sun = !widget.selectedEvent.sun;
            });
            provider.setEvent(widget.selectedEvent);
            break;
          case "cloud":
            final provider = Provider.of<EventProvider>(context, listen: false);
            setState(() {
              widget.selectedEvent.cloud = !widget.selectedEvent.cloud;
            });
            provider.setEvent(widget.selectedEvent);
            break;
          case "tint":
            final provider = Provider.of<EventProvider>(context, listen: false);
            setState(() {
              widget.selectedEvent.tint = !widget.selectedEvent.tint;
            });
            provider.setEvent(widget.selectedEvent);
            break;
          case "pooStorm":
            final provider = Provider.of<EventProvider>(context, listen: false);
            setState(() {
              widget.selectedEvent.pooCloud = !widget.selectedEvent.pooCloud;
            });
            provider.setEvent(widget.selectedEvent);
            break;
          case "cloudMeatball":
            final provider = Provider.of<EventProvider>(context, listen: false);
            setState(() {
              widget.selectedEvent.cloudSomething =
                  !widget.selectedEvent.cloudSomething;
            });
            provider.setEvent(widget.selectedEvent);
            break;
        }
      },
      icon: FaIcon(
        icon,
        color: value ? kYellowColor : kDarkGreyColor,
      ),
    );
  }
}
