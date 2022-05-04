import 'package:ez_eats/screens/add_user_screen.dart';
import 'package:ez_eats/screens/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:animations/animations.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController clr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Hive.openBox("selected");
    double deviceWidth = MediaQuery.of(context).size.width;
    return Center(
        child: Scaffold(
            body: SafeArea(
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0.05 * deviceWidth),
          child: ListView(
        children: [
          // ListTile(title: Text("HELLO WORLD")),
          TextField(
            controller: clr,
            decoration: const InputDecoration(
                icon: Icon(Icons.search), labelText: "Search"),
          ),
          const SizedBox(
            height: 30,
          ),
          restaurantList()
        ],
      )),
    )));
  }

  Widget restaurantInfoButton(String name) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      transitionDuration: const Duration(milliseconds: 500),
      closedElevation: 0.0,
      openElevation: 4.0,
      closedBuilder: (context, action) {
        return TextButton(
            onPressed: () {
              // print('BUTTON PRESSED');
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => RestaurantScreen(name: name) ));
              action();
            },
            child: Text("MORE",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.orange[500])));
      },
      openBuilder: (context, action) => RestaurantScreen(name: name),
      tappable: false,
    );
  }

  Widget restaurantCard(String name, String imgPathName) {
    bool alreadySaved = Hive.box("favorites").get(name);
    return SizedBox(
        width: 225,
        height: null,
        child: Card(
            child: InkWell(
                splashColor: Colors.blueGrey.withAlpha(50),
                onTap: () {},
                child: Column(children: [
                  Image.asset(
                      "assets/images/$imgPathName/$imgPathName-card.jpg",
                      width: 225,
                      height: 100,
                      fit: BoxFit.fill),
                  Text(name,
                      style: const TextStyle(fontSize: 24, fontFamily: "")),
                  // Text("DESCRIPTION", style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      restaurantInfoButton(imgPathName),
                      IconButton(
                          onPressed: () {
                            // print('ICON PRESSED');
                            setState(() {
                              Hive.box("favorites")
                                  .put(name, !Hive.box("favorites").get(name));
                            });
                          },
                          icon: Icon(
                              alreadySaved
                                  ? Icons.favorite
                                  : Icons.favorite_border_sharp,
                              color: alreadySaved ? Colors.red : null))
                    ],
                  )
                ]))));
  }

  Widget restaurantList() {
    return SingleChildScrollView(
        child: Column(
      children: [
        restaurantCard("McDonald's", "mcdonalds"),
        const SizedBox(height: 5),
        restaurantCard("Panera Bread", "panera")
      ],
    ));
  }
}
