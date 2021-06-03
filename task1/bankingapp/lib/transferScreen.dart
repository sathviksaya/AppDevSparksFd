import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'confirmDialog.dart';
import 'main.dart';

class TransferDialog extends StatefulWidget {
  final Map currentUser;
  TransferDialog(this.currentUser);
  @override
  _TransferDialogState createState() => _TransferDialogState();
}

class _TransferDialogState extends State<TransferDialog> {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  double amount = 0.0;
  int recipient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transfer Money"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.play_arrow),
                  SizedBox(
                    width: 5,
                  ),
                  const Text(
                    "Select Recipient",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: InitDB.list.length,
                  itemBuilder: (context, index) {
                    var user = InitDB.list[index];
                    return user['username'] == widget.currentUser['username']
                        ? SizedBox()
                        : ListTile(
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
                            selected: recipient == null
                                ? false
                                : index == recipient
                                    ? true
                                    : false,
                            onTap: () {
                              setState(
                                () => recipient = index,
                              );
                            },
                          );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 100,
                    child: TextFormField(
                      onChanged: (val) {
                        setState(
                          () => amount = double.parse(val),
                        );
                      },
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Please enter amount';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: "Enter Amount...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        if (widget.currentUser['balance'] >= amount) {
                          if (recipient != null) {
                            formKey.currentState.save();
                            FocusScope.of(context).unfocus();
                            showDialog(
                              context: context,
                              builder: (builder) {
                                return ConfirmDialog(amount, widget.currentUser, recipient);
                              },
                            );
                          } else {
                            Fluttertoast.showToast(
                              msg: "Please Select a Recipient...",
                              gravity: ToastGravity.SNACKBAR,
                              toastLength: Toast.LENGTH_SHORT,
                            );
                          }
                        } else {
                          Fluttertoast.showToast(
                            msg: "Insufficient Balance...",
                            gravity: ToastGravity.SNACKBAR,
                            toastLength: Toast.LENGTH_SHORT,
                          );
                        }
                      }
                    },
                    child: Icon(Icons.send),
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
