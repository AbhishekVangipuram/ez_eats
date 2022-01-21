// import 'dart:developer';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ez_eats/screens/add_user_screen.dart';
import 'package:ez_eats/screens/user_list_screen.dart';
import 'package:ez_eats/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

List _users = [];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "App Demo",
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.green[300],
              foregroundColor: Colors.white)),
      home: const UserListScreen());
  }
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

  bool _fileExists = false;
  File _filePath = File("");

  // First initialization of _json (if there is no json in the file)
  List users_ = [];
  // Map<String, dynamic> _json = {};
  String _jsonString = "";

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/users.json');
  }

  void _writeJson(String name, dynamic restrictions) async {
    // Initialize the local _filePath
    final _filePath = await _localFile;
;
    //1. Create _newJson<Map> from input<TextField>
    Map<String, dynamic> _newJson = {name: restrictions};
    // print('1.(_writeJson) _newJson: $_newJson');

    //2. Update _json by adding _newJson<Map> -> _json<Map>
    users_.add(_newJson);
    // _json.addAll(_newJson);
    print('2.(_writeJson) _json(updated): $users_');

    //3. Convert _json ->_jsonString
    _jsonString = jsonEncode(users_);
    // print('3.(_writeJson) _jsonString: $_jsonString\n - \n');

    //4. Write _jsonString to the _filePath
    try {
      _filePath.writeAsString(_jsonString);
      print("wrote to json");
    } catch (e) {
      // print("tried writing did not work");
    }
  }

  void _readJson() async {
    // Initialize _filePath
    _filePath = await _localFile;
    // print(_filePath.toString());

    // 0. Check whether the _file exists
    _fileExists = await _filePath.exists();
    // print('0. File exists? $_fileExists');

    // If the _file exists->read it: update initialized _json by what's in the _file
    if (_fileExists) {
      try {
        //1. Read _jsonString<String> from the _file.
        _jsonString = await _filePath.readAsString();
        print('1.(_readJson) _jsonString: $_jsonString');

        //2. Update initialized _json by converting _jsonString<String>->_json<Map>
        users_ = jsonDecode(_jsonString);
        print('2.(_readJson) _json: $users_ \n - \n');

      } catch (e) {
        // Print exception errors
        print('Tried reading _file error: $e');
        // If encountering an error, return null
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("before writing to json");
    // print(_json.toString());
    // print(2938478170481273);
    // _writeJson("i added this", ["add1", "add2", "add3"]);
    // print("after writing to json");
    _writeJson("i added this", ["add1", "add2", "add3"]);
    _writeJson("idk", ["bruh", "bruh", "bruh"]);

    _readJson();
    //print(_users[0]);
    // _users = _json['users'];
    // print(_json[0]);
    // print(_users[0]['restrictions']);

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
      // body: user_widget()
    );
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
