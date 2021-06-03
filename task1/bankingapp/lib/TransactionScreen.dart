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
  bool filter = true;

  void getTransactions() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'banking.db';
    var database = await openDatabase(
      path,
      version: 1,
    );

    list = await database.rawQuery('''SELECT * FROM Transactions 
        WHERE sender = \"${widget.currentUser['username']}\" OR 
        recipient = \"${widget.currentUser['username']}\";''');
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
          : list == []
              ? Center(
                  child: const Text("No Transactions..."),
                )
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Filter: ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          filter ? "Latest first" : "Latest last",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Switch(
                            value: filter,
                            onChanged: (val) {
                              setState(() {
                                filter = val;
                              });
                            })
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height - 150,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          var transaction = filter
                              ? list[list.length - index - 1]
                              : list[index];
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: widget.currentUser['username'] ==
                                      transaction['sender']
                                  ? Colors.red[300]
                                  : Colors.green[300],
                              child: ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        transaction['sender'],
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward),
                                      Text(
                                        transaction['recipient'],
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                subtitle: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          const Text(
                                            "Amount Transferred:",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Rs. " +
                                                transaction['amount']
                                                    .toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          const Text(
                                            "Transferred On:",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            transaction['date'].toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          const Text(
                                            "Current Balance:",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            widget.currentUser['username'] ==
                                                    transaction['sender']
                                                ? "Rs. ${transaction['senderBalance'].toStringAsFixed(2)}"
                                                : "Rs. ${transaction['recipientBalance'].toStringAsFixed(2)}",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
