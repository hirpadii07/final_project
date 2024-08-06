// main.dart

import 'package:flutter/material.dart';
import 'package:final_project_android/hp/home_screen.dart'; // Customer list page
import 'ah/airplane_list_page.dart'; // Airplane list page
import 'ks/flight_form.dart'; // Flight form page
import 'hk/reservation_page.dart'; // Reservation page
import 'app_database.dart' as floorDB; // Unified Floor database
import 'package:sembast/sembast.dart' as sembastDB;
import 'package:sembast_web/sembast_web.dart'; // Ensure web support for Sembast

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the Floor database
  final floorDatabase = await floorDB.$FloorAppDatabase.databaseBuilder('app_database.db').build();

  // Initialize the Sembast database for web
  final sembastFactory = databaseFactoryWeb;
  final sembastDatabase = await sembastFactory.openDatabase('app_database_sembast.db');

  runApp(MyApp(
    floorDatabase: floorDatabase,
    sembastDatabase: sembastDatabase,
    changeLanguage: (Locale locale) {
      // Handle language change logic
    },
  ));
}

class MyApp extends StatelessWidget {
  final floorDB.AppDatabase floorDatabase;
  final sembastDB.Database sembastDatabase;
  final Function(Locale) changeLanguage;

  MyApp({
    required this.floorDatabase,
    required this.sembastDatabase,
    required this.changeLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(
        floorDatabase: floorDatabase,
        sembastDatabase: sembastDatabase,
        changeLanguage: changeLanguage,
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  final floorDB.AppDatabase floorDatabase;
  final sembastDB.Database sembastDatabase;
  final Function(Locale) changeLanguage;

  MainPage({
    required this.floorDatabase,
    required this.sembastDatabase,
    required this.changeLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Project Main Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              _showInstructions(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(setLocale: changeLanguage),
                  ),
                );
              },
              child: Text('Customer List'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AirplaneListPage(
                      database: floorDatabase,
                      changeLanguage: changeLanguage,
                    ),
                  ),
                );
              },
              child: Text('Airplane List'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlightForm(
                      updateFlightList: () {},
                      changeLanguage: changeLanguage,
                    ),
                  ),
                );
              },
              child: Text('Flight Form'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReservationPage(
                      database: sembastDatabase,
                      onLanguageChanged: changeLanguage,
                    ),
                  ),
                );
              },
              child: Text('Reservation Page'),
            ),
          ],
        ),
      ),
    );
  }

  void _showInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Instructions'),
          content: Text('Navigate to each page to manage customers, airplanes, flights, and reservations.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
