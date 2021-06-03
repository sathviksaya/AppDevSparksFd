import 'package:bankingapp/transferScreen.dart';
import 'package:flutter/material.dart';

import 'TransactionScreen.dart';

class CustomerScreen extends StatelessWidget {
  final Map user;
  CustomerScreen({this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Padding(
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
              user['username'],
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
                  user['email'],
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
                  user['mobile'].toString(),
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
                  user['balance'].toString(),
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
                        builder: (context) => TransactionScreen(user),
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
                        builder: (context) => TransferDialog(user),
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
