import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_database.dart';
import 'airplane_list_page.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;

  MyApp({required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AirplaneListPage(database: database),
    );
  }
}
