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

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_database.dart';
import 'airplane_list_page.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';
import 'localization.dart';

/// The entry point of the application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  runApp(MyApp(database: database));
}

/// The root widget of the application.
class MyApp extends StatefulWidget {
  /// The database instance.
  final AppDatabase database;

  /// Creates an instance of MyApp.
  MyApp({required this.database});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// The current locale of the application.
  Locale _locale = Locale('en', 'US');

  /// Changes the language of the application.
  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      locale: _locale,
      localizationsDelegates: [
        LocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', 'US'),
        Locale('en', 'GB'),
      ],
      home: AirplaneListPage(database: widget.database, changeLanguage: _changeLanguage),

    );
  }
}
