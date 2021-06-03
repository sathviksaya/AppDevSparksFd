import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'main.dart';

class ConfirmDialog extends StatelessWidget {
  final int recipient;
  final double amount;
  final Map currentUser;
  ConfirmDialog(this.amount, this.currentUser, this.recipient);

  void finishTransfer() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'banking.db';
    var database = await openDatabase(
      path,
      version: 1,
    );

    List<Map> list = await database.rawQuery('SELECT * FROM Users');
    var date = DateTime.now().toString().split(" ")[0];
    double senderBalance = currentUser['balance'] - amount;
    double recipientBalance = list[recipient]['balance'] + amount;

    database.rawInsert(
      '''INSERT INTO Transactions (Sender, Recipient, Date1, Amount, SenderB, RecipientB) 
      VALUES (\"${currentUser['username']}\", 
      \"${currentUser[recipient]['username']}\", 
      \"$date\", 
      $amount, 
      $senderBalance, 
      $recipientBalance);''',
    );

    database.rawUpdate(
      '''UPDATE Users 
      SET Balance = $senderBalance 
      WHERE Email = \"${currentUser['email']}\";''',
    );

    database.execute(
      ''' UPDATE Users 
      SET Balance = $recipientBalance 
      WHERE Email = \"${list[recipient]['email']}\";''',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 10,
        sigmaY: 10,
      ),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.23,
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Confirm Transfer",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              const Text(
                "Do you really want to transfer",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Rs.${amount.toString()}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.arrow_forward),
                  Text(
                    "${InitDB.list[recipient]['username']}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: TextButton(
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Container(
                    width: 1,
                    height: MediaQuery.of(context).size.height * 0.04,
                    color: Colors.grey[200],
                  ),
                  Center(
                    child: TextButton(
                      child: const Text(
                        "Confirm",
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                      onPressed: () {
                        finishTransfer();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
