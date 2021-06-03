import 'package:flutter/material.dart';

import 'customerScreen.dart';

class HomeScreen extends StatelessWidget {

  final List<Map> list;
  HomeScreen(this.list);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        var user = list[index];
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
                    id: index,
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
