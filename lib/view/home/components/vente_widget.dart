import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:suividevente/controller/event_databases/event_databases.dart';
import 'package:suividevente/controller/product_databases/product_database.dart';
import 'package:suividevente/model/chiffres_by_month.dart';
import 'package:suividevente/model/event_provider.dart';
import 'package:suividevente/model/meteo.dart';
import 'package:suividevente/model/my_event.dart';
import 'package:suividevente/model/product.dart';
import 'package:suividevente/utils/constants.dart';
import 'package:suividevente/utils/theme.dart';
import 'package:suividevente/utils/utils.dart';
import 'package:suividevente/view/layout/layout.dart';
import 'package:weather_icons/weather_icons.dart';

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

  int somme = 1;
  double totalPanier = 0.0;
  double temp = 0.0;

  bool sun = false;
  bool cloud = false;
  bool tint = false;
  bool pooStorm = false;
  bool cloudSomething = false;

  @override
  void initState() {
    // TODO: implement initState
    getDataFromFireStore();
    print(widget.title);
    super.initState();
  }

  myLoad() {
    setState(() {
      widget.selectedEvent.isActive = true;
    });
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
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kDefaultBackgroundColor,
      body: BounceInDown(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            buildProductList(size),
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
              buildRightPanelBody(),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(right: 0.0, bottom: 20.0),
              child: AnimatedContainer(
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 300),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        getSoldeEvent();
                        setState(() {
                          openPrice = !openPrice;
                          widget.selectedEvent.panierCount = totalPanier;
                        });

                        Future.delayed(
                            const Duration(seconds: 3),
                            () async {
                              setState(
                                () {
                                  openPrice = !openPrice;
                                },
                              );
                              EventDatabaseService(eventUid: widget.title).updateEventTotalPanier(
                                totalPanier,
                                "panier",
                                widget.selectedEvent.from.month,
                                widget.selectedEvent.from,
                              );
                            },
                          );
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.caretLeft,
                        color: kDefaultBackgroundColor,
                        size: 40.0,
                      ),
                    ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: openPrice ? 1 : 0,
                      child: Visibility(
                        visible: openPrice,
                        child: Container(
                          width: 130.0,
                          height: 60.0,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "$totalPanier €".toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  color: kWhiteColor,
                                ),
                              ),
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
                  ],
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
        .doc(
            '${widget.selectedEvent.from.month} - ${widget.selectedEvent.from.year}')
        .collection("all")
        .doc(widget.title +
            ' - ${widget.selectedEvent.from.day} - ${widget.selectedEvent.from.month} - ${widget.selectedEvent.from.year}')
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
        isHidden: e.data()['isHidden'],
      );
    }).toList();

    for (var element in pan) {
      somme = somme + (double.parse(element.price) * element.nbProd);
    }

    setState(() {
      totalPanier = somme;
    });
  }

  sortList() {
    int i;
    for (i = 0; i < widget.selectedEvent.listProduit.length; i++) {
      if (widget.selectedEvent.listProduit[i].title
          .contains(widget.selectedEvent.listProduit[i + 1].title)) {}
    }
  }

  Widget buildProductList(Size size) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            myAppBar(),
            buildProdListBody(size),
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
          child: Container(
            //color: Colors.green,
            width: 750.0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
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
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (BuildContext context,
                                        Animation animation,
                                        Animation secondaryAnimation) {
                                      return const Layout();
                                    },
                                    transitionDuration:
                                        const Duration(milliseconds: 300),
                                    transitionsBuilder: (BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation,
                                        Widget child) {
                                      animation = CurvedAnimation(
                                          curve: Curves.easeInOutCubic,
                                          parent: animation);

                                      return ScaleTransition(
                                        scale: animation,
                                        child: child,
                                      );
                                    },
                                  ),
                                  (Route route) => false);
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
                          widget.title,
                      style: const TextStyle(color: kWhiteColor, fontSize: 14),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildMeteoButton("assets/weather/sun.svg", "sun",
                        widget.selectedEvent.sun),
                    const SizedBox(width: 15.0,),
                    buildMeteoButton("assets/weather/cloud.svg", "cloud",
                        widget.selectedEvent.cloud),
                    const SizedBox(width: 15.0,),
                    buildMeteoButton("assets/weather/raindrops.svg", "tint",
                        widget.selectedEvent.tint),
                    const SizedBox(width: 15.0,),
                    buildMeteoButton("assets/weather/bolt.svg", "pooStorm",
                        widget.selectedEvent.pooCloud),
                    const SizedBox(width: 15.0,),
                    buildMeteoButton("assets/weather/snowflakes.svg",
                        "cloudMeatball", widget.selectedEvent.cloudSomething),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMeteoButton(String icon, String name, bool value) {
    return GestureDetector(
      onTap: () async {
        switch (name) {
          case "sun":
            final provider = Provider.of<EventProvider>(context, listen: false);
            setState(() {
              sun = !sun;
              widget.selectedEvent.sun = sun;
            });
            provider.setDate(widget.selectedEvent.from);
            await EventDatabaseService(eventUid: widget.title).updateEventMeteo(
                sun,
                "sun",
                widget.selectedEvent.month,
                widget.selectedEvent.from);
            break;
          case "cloud":
            final provider = Provider.of<EventProvider>(context, listen: false);
            setState(() {
              cloud = !cloud;
              widget.selectedEvent.cloud = cloud;
            });
            await EventDatabaseService(eventUid: widget.title).updateEventMeteo(
                cloud,
                "cloud",
                widget.selectedEvent.month,
                widget.selectedEvent.from);
            provider.setDate(widget.selectedEvent.from);
            break;
          case "tint":
            final provider = Provider.of<EventProvider>(context, listen: false);
            setState(() {
              tint = !tint;
              widget.selectedEvent.tint = tint;
            });
            await EventDatabaseService(eventUid: widget.title).updateEventMeteo(
                tint,
                "tint",
                widget.selectedEvent.month,
                widget.selectedEvent.from);
            provider.setDate(widget.selectedEvent.from);
            break;
          case "pooStorm":
            final provider = Provider.of<EventProvider>(context, listen: false);
            setState(() {
              pooStorm = !pooStorm;
              widget.selectedEvent.pooCloud = pooStorm;
            });
            await EventDatabaseService(eventUid: widget.title).updateEventMeteo(
                pooStorm,
                "pooStorm",
                widget.selectedEvent.month,
                widget.selectedEvent.from);
            provider.setDate(widget.selectedEvent.from);
            break;
          case "cloudMeatball":
            final provider = Provider.of<EventProvider>(context, listen: false);
            setState(() {
              cloudSomething = !cloudSomething;
              widget.selectedEvent.cloudSomething = cloudSomething;
            });
            await EventDatabaseService(eventUid: widget.title).updateEventMeteo(
                cloudSomething,
                "cloudSomething",
                widget.selectedEvent.month,
                widget.selectedEvent.from);
            provider.setDate(widget.selectedEvent.from);
            break;
        }
      },
      child: SvgPicture.asset(
        icon,
        color: value ? kYellowColor : kDarkGreyColor,
        width: 26.0,
        height: 26.0,
      ),
    );
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
        .doc(
            '${widget.selectedEvent.month} - ${widget.selectedEvent.from.year}')
        .collection("all")
        .doc(widget.title +
            ' - ${widget.selectedEvent.from.day} - ${widget.selectedEvent.from.month} - ${widget.selectedEvent.from.year}')
        .get();

    setState(() {
      sun = snapShotsValue.data()!['sun'];
      cloud = snapShotsValue.data()!['cloud'];
      tint = snapShotsValue.data()!['tint'];
      pooStorm = snapShotsValue.data()!['pooStorm'];
      cloudSomething = snapShotsValue.data()!['cloudSomething'];
    });

    var panier = await databaseReference
        .collection("events")
        .doc(
            '${widget.selectedEvent.month} - ${widget.selectedEvent.from.year}')
        .collection("all")
        .doc(widget.title +
            ' - ${widget.selectedEvent.from.day} - ${widget.selectedEvent.from.month} - ${widget.selectedEvent.from.year}')
        .collection('panier')
        .get();

    List<Product> listProd = panier.docs.map((e) {
      return Product(
        uid: e.data()['prodUid'],
        title: e.data()['prodTitle'],
        price: e.data()['prodPrice'],
        img: e.data()['prodImg'],
        nbProd: e.data()['prodNb'],
        isHidden: e.data()['isHidden'],
      );
    }).toList();

    for (var element in listProd) {
      element.isHidden ? listProd.remove(element) : null;
    }

    setState(() {
      widget.selectedEvent.panier = listProd;
      widget.selectedEvent.isActive = true;
    });
  }

  Widget buildRightPanelBody() {
    //print(widget.title);
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          width: 250.0,
          height: MediaQuery.of(context).size.height,
          color: kLightBackgroundColor,
          padding: const EdgeInsets.all(12.0),
          child: StreamBuilder<List<Product>>(
            stream: EventDatabaseService(
              eventUid: widget.title +
                  ' - ${widget.selectedEvent.from.day} - ${widget.selectedEvent.from.month} - ${widget.selectedEvent.from.year}',
              month: widget.selectedEvent.month,
              year: widget.selectedEvent.from.year,
            ).allPanier,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    "Aucune vente réalisé à ce jour !",
                    style: TextStyle(color: kWhiteColor),
                  ),
                );
              }

              final userPanier = snapshot.data;

              return ListView.builder(
                shrinkWrap: true,
                itemCount: userPanier!.length,
                itemBuilder: (context, index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    child: Card(
                      elevation: 0.0,
                      color: kLightBackgroundColor,
                      child: ListTile(
                        leading: Text(
                          "${userPanier[index].nbProd == 0 ? userPanier[index].nbProd = 0 : userPanier[index].nbProd}",
                          style: const TextStyle(color: kWhiteColor),
                        ),
                        title: Text(
                          userPanier[index].title,
                          style: const TextStyle(color: kWhiteColor),
                        ),
                        trailing: delprod
                            ? buildIcon(context, userPanier, index,)
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
    );
  }

  buildProdListBody(Size size) {
    return Container(
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
                  style: TextStyle(color: kWhiteColor),
                ),
              );
            }

            final allProducts = snapshot.data; // MES PRODUITS
            List<Product> newAllProductWithHiddenProd =
                []; // MON PANIER DE TRIE AVEC LES PRODUITs NON VISIBLE
            for (var element in allProducts!) {
              if (!element.isHidden) {
                newAllProductWithHiddenProd.add(element);
              }
            }

            return StreamBuilder<List<ChiffresByMonth>>(

                /// CHIFFRES STREAM
                stream: EventDatabaseService(
                        month: widget.selectedEvent.from.month,
                        year: widget.selectedEvent.from.year)
                    .allMonth,
                builder: (context, snapshotChiffre) {
                  if(!snapshot.hasData) return const CircularProgressIndicator();
                  final chiffres = snapshotChiffre.data;

                  return GridView.builder(
                    /// GRIDVIEW BUILDER
                    shrinkWrap: true,
                    itemCount: newAllProductWithHiddenProd.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 180.0,
                      crossAxisCount: 4,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return StreamBuilder<List<Product>>(

                          /// EVENT OF THE DAY : PRODUCTS LIST STREAM
                          stream: EventDatabaseService(
                            eventUid: widget.title +
                                ' - ${widget.selectedEvent.from.day} - ${widget.selectedEvent.from.month} - ${widget.selectedEvent.from.year}',
                            month: widget.selectedEvent.month,
                            year: widget.selectedEvent.from.year,
                          ).allPanier,
                          builder: (context, eventPanier) {
                            if (!eventPanier.hasData) {
                              return const CircularProgressIndicator();
                            }

                            final panierDuJour = eventPanier.data; // PANIER DE L'UTILISATEUR

                            return GestureDetector(
                              onTap: () async {
                                print("Ajouté !");
                                int nbprod = 0;

                                for (var element in panierDuJour!) {
                                  if (element.uid
                                      .contains(allProducts[index].uid)) {
                                    element.nbProd = element.nbProd + 1;
                                    nbprod = element.nbProd;
                                  }
                                  else{
                                    nbprod = 1;
                                  }
                                }

                                Product product = Product(
                                  uid: allProducts[index].uid,
                                  title: allProducts[index].title,
                                  price: allProducts[index].price,
                                  img: allProducts[index].img,
                                  nbProd: nbprod != 0 ? nbprod : allProducts[index].nbProd,
                                  isHidden: allProducts[index].isHidden,
                                );

                                setState(() { widget.selectedEvent.addProductToPanier(product);});

                                EventDatabaseService().addEventToCart(widget.title, product.uid, product.title, product.price, product.img, product.nbProd, widget.selectedEvent.month, widget.selectedEvent.from, product.isHidden,);

                                getSoldeEvent();

                                EventDatabaseService(eventUid: widget.title).updateEventTotalPanier(totalPanier, "panier", widget.selectedEvent.month, widget.selectedEvent.from);

                                EventDatabaseService(year: widget.selectedEvent.from.year, month: widget.selectedEvent.from.month).saveChiffres(product.title, widget.selectedEvent.from.month, double.parse(product.price), widget.selectedEvent.from, product.nbProd, widget.title);
                                allProducts[index].setProdNb(1);
                              },
                              child: Card(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    FutureBuilder(
                                        future: getImageFromStore(
                                            context,
                                            newAllProductWithHiddenProd[index]
                                                .img),
                                        builder: (context, snap) {
                                          if (!snap.hasData) {
                                            return const CircularProgressIndicator();
                                          }
                                          return ClipRRect(
                                            child: snap.data as Image,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(4.0),
                                                    topRight:
                                                        Radius.circular(4.0)),
                                          );
                                        }),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      newAllProductWithHiddenProd[index].title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize:
                                            newAllProductWithHiddenProd[index]
                                                        .title
                                                        .length <
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
                                            newAllProductWithHiddenProd[index]
                                                .price,
                                      ),
                                    ),
                                  ],
                                ), //just for testing, will fill with image later
                              ),
                            );
                          });
                    },
                  );
                });
          }),
    );
  }

  Widget buildIcon(BuildContext context, List<Product> userPanier, int index){
    return IconButton(
      onPressed: () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) =>
              AlertDialog(
                title: const Text(
                  "Etes vous sur de vouloir \n retirer un article ?",
                  textAlign: TextAlign.center,
                ),
                actions: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel', style: TextStyle(color: kWhiteColor,),),
                          style: TextButton.styleFrom(backgroundColor: kRedColor,),
                        ),
                      ),
                      const SizedBox(width: 10.0,),
                      StreamBuilder<ChiffresByMonth>(
                          stream: EventDatabaseService(
                              month: widget.selectedEvent.from.month,
                              year: widget.selectedEvent.from.year,
                              eventUid: widget.title).getChiffre(widget.selectedEvent.from),
                          builder: (context, snapshotD) {
                            return Expanded(
                              child: TextButton(
                                onPressed: () async {
                                  userPanier[index].setProdNb(-1);
                                  Product product = Product(
                                    uid: userPanier[index].uid,
                                    title: userPanier[index].title,
                                    price: userPanier[index].price,
                                    img: userPanier[index].img,
                                    nbProd: userPanier[index].nbProd,
                                    isHidden: userPanier[index].isHidden,
                                  );

                                  widget.selectedEvent.panier.remove(product);

                                  var tempp = 0.0;

                                  if (userPanier.isNotEmpty) {
                                    if(snapshotD.hasData){
                                      tempp = snapshotD.data!.chiffres - double.parse(userPanier[index].price);
                                    }
                                  } else if (userPanier.isEmpty) {
                                    tempp = 0.0;
                                  } else {
                                    tempp = snapshotD.data!.chiffres - double.parse(userPanier[index].price);
                                  }

                                  await EventDatabaseService(year: widget.selectedEvent.from.year, month: widget.selectedEvent.from.month).deleteChiffres(userPanier[index].title, widget.selectedEvent.from.month, tempp, widget.selectedEvent.from, userPanier[index].nbProd + 1, widget.title);
                                  print("USER PANIER ${userPanier[index].nbProd}");

                                  EventDatabaseService().addEventToCart(widget.title, userPanier[index].uid, userPanier[index].title, userPanier[index].price, userPanier[index].img, userPanier[index].nbProd, widget.selectedEvent.month,widget.selectedEvent.from, userPanier[index].isHidden,);

                                  getSoldeEvent();

                                  EventDatabaseService(eventUid: widget.title).updateEventTotalPanier(totalPanier, "panier", widget.selectedEvent.from.month, widget.selectedEvent.from,).then((value) {Navigator.of(context).pop();});
                                },
                                child: const Text('Enlever', style: TextStyle(color: kWhiteColor),),
                                style: TextButton.styleFrom(backgroundColor: Colors.green,),
                              ),
                            );
                          }),
                    ],
                  )
                ],
              ),
        );
      },
      icon: const FaIcon(
        FontAwesomeIcons.times,
        color: kRedColor,
      ),
    );
  }
}
