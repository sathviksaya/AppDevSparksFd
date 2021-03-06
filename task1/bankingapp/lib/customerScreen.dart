import 'package:bankingapp/transferScreen.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'TransactionScreen.dart';

class CustomerScreen extends StatefulWidget {
  final int id;
  CustomerScreen({this.id});

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  List<Map> list;
  bool isLoading = true;

  void getList() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'banking.db';
    Database database = await openDatabase(
      path,
      version: 1,
    );
    list = await database.rawQuery('SELECT * FROM Users');
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(20, 70, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    child: Icon(
                      Icons.person,
                      size: 80,
                    ),
                    maxRadius: 60,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    list[widget.id]['username'],
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.email),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        list[widget.id]['email'],
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.phone),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        list[widget.id]['mobile'].toString(),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.account_balance),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        list[widget.id]['balance'].toString(),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text("Last Transactions"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TransactionScreen(list[widget.id]),
                            ),
                          );
                        },
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text("Transfer Money"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TransferDialog(list[widget.id]),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
