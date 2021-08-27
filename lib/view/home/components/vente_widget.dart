import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:suividevente/controller/FirebaseStorage/storage.dart';
import 'package:suividevente/controller/event_databases/event_databases.dart';
import 'package:suividevente/controller/product_databases/product_database.dart';
import 'package:suividevente/model/event_provider.dart';
import 'package:suividevente/model/meteo.dart';
import 'package:suividevente/model/my_event.dart';
import 'package:suividevente/model/product.dart';
import 'package:suividevente/utils/constants.dart';
import 'package:suividevente/utils/utils.dart';
import 'package:suividevente/view/layout/layout.dart';

class VenteWidget extends StatefulWidget {
  final MyEvent selectedEvent;
  final String title;

  const VenteWidget({
    Key? key,
    required this.selectedEvent,
    required this.title,
  }) : super(key: key);

  @override
  _VenteWidgetState createState() => _VenteWidgetState();
}

class _VenteWidgetState extends State<VenteWidget>
    with SingleTickerProviderStateMixin {
  final databaseReference = FirebaseFirestore.instance;

  bool menuOpen = false;
  bool delprod = false;
  bool openPrice = false;
  double tranx = 0, trany = 0, scale = 1.0;

  bool reverse = false, reverse1 = false;

  MyEvent? myEvent;

  List<Meteo> meteo = [];
  List<Product> panier = [];

  late AnimationController controller;
  late Animation<double> animation;

  int somme = 1;
  double totalPanier = 0.0;

  bool sun = false;
  bool cloud = false;
  bool tint = false;
  bool pooStorm = false;
  bool cloudSomething = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this)
      ..addListener(() => setState(() {}));
    animation = Tween(begin: 400.0, end: 0.0).animate(controller);
    controller.forward();
    getDataFromFireStore();
  }

  Future<void> myInit() async {
    final event = EventDatabaseService(eventUid: widget.title).anEvent;

    event.first.then((value) {
      setState(() {
        sun = value.sun;
        cloud = value.cloud;
        tint = value.tint;
        pooStorm = value.pooCloud;
        cloudSomething = value.cloudSomething;
      });
    });
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
      body: BounceInDown(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            leftPanel(size),
            rightPanel(context),
          ],
        ),
      ),
    );
  }

  /// Right panel
  /// This one display seller cart and the total accound of the day
  ///
  Widget rightPanel(BuildContext context) {
    return SizedBox(
      width: 250.0,
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              rigthPanelHeader(),

              /// RIGHT PANEL HEADER
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: 250.0,
                    height: MediaQuery.of(context).size.height,
                    color: kLightBackgroundColor,
                    padding: const EdgeInsets.all(12.0),
                    child: StreamBuilder<List<Product>>(
                      stream: EventDatabaseService(
                              eventUid: widget.title,
                              month: widget.selectedEvent.month)
                          .allPanier,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text(
                              "Aucune vente réalisé à ce jour !",
                              style: TextStyle(color: kWhiteColor),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              child: Card(
                                elevation: 0.0,
                                color: kLightBackgroundColor,
                                child: ListTile(
                                  leading: Text(
                                    "${snapshot.data![index].nbProd == 0 ? snapshot.data![index].nbProd = 0 : snapshot.data![index].nbProd}",
                                    style: const TextStyle(color: kWhiteColor),
                                  ),
                                  title: Text(
                                    snapshot.data![index].title,
                                    style: const TextStyle(color: kWhiteColor),
                                  ),
                                  trailing: delprod
                                      ? IconButton(
                                          onPressed: () async {
                                            await EventDatabaseService()
                                                .addEventToCart(
                                              widget.title,
                                              snapshot.data![index].uid,
                                              snapshot.data![index].title,
                                              snapshot.data![index].price,
                                              snapshot.data![index].img,
                                              snapshot.data![index].nbProd,
                                              widget.selectedEvent.month,
                                            );
                                            snapshot.data![index].nbProd =
                                                snapshot.data![index].nbProd -
                                                    1;
                                          },
                                          icon: const FaIcon(
                                            FontAwesomeIcons.times,
                                            color: kRedColor,
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                            );
                          },
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
                  width: 150.0,
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
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {},
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
                            '$totalPanier €',
                            style: const TextStyle(
                              fontSize: 20.0,
                              color: kWhiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SlideInLeft(
                child: Padding(
                  padding: const EdgeInsets.only(right: 0.0, bottom: 20.0),
                  child: Container(
                    width: openPrice ? 130.0 : 60,
                    height: 60.0,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              openPrice = !openPrice;
                              getSoldeEvent();
                            });
                            Future.delayed(const Duration(seconds: 3), () {
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
                        openPrice
                            ? Text(
                                "$totalPanier €".toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  color: kWhiteColor,
                                ),
                              )
                            : Container(),
                      ],
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
              ),
            ),
        ],
      ),
    );
  }

  Container rigthPanelHeader() {
    return Container(
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
              ? FadeIn(
                  child: const FaIcon(
                    FontAwesomeIcons.moneyBillAlt,
                    color: Colors.green,
                  ),
                )
              : FadeOut(
                  child: const FaIcon(
                    FontAwesomeIcons.trashAlt,
                    color: kWhiteColor,
                  ),
                ),
        ),
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
    );
  }

  getSoldeEvent() async {
    final eventPanier = await databaseReference
        .collection("events")
        .doc('${widget.selectedEvent.month}')
        .collection("all")
        .doc(widget.title)
        .collection("panier")
        .get();
    double somme = 0.0;

    List<Product> pan = eventPanier.docs.map((e) {
      return Product(
        uid: e.data()['prodUid'],
        title: e.data()['prodTitle'],
        price: e.data()['prodPrice'],
        img: e.data()['prodImg'],
        nbProd: e.data()['prodNb'],
      );
    }).toList();

    for (var element in pan) {
      somme = somme + (double.parse(element.price) * element.nbProd);
    }

    setState(() {
      totalPanier = somme;
    });
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
              child: StreamBuilder<List<Product>>(
                  stream: ProductDatabaseService().allProducts,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                          child: Text(
                              "Vous n'avez aucun produit en stock actuellement !",
                              style: TextStyle(color: kWhiteColor)));
                    }
                    final panier = snapshot.data;

                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: panier!.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: 180.0,
                        crossAxisCount: 4,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () async {
                            await EventDatabaseService().addEventToCart(
                              widget.title,
                              panier[index].uid,
                              panier[index].title,
                              panier[index].price,
                              panier[index].img,
                              panier[index].nbProd,
                              widget.selectedEvent.month,
                            );
                            panier[index].nbProd = panier[index].nbProd + 1;
                          },
                          child: Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                FutureBuilder(
                                    future: _getImageFromStore(
                                        context, panier[index].img),
                                    builder: (context, snap) {
                                      if (!snap.hasData) {
                                        return const CircularProgressIndicator();
                                      }
                                      return snap.data as Image;
                                    }),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  panier[index].title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: panier[index].title.length < 12
                                        ? 18.0
                                        : 13.0,
                                  ),
                                ),
                                const SizedBox(
                                  height: 1.0,
                                ),
                                GridTile(
                                  child: Text(
                                    "€" + panier[index].price,
                                  ),
                                ),
                              ],
                            ), //just for testing, will fill with image later
                          ),
                        );
                      },
                    );
                  }),
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
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Layout()));
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
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildMeteoButton(FontAwesomeIcons.solidSun, "sun", widget.selectedEvent.sun),
                  buildMeteoButton(FontAwesomeIcons.cloud, "cloud", widget.selectedEvent.cloud),
                  buildMeteoButton(FontAwesomeIcons.tint, "tint", widget.selectedEvent.tint),
                  buildMeteoButton(
                      FontAwesomeIcons.pooStorm, "pooStorm", widget.selectedEvent.pooCloud),
                  buildMeteoButton(FontAwesomeIcons.cloudMeatball,
                      "cloudMeatball", widget.selectedEvent.cloudSomething),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  IconButton buildMeteoButton(IconData icon, String name, bool value) {
    print(value);
    return IconButton(
      onPressed: () async {
        switch (name) {
          case "sun":
            final provider = Provider.of<EventProvider>(context, listen: false);
            setState(() {
              sun = !sun;
              widget.selectedEvent.sun = sun;
            });
            await EventDatabaseService(eventUid: widget.selectedEvent.title)
                .updateEventMeteo(sun, "sun", widget.selectedEvent.month, widget.selectedEvent.from);
            provider.setDate(widget.selectedEvent.from);
            break;
          case "cloud":
            final provider = Provider.of<EventProvider>(context, listen: false);
            setState(() {
              cloud = !cloud;
              widget.selectedEvent.cloud = cloud;
            });
            await EventDatabaseService(eventUid: widget.selectedEvent.title)
                .updateEventMeteo(cloud, "cloud", widget.selectedEvent.month, widget.selectedEvent.from);
            provider.setDate(widget.selectedEvent.from);
            break;
          case "tint":
            final provider = Provider.of<EventProvider>(context, listen: false);
            setState(() {
              tint = !tint;
              widget.selectedEvent.tint = tint;
            });
            await EventDatabaseService(eventUid: widget.selectedEvent.title)
                .updateEventMeteo(tint, "tint", widget.selectedEvent.month, widget.selectedEvent.from);
            provider.setDate(widget.selectedEvent.from);
            break;
          case "pooStorm":
            final provider = Provider.of<EventProvider>(context, listen: false);
            setState(() {
              pooStorm = !pooStorm;
              widget.selectedEvent.pooCloud = pooStorm;
            });
            await EventDatabaseService(eventUid: widget.selectedEvent.title).updateEventMeteo(
                pooStorm, "pooStorm", widget.selectedEvent.month, widget.selectedEvent.from);
            provider.setDate(widget.selectedEvent.from);
            break;
          case "cloudMeatball":
            final provider = Provider.of<EventProvider>(context, listen: false);
            setState(() {
              cloudSomething = !cloudSomething;
              widget.selectedEvent.cloudSomething = cloudSomething;
            });
            await EventDatabaseService(eventUid: widget.selectedEvent.title).updateEventMeteo(
                cloudSomething, "cloudSomething", widget.selectedEvent.month, widget.selectedEvent.from);
            provider.setDate(widget.selectedEvent.from);
            break;
        }
      },
      icon: FaIcon(
        icon,
        color: value ? kYellowColor : kDarkGreyColor,
      ),
    );
  }

  Future<Image> _getImageFromStore(
      BuildContext context, String? imageName) async {
    Image image;
    return await FireStorageService()
        .loadImage(context, imageName!)
        .then((value) {
      image = Image.network(
        value.toString(),
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width,
        height: 115.0,
      );
      return image;
    });
  }

  Future<double> total() async {
    final panier = EventDatabaseService().allPanier;
    double myTotal = 0;

    panier.forEach((element) {
      for (var elem in element) {
        myTotal = myTotal + (double.parse(elem.price) * elem.nbProd);

        totalPanier = myTotal;
      }
    });
    return totalPanier;
  }

  Future<void> getDataFromFireStore() async {
    var snapShotsValue = await databaseReference
        .collection("events")
        .doc('${widget.selectedEvent.month}')
        .collection("all")
        .doc(widget.title)
        .get();

    setState(() {
      sun = snapShotsValue.data()!['sun'];
      cloud = snapShotsValue.data()!['cloud'];
      tint = snapShotsValue.data()!['tint'];
      pooStorm = snapShotsValue.data()!['pooStorm'];
      cloudSomething = snapShotsValue.data()!['cloudSomething'];
    });
  }
}
