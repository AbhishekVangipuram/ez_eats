// import 'package:ez_eats/users.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(leading: null, title: const Text("Lorem Ipsum"), actions: []),
      body: Center(
          child: Container(
              padding: const EdgeInsets.only(
                  left: 40, right: 40, top: 10, bottom: 10),
              child: ListView(
                  children: [
										_allergyTile("Dairy", false),
										 _allergyTile("Soy", false)
								 ]
						 )
						)
					),
    );
  }

  Widget _allergyTile(String label, bool? value) {
    return CheckboxListTile(
				value: value,
				onChanged: onChanged
			);
  }
}
