import 'package:flutter/material.dart';

import 'customerScreen.dart';
import 'main.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: InitDB.list.length,
      itemBuilder: (context, index) {
        var user = InitDB.list[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Icon(
              Icons.person,
              size: 40,
              color: Colors.green[300],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(user['username']),
            subtitle: Text(user['email']),
            tileColor: Colors.green[50],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerScreen(
                    user: user,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
