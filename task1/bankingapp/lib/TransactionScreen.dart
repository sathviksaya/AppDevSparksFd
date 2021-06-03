import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class TransactionScreen extends StatefulWidget {
  final Map currentUser;
  const TransactionScreen(this.currentUser);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  bool isLoading = true;
  List<Map> list;

  void getTransactions() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'banking.db';
    var database = await openDatabase(
      path,
      version: 1,
    );

    list = await database.rawQuery('''SELECT * FROM Transactions 
        WHERE sender = \"${widget.currentUser['email']}\" OR 
        recipient = \"${widget.currentUser['email']}\";''');
    print(list.toString());
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Transactions",
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                if (list == null) {
                  return Center(
                    child: Text("No Transactions..."),
                  );
                }
                return Text(list[index]['sender']);
              },
            ),
    );
  }
}
