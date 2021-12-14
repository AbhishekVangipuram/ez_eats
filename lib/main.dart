import 'dart:developer';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  // final jsonEncoder = JsonEncoder();
  // print(jsonEncoder.convert('users.json'));
  readJson();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/sample.json');
    final data = await json.decode(response);
    print(data['name']);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "JSON Demo",
        theme: ThemeData(
            appBarTheme: AppBarTheme(
                backgroundColor: Colors.blue[300],
                foregroundColor: Colors.white)),
        home: const AppBody());
  }
}

class AppBody extends StatefulWidget {
  const AppBody({Key? key}) : super(key: key);

  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final _textWidget = FutureBuilder<DocumentSnapshot>(
    //     future: FirebaseFirestore.instance
    //         .collection('restaurants')
    //         .doc("McDonald's")
    //         .get(),
    //     builder: (context, snapshot) {
    //       try {
    //         if (snapshot.hasData) {
    //           final data = snapshot.data!.data() as Map<String, dynamic>;
    //           return Text("Snapshot Data: ${data['menu'][1].entries}");
    //         } else if (snapshot.hasError) {
    //           return Text("Snapshot Error: ${snapshot.error}");
    //         } else {
    //           return const Text("???");
    //         }
    //       } catch (e) {
    //         return Text("Error: $e");
    //       }
    //     });

    return Scaffold(
        appBar: AppBar(
            title: const Align(
                alignment: Alignment.centerLeft,
                child: Text("Firebase Demo"))));
    // body: Align(alignment: Alignment.center, child: _restaurantList()));
  }
}



//   Widget _restaurantList() {
//     return FutureBuilder<QuerySnapshot>(
//         future: FirebaseFirestore.instance.collection('restaurants').get(),
//         builder: (context, snapshot) {
//           final names = snapshot.data!.docs.map((doc) => doc["name"]).toList();
//           final allData = snapshot.data!.docs.map((doc) => doc.data()).toList();
//           return ListView.builder(
//               shrinkWrap: false,
//               itemCount: 100,
//               itemBuilder: (context, i) {
//                 try {
//                   return ListTile(
//                       title: Text(names[i],
//                           style: const TextStyle(fontSize: 24.0)));
//                   // onTap: () => Navigator.push(
//                   //     context,
//                   //     MaterialPageRoute(
//                   //         builder: (context) => const MenuRoute())));
//                 } catch (e) {
//                   // log(e.toString());
//                   return const SizedBox.shrink();
//                 }
//               });
//         });
//   }
// }

// class MenuRoute extends StatelessWidget {
//   const MenuRoute({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: const Text("Menu")), body: _menuList());
//   }

//   Widget _menuList() {
//     return FutureBuilder<>(builder: builder)
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
