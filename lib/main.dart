// import 'dart:developer';
import 'dart:convert';
import 'package:ez_eats/screens/add_user_screen.dart';
import 'package:ez_eats/screens/search_screen.dart';
import 'package:ez_eats/screens/user_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

List _users = [];

void main() async {
  await Hive.initFlutter();
  await Hive.openBox("text");
  Hive.box("text").put("center_text", "");
  await Hive.openBox("favorites");
  await Hive.box("favorites").put("McDonald's", false);
  await Hive.box('favorites').put("Panera Bread", false);
  await Hive.openBox("selected");
  await Hive.openBox("mcdonalds");
  await Hive.box("mcdonalds").put(
      "Big Mac", ['Wheat', 'Sesame', 'Dairy', 'Egg', 'Vegetarian', 'Vegan']);
  await Hive.box("mcdonalds")
      .put("Cheeseburger", ['Wheat', 'Dairy', 'Vegetarian', 'Vegan']);
  await Hive.box("mcdonalds")
      .put("Double Cheeseburger", ['Wheat', 'Dairy', 'Vegetarian', 'Vegan']);
  await Hive.box("mcdonalds").put("Quarter Pounder with Cheese",
      ['Wheat', 'Sesame', 'Dairy', 'Vegetarian', 'Vegan']);
  await Hive.box("mcdonalds").put("Double Quarter Pounder with Cheese",
      ['Wheat', 'Sesame', 'Dairy', 'Vegetarian', 'Vegan']);
  await Hive.box("mcdonalds")
      .put("Hamburger", ['Wheat', 'Vegetarian', 'Vegan']);
  await Hive.box("mcdonalds")
      .put("Double Cheeseburger", ['Wheat', 'Vegetarian', 'Vegan']);
  await Hive.box("mcdonalds")
      .put("Chicken McNuggets", ['Wheat', 'Vegetarian', 'Vegan']);
  await Hive.box("mcdonalds").put("Hash Brown", []);
  await Hive.box("mcdonalds")
      .put("Filet-o-Fish", ['Wheat', 'Dairy', 'Egg', 'Fish', 'Vegetarian', 'Vegan']);

  await Hive.openBox("panera");
  await Hive.box("panera").put("Asiago Bagel", ['Wheat', 'Dairy', 'Vegan']);
  await Hive.box("panera").put("Everything Bagel", ['Wheat', 'Sesame', 'Vegan']);
  await Hive.box("panera").put("Mixed Berry Greek Yogurt Parfait", ['Wheat', 'Tree Nut', 'Dairy', 'Vegan']);
  await Hive.box("panera").put("Blueberry Muffin", ['Wheat', 'Dairy', 'Egg', 'Vegan']);
  await Hive.box("panera").put("Bear Claw", ['Wheat', 'Tree Nut', 'Dairy', 'Soy', 'Egg', 'Vegan']);
  await Hive.box("panera").put("Mediterranean Bowl", ['Wheat', 'Dairy', 'Vegan']);
  await Hive.box("panera").put("Greek Salad", ['Dairy', 'Vegan']);
  await Hive.box("panera").put("Broccoli Cheddar Soup", ['Wheat', 'Dairy', 'Vegetarian', 'Vegan']);
  await Hive.box("panera").put("Mac & Cheese", ['Wheat', 'Dairy', 'Egg', 'Vegan']);
  await Hive.box("panera").put("Classic Grilled Cheese Sandwich", ['Wheat', 'Dairy', 'Egg', 'Vegan']);
  await Hive.box("panera").put("Chipotle Chicken Avocado Melt", ['Wheat', 'Dairy', 'Egg', 'Vegetarian', 'Vegan']);



  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

/// HIVE STUFF
Future<Box> getBox(String name) async {
  bool exists = await Hive.boxExists(name);
  return exists ? Hive.box(name) : await Hive.openBox(name);

  // could also do following
  // return await Hive.openBox(name);
}

Future<int> writeToBox2(String name, var data) async {
  var box = await getBox(name);
  return await box.add(data);
}

void writeToBox(String name, String key, var value) async {
  var box = await getBox(name);
  box.put(key, value);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "App Demo",
        // theme: ThemeData(
        //     appBarTheme: AppBarTheme(
        // backgroundColor: Colors.green[300],
        // foregroundColor: Colors.white)),
        home: UserListScreen());
  }
  // return UserListScreen();
}

class AppBody extends StatefulWidget {
  const AppBody({Key? key}) : super(key: key);

  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('data/users.json');
    final data = await json.decode(response);

    setState(() {
      _users = data['users'];
      // _text = "name: ${data['name']} value: ${data['value']}";
    });
  }

  TextEditingController clr = TextEditingController();
  String text = "start";
  @override
  void initState() {
    super.initState();
    // Hive.openBox("text");
  }

  @override
  Widget build(BuildContext context) {
    // print(Hive.box("text").values);
    // print(Hive.box("text").get("center_text"));
    return Scaffold(
        appBar: AppBar(
          leading: null,
          title: const Align(
              alignment: Alignment.centerLeft, child: Text("JSON Demo")),
          actions: const [
            IconButton(
              onPressed: null,
              icon: Icon(Icons.attach_money_sharp),
              iconSize: 40.0,
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(32),
                child: TextField(
                  controller: clr,
                  onChanged: (text) {
                    print("TEXT: $text");
                    Hive.box("text").put("center_text", text);
                    print("Box: ${Hive.box("text").get("center_text")}");
                    setState(() {
                      text = Hive.box("text").get("center_text");
                    });
                    print("TEXT VAR: $text");
                  },
                ),
              ),
              Text(text),
              // const Text("TEXT ON THE SCREEN")
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      text = Hive.box("text").get("center_text");
                    });
                  },
                  child: const Text("Change Text"))
            ],
          ),
        ));
  }

  // Widget _userList() {
  //   readJson();
  //   return Scaffold(
  //     body: Padding(
  //       padding: const EdgeInsets.all(25),
  //       child: Column(
  //         children: [
  //           // ElevatedButton(
  //           //   child: const Text('Load Data'),
  //           //   onPressed: readJson,
  //           // ),

  //           // Display the data loaded from sample.json
  //           _users.isNotEmpty
  //               ? Expanded(
  //                   child: ListView.builder(
  //                     itemCount: _users.length,
  //                     itemBuilder: (context, index) {
  //                       List _restrictions = _users[index]['restrictions'];
  //                       var rString = '';
  //                       for (var i = 0; i < _restrictions.length - 1; i++) {
  //                         rString += _restrictions[i] + ", ";
  //                       }
  //                       if (_users.isNotEmpty) {
  //                         rString += _restrictions[_restrictions.length - 1];
  //                       }
  //                       return Card(
  //                         margin: const EdgeInsets.all(10),
  //                         child: ListTile(
  //                             leading: Text('User ' + (index + 1).toString()),
  //                             title: Text(_users[index]['name']),
  //                             subtitle: Text("Restrictions: " + rString),
  //                             onTap: () => Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                     builder: (context) => UserRoute()))),
  //                       );
  //                     },
  //                   ),
  //                 )
  //               : Container()
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

// class UserRoute extends StatelessWidget {
//   const UserRoute({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: Text("User Data")),
//         body: Center(child: Text("cuh")));
//   }
// }


// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'Startup Name Generator',
//         theme: ThemeData(
//           appBarTheme: const AppBarTheme(
//             backgroundColor: Colors.white,
//             foregroundColor: Colors.black,
//           ),
//         ),
//         home: RandomWords());
//   }
// }

// class RandomWords extends StatefulWidget {
//   const RandomWords({Key? key}) : super(key: key);

//   @override
//   _RandomWordsState createState() => _RandomWordsState();
// }

// class _RandomWordsState extends State<RandomWords> {
//   final _suggestions = <WordPair>[];
//   final _biggerFontStyle = const TextStyle(fontSize: 18.0);
//   final _saved = <WordPair>{};
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: const Text('Startup Name Generator'), actions: [
//           IconButton(
//             onPressed: _pushSaved,
//             icon: const Icon(Icons.list),
//             tooltip: "Saved Suggestions",
//           )
//         ]),
//         body: _buildSuggestions());
//   }

//   Widget _buildSuggestions() {
//     return ListView.builder(
//         padding: const EdgeInsets.all(16.0),
//         itemBuilder: (context, i) {
//           if (i.isOdd) return const Divider();
//           final index = i ~/ 2; // i // 2
//           if (index >= _suggestions.length) {
//             _suggestions.addAll(generateWordPairs().take(10));
//           }
//           return _buildRow(_suggestions[index]);
//         });
//   }

//   Widget _buildRow(WordPair wordPair) {
//     final alreadySaved = _saved.contains(wordPair);
//     return ListTile(
//         title: Text(wordPair.asPascalCase, style: _biggerFontStyle),
//         trailing: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
//             color: alreadySaved ? Colors.red : null,
//             semanticLabel: alreadySaved ? "Remove from saved" : "save"),
//         onTap: () {
//           setState(() {
//             if (alreadySaved) {
//               _saved.remove(wordPair);
//             } else {
//               _saved.add(wordPair);
//             }
//           });
//         });
//   }

//   void _pushSaved() {
//     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//       final tiles = _saved.map((pair) =>
//           ListTile(title: Text(pair.asPascalCase, style: _biggerFontStyle)));
//       final divided = tiles.isNotEmpty
//           ? ListTile.divideTiles(tiles: tiles, context: context).toList()
//           : <Widget>[];
//       return Scaffold(
//           appBar: AppBar(
//             title: const Text("Saved Suggestions"),
//           ),
//           body: ListView(children: divided));
//     }));
//   }
// }
