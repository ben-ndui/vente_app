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
    animation = Tween(begin: 200.0, end: 30.0).animate(controller);
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
    final provider = Provider.of<EventProvider>(context, listen: false);
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
                      icon: delprod ? const FaIcon(FontAwesomeIcons.moneyBillAlt, color: Colors.green,) : const FaIcon(
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
                                          if(widget.selectedEvent.panier[index]
                                              .nbProd == 0){
                                            widget.selectedEvent.panier.remove(widget.selectedEvent.panier[index]);
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
          if (openPrice) Transform.translate(
                  offset: Offset(animation.value, 0),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 0.0, bottom: 20.0),
                    child: Container(
                      width: 200.0,
                      height: 60.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: kBtnSelectedColor,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: const [
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
                                setState(() {
                                  openPrice = !openPrice;
                                });
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
                            Text(widget.selectedEvent.getTotalPanier() + "€".toUpperCase(), style: const TextStyle(fontSize: 20.0, color: kWhiteColor),),
                          ],
                        ),
                      ),
                    ),
                  ),
                ) else Padding(
                  padding: const EdgeInsets.only(right: 0.0, bottom: 20.0),
                  child: Container(
                    width: openPrice ? 200.0 : 35.0,
                    height: 60.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: openPrice ? kBtnSelectedColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: const [
                        BoxShadow(
                          color: kLightBackgroundColor,
                          spreadRadius: 8.0,
                          blurRadius: 8.0,
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              openPrice = !openPrice;
                              reverse = !reverse;
                            });
                          },
                          child: const FaIcon(
                            FontAwesomeIcons.caretLeft,
                            color: kDefaultBackgroundColor,
                            size: 50.0,
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        openPrice
                            ? Text(widget.selectedEvent.getTotalPanier() + "€")
                            : Container(),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  sortList() {
    int summus = 0, i, j = 0;
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
                        if(widget.selectedEvent.panier.contains(widget.selectedEvent.listProduit[index])){
                          widget.selectedEvent.panier[index].nbProd += 1;
                        }else{
                          widget.selectedEvent.panier.add(widget.selectedEvent.listProduit[index]);
                        }
                      });
                      provider.setEvent(widget.selectedEvent);
                    },
                    child: Container(
                      width: 300.0,
                      height: 100.0,
                      //color: Colors.green,
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
                                fontSize: widget.selectedEvent.listProduit[index]
                                            .title.length <
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
                                "€" + widget.selectedEvent.listProduit[index].price,
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
                    Utils.toDate(widget.selectedEvent.from) + " - " + widget.selectedEvent.title,
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
                buildMeteoButton(FontAwesomeIcons.solidSun, "sun", widget.selectedEvent.meteo1),
                buildMeteoButton(FontAwesomeIcons.cloud, "cloud", widget.selectedEvent.meteo2),
                buildMeteoButton(FontAwesomeIcons.tint, "tint", widget.selectedEvent.meteo3),
                buildMeteoButton(FontAwesomeIcons.pooStorm, "pooStorm", widget.selectedEvent.meteo4),
                buildMeteoButton(FontAwesomeIcons.cloudMeatball, "cloudMeatball",
                    widget.selectedEvent.meteo5),
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
            final provider =
            Provider.of<EventProvider>(context, listen: false);
            setState(() {
              widget.selectedEvent.meteo1 = !widget.selectedEvent.meteo1;
            });
            provider.setEvent(widget.selectedEvent);
            break;
          case "cloud":
            final provider =
            Provider.of<EventProvider>(context, listen: false);
            setState(() {
              widget.selectedEvent.meteo2 = !widget.selectedEvent.meteo2;
            });
            provider.setEvent(widget.selectedEvent);
            break;
          case "tint":
            final provider =
            Provider.of<EventProvider>(context, listen: false);
            setState(() {
              widget.selectedEvent.meteo3 = !widget.selectedEvent.meteo3;
            });
            provider.setEvent(widget.selectedEvent);
            break;
          case "pooStorm":
            final provider =
            Provider.of<EventProvider>(context, listen: false);
            setState(() {
              widget.selectedEvent.meteo4 = !widget.selectedEvent.meteo4;
            });
            provider.setEvent(widget.selectedEvent);
            break;
          case "cloudMeatball":
            final provider =
            Provider.of<EventProvider>(context, listen: false);
            setState(() {
              widget.selectedEvent.meteo5 = !widget.selectedEvent.meteo5;
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
