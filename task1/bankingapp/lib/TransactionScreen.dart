import 'package:flutter/material.dart';

class TransactionScreen extends StatelessWidget {
  final Map currentUser;
  const TransactionScreen(this.currentUser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Transactions",
        ),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Text("alalal");
        },
      ),
    );
  }
}
