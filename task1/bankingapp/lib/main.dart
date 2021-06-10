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
    // await deleteDatabase(path);      //comment this line, if you want your transactions to persist.
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
          ("Bruce Banner", "bruce@gmail.com", 9362836483, 250000), 
          ("Vision", "vision@gmail.com", 8291447287, 100000),
          ("TChalla", "tchalla@gmail.com", 8204753843, 800000),
          ("Peter Parker", "peter@yahoo.com", 997256643, 8000),
          ("Thor", "thor@gmail.com", 6367682683, 1000),
          ("Steve Rogers", "steve@gmail.com", 9731601403, 25000), 
          ("Tony Stark", "tony@gmail.com", 9123834234, 5000000),
          ("Clint Barton", "clint@gmail.com", 9462327856, 35000),
          ("Natasha Romanoff", "natasha@yahoo.com", 7291644860, 35000),
          ("Wanda", "wanda@gmail.com", 7482783966, 40000);''');
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
