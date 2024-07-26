import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:cst2335_summer24/Final_Project/reservation_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize sembast database for web
  final factory = databaseFactoryWeb;
  final db = await factory.openDatabase('app_database.db');

  runApp(MyApp(database: db));
}

class MyApp extends StatelessWidget {
  final Database database;

  MyApp({required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airline Reservation System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ReservationPage(database: database),
    );
  }
}
