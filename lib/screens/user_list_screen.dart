import 'package:ez_eats/screens/add_user_screen.dart';
import 'package:ez_eats/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'add_user_screen.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: null, title: const Text("User List"), actions: []),
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
          // use ListView or ListView.Builder
          child: ListView(children: [
            _userTile(),
            _userTile(),
            _addUserButton(context),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SearchScreen()));
              }, 
              child: const Text("Done"))
          ]
          )
        )
      )
    );
  }

  Widget _userTile() {
    return const ListTile(title:  Text("NAME"), subtitle:  Text("allergies: "), onTap: null,);
  }

  Widget _addUserButton(BuildContext context) {
    // use either OutlinedButton or ElevatedButton
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 95),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddUserScreen()));
        },
        icon: const Icon(Icons.add),
        label: const Text("Add User"))
    );
  }
}
