import 'package:ez_eats/screens/search_screen.dart';
import 'package:ez_eats/screens/user_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RestaurantScreen extends StatefulWidget {
  final String name;

  const RestaurantScreen({Key? key, required this.name}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _RestaurantScreenState createState() => _RestaurantScreenState(name);
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final String name;
  final Icon _check = const Icon(
    Icons.check_circle_outline,
    color: Colors.green,
    size: 24.0,
  );
  final Icon _warning = const Icon(
    Icons.warning_amber_rounded,
    color: Colors.orange,
    size: 24.0,
  );
  final Icon _x = const Icon(
    Icons.block_outlined,
    color: Colors.red,
    size: 24.0,
  );

  

  _RestaurantScreenState(this.name);

  

  @override
  Widget build(BuildContext context) {
    Hive.openBox(name);
    Hive.openBox("selected");
    
    String item = "";
    Widget _restaurantList = Expanded(
      child: SingleChildScrollView(
          child: Column(children: [
            for(int i = 0; i < Hive.box(name).length; i++)
              _restaurantTile(item = Hive.box(name).keyAt(i), Image.asset(
                "assets/images/mcdonalds/$item.jpg",
                width: 50,
              ), context),
            
      ])),
    );

    return Center(
        child: Scaffold(
            body: SafeArea(
      child: Column(
        children: [
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  // onPressed: () => Navigator.pop(context),
                  onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SearchScreen())),
                  icon: const Icon(Icons.arrow_back_ios_new_sharp)),
              IconButton(onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => UserListScreen())),
                  icon: const Icon(Icons.home)
                  )
              // const IconButton(
              //     onPressed: null, icon: Icon(Icons.circle_outlined))
            ],
          ),
          SizedBox(
              height: 200,
              width: 350,
              child: Image.asset('assets/images/$name/$name-card.jpg',
                  height: 200, width: null, fit: BoxFit.fill)),
                  
          _restaurantList
          // ListTile(
          // leading: Image.asset(
          //   "assets/images/mcdonalds/mcdonalds-bacon-egg-cheese-biscuit.jpg",
          //   width: 50,
          // ),
          //   title: const Text("Bacon, Egg & Cheese Biscuit"),
          //   trailing: _check,
          // ),
          // ListTile(
          //   leading: Image.asset(
          //     "assets/images/mcdonalds/mcdonalds-egg-mcmuffin.jpg",
          //     width: 50,
          //   ),
          //   title: const Text("Egg McMuffin"),
          //   trailing: _warning,
          // ),
          // ListTile(
          //   leading: Image.asset(
          //     "assets/images/mcdonalds/mcdonalds-sausage-mcmuffin.jpg",
          //     width: 50,
          //   ),
          //   title: const Text("Sausage McMuffin"),
          //   trailing: _x,
          // ),
        ],
      ),
    )));
  }

  Widget _restaurantTile(String name, Image img, BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    Icon symbol = _check;
    Hive.openBox(this.name);
    List r = Hive.box(this.name).get(name);
    for (int i = 0; i < r.length; i++) {
      if(Hive.box("selected").get(r[i]) == true) {
        setState(() {
          symbol = _x;
        });
        break;
      }
    }

    return Container(
        padding: EdgeInsets.only(
            left: 0.05 * deviceWidth, right: 0.05 * deviceWidth, top: 15),
        child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(10),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: img,
              title: Text(name),
              trailing: symbol,
            )));
  }
}
