import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:ez_eats/screens/add_user_screen.dart';
import 'package:ez_eats/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'add_user_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserListScreen extends StatefulWidget {
  UserListScreen({Key? key}) : super(key: key);

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  bool _fileExists = false;
  File _filePath = File("");

  // First initialization of _json (if there is no json in the file)
  List users_ = [];
  List userChecks = [];
  FToast noUsersSelected = FToast();
  // Map<String, dynamic> _json = {};
  String _jsonString = "";

  TextEditingController controller = TextEditingController();

  Map<String, bool> responses = {
    'Dairy': false,
    'Egg': false,
    'Fish': false,
    'Mushroom': false,
    'Peanuts': false,
    'Sesame': false,
    'Shellfish': false,
    'Soy': false,
    'Tree Nut': false,
    'Vegan': false,
    'Vegetarian': false,
    'Wheat': false
  };

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/users.json');
  }

  void writeJson(String name, dynamic restrictions) async {
    // Initialize the local _filePath
    final _filePath = await _localFile;
    ;
    //1. Create _newJson<Map> from input<TextField>
    Map<String, dynamic> _newJson = {
      "name": name,
      "restrictions": restrictions
    };
    // print('1.(writeJson) _newJson: $_newJson');

    //2. Update _json by adding _newJson<Map> -> _json<Map>
    users_.add(_newJson);
    userChecks.add(false);
    // _json.addAll(_newJson);
    // print('2.(writeJson) _json(updated): $users_');

    //3. Convert _json ->_jsonString
    _jsonString = jsonEncode(users_);
    // print('3.(writeJson) _jsonString: $_jsonString\n - \n');

    //4. Write _jsonString to the _filePath
    try {
      _filePath.writeAsString(_jsonString);
      // print("wrote to json");
    } catch (e) {
      print("tried writing did not work. File Error: $e");
    }
  }

  void readJson() async {
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
        setState(() {
          _jsonString = _jsonString;
        });
        // print('1.(readJson) _jsonString: $_jsonString');

        //2. Update initialized _json by converting _jsonString<String>->_json<Map>
        setState(() {
          users_ = jsonDecode(_jsonString);
        });
        // print('2.(readJson) _json: $users_ \n - \n');
        // print(users_.length);
        // NAME
        // print(users_[1]['name']);
        // RESTRICTIONS LIST
        // print(users_[1]['restrictions']);
      } catch (e) {
        // Print exception errors
        print('Tried reading _file error: $e');
        // If encountering an error, return null
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // writeJson("Jimmy", ["Peanuts", "Tree nuts"]);
    // writeJson("bruh", ["Vegetarian"]);
    Hive.box("selected").putAll(responses);
    readJson();
    noUsersSelected.init(context);
  }

  @override
  Widget build(BuildContext context) {
    readJson();
    Hive.openBox("selected");
    if (users_.length > userChecks.length || userChecks.isEmpty) {
      userChecks = List.filled(users_.length, false, growable: true);
    }
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    Widget userList = Expanded(
      child: SingleChildScrollView(
          child: Column(children: [
        if (users_.isEmpty) noUsersTile(),
        for (var i = 0; i < users_.length; i++)
          _userTile(users_[i]['name'], users_[i]['restrictions'], i, context)
      ])),
    );

    return Scaffold(
        body: SafeArea(
            child: Center(
                child: Container(
                    padding: EdgeInsets.only(
                      // top: 0.02 * deviceHeight,
                      bottom: deviceHeight * 0.025,
                      // left: 0.05 * deviceWidth,
                      // right: 0.05 * deviceWidth),
                    ),
                    child: Column(children: [
                      logoBar(context),
                      space(20, 0),
                      userList,
                      space(20, 0),
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 0.05 * deviceWidth),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              searchButton(context),
                              _addUserButton(),
                            ],
                          )),
                    ])))));
  }

  Widget space(double height, double width) {
    return SizedBox(height: height, width: width);
  }

  Widget _userTile(
      String name, List restrictions, int idx, BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    String rStr = restrictions
        .fold("", (prev, element) => '$prev, $element')
        .substring(2);
    return Container(
        padding: EdgeInsets.only(
            left: 0.05 * deviceWidth, right: 0.05 * deviceWidth, bottom: 15),
        child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(10),
            clipBehavior: Clip.antiAlias,
            child: CheckboxListTile(
                title: Text(name),
                subtitle: Text(rStr),
                value: userChecks[idx],
                onChanged: (value) {
                  setState(() {
                    userChecks[idx] = value!;
                  });
                })));
  }

  Widget noUsersTile() {
    return Container(
        padding: const EdgeInsets.only(bottom: 15),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "No users added.\n",
            style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontStyle: FontStyle.italic),
          ),
        ));
  }

  Widget searchButton(BuildContext context) {
    int sCount = 0;
    return Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(9),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
            onTap: () {
              Hive.box("selected").flush();
              Hive.box("selected").putAll(responses);

              for (var i = 0; i < users_.length; i++) {
                bool sel = userChecks[i];
                List rest = users_[i]['restrictions'];
                if (sel) {
                  sCount++;
                  for (var v = 0; v < rest.length; v++) {
                    Hive.box("selected").put(rest[v], true);
                  }
                }
              }
              if (sCount > 0) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              } else {
                _showNoUserSelectedToast();
              }
            },
            child: Container(
                padding: const EdgeInsets.all(8),
                height: 40,
                width: 40,
                child: Ink.image(
                  image: const AssetImage("assets/images/loupe.png"),
                  fit: BoxFit.contain,
                ))));
  }

  Widget _addUserButton() {
    // use either OutlinedButton or ElevatedButton
    // padding: const EdgeInsets.symmetric(horizontal: 95),
    return Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(9),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return _addUserDialog(context);
                  });
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => const AddUserScreen()));
            },
            child: Container(
                padding: const EdgeInsets.all(8),
                height: 40,
                width: 40,
                child: Ink.image(
                  image: const AssetImage("assets/images/add-user.png"),
                  fit: BoxFit.contain,
                ))));

    //   child: ElevatedButton.icon(
    //     onPressed: () {
    //       Navigator.push(context, MaterialPageRoute(builder: (context) => const AddUserScreen()));
    //     },
    //     // icon: const Icon(Icons.add),
    //     icon: Image.asset("assets/images/Adduserbutton.png",
    //     fit: BoxFit.cover,),
    //     label: const Text(""))
    // );
  }

  Widget _addUserDialog(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 16,
        child: Container(
            padding:
                const EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
            // could use ListView.Builder
            child: Column(children: [
              _nameInput(),
              Flexible(
                // constraints:
                //     const BoxConstraints(maxHeight: 300),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return ListView(
                      children: responses.keys.map((String key) {
                        return CheckboxListTile(
                          enableFeedback: true,
                          selected: false,
                          title: Text(key),
                          value: responses[key],
                          onChanged: (bool? value) {
                            setState(() {
                              responses[key] = value!;
                            });
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              _saveButton(context)
            ])));
  }

  Widget _nameInput() {
    return Container(
        padding: const EdgeInsets.all(16),
        child: TextField(
            decoration: const InputDecoration(
                // PUT OTHER DECORATORS HERE MAYBE
                labelText: "Name"),
            controller: controller));
  }

  Widget _saveButton(BuildContext context) {
    // return ElevatedButton.icon(
    //     onPressed: () {
    //       // ********************
    //       // WRITE TO JSON
    //       // ********************
    //       String _name = controller.text;
    //       List restrictions = [];
    //       for (String key in responses.keys) {
    //         if (responses[key]!) {
    //           restrictions.add(key);
    //         }
    //       }
    //       writeJson(_name, restrictions);
    //       Navigator.pop(context);
    //     },
    //     icon: const Icon(Icons.save_outlined),
    //     label: const Text("Save"));

    return TextButton.icon(
        onPressed: () {
          // ********************
          // WRITE TO JSON
          // ********************
          String _name = controller.text;
          List restrictions = [];
          for (String key in responses.keys) {
            if (responses[key]!) {
              restrictions.add(key);
              responses[key] = false;
            }
          }

          if (_name.isEmpty) {
            _showNoNameToast();
          } else if (restrictions.length < 1) {
            _showNoRestrictionsToast();
          } else {
            writeJson(_name, restrictions);
            controller.clear();
            Navigator.pop(context);
          }
        },
        icon: const Icon(Icons.save_outlined, color: Colors.green),
        label: const Text("SAVE", style: TextStyle(color: Colors.green)));
  }

  Widget logoBar(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Container(
        padding: EdgeInsets.only(
            left: 0.05 * deviceWidth, right: 0.05 * deviceWidth),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset("assets/images/logo.png"),
            const SizedBox(width: 7),
            RichText(
              text: TextSpan(
                text: "Ez Eats",
                style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            )
          ],
        ));
  }

  _showNoUserSelectedToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.orangeAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.error_outline),
          SizedBox(
            width: 12.0,
          ),
          Text("No Users Selected!"),
        ],
      ),
    );

    noUsersSelected.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 1, milliseconds: 500),
    );
  }

  _showNoNameToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.orangeAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.error_outline),
          SizedBox(
            width: 12.0,
          ),
          Text("Please Type a Name!"),
        ],
      ),
    );

    noUsersSelected.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 1, milliseconds: 500),
    );
  }

  _showNoRestrictionsToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.orangeAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.error_outline),
          SizedBox(
            width: 12.0,
          ),
          Text("Select at Least One Restriction!"),
        ],
      ),
    );

    noUsersSelected.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 1, milliseconds: 500),
    );
  }
}
