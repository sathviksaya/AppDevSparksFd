import 'package:bankingapp/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: InitDB(),
    );
  }
}

class InitDB extends StatefulWidget {
  @override
  _InitDBState createState() => _InitDBState();
}

class _InitDBState extends State<InitDB> {
  bool isLoading = true;
  List<Map> list;

  @override
  void initState() {
    initDatabase();
    super.initState();
  }

  void initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + 'banking.db';
    // await deleteDatabase(path);
    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''CREATE TABLE Users (
          id int auto_increment primary key,
          username varchar(20) not NULL, 
          email varchar(20) not NULL unique, 
          mobile int not NULL, 
          balance double not NULL);''');

        await db.execute('''CREATE TABLE Transactions(  
            trId int auto_increment primary key,        
            sender varchar(20),
            recipient varchar(20),
            date varchar(10),
            amount double,
            senderBalance double,
            recipientBalance double);''');

        await db.execute(''' 
          INSERT INTO Users(username, email, mobile, balance) 
          VALUES 
          ("Max Joseph", "sam12345@gmail.com", 5587946632, 1456.789), 
          ("Jose Marcel", "marceljose@gmail.com", 8565488932, 15502.32),
          ("Rose Query", "rose1996@gmail.com", 776933156, 9502.15),
          ("Walt Greffor", "mwaltgreffor@yahoo.com", 6697553216, 42100.05),
          ("Britney Villstone", "vilstone123@gmail.com", 7769883215, 12500.5),
          ("Steve Rogers", "steve@gmail.com", 7860274874, 13446.789), 
          ("Tony Stark", "tony@gmail.com", 03928475934, 1550345.32),
          ("Clint Barton", "clint@gmail.com", 39329834134, 95556.15),
          ("Natasha Romanoff", "nat@yahoo.com", 23094798375, 43400.05),
          ("Wanda", "wanda@gmail.com", 2136383243, 12500.5);''');
      },
    );
    list = await database.rawQuery('SELECT * FROM Users');

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Customers"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : HomeScreen(list),
    );
  }
}
