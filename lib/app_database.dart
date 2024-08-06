
// app_database.dart

import 'package:floor/floor.dart';
import 'ah/airplane.dart';
import 'ah/airplane_dao.dart';
import 'item.dart';
import 'item_dao.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

// Add the part directive for the generated file
part 'app_database.g.dart';

@Database(version: 1, entities: [Item, Airplane])
abstract class AppDatabase extends FloorDatabase {
  ItemDao get itemDao;

import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'airplane.dart';
import 'airplane_dao.dart';

part 'app_database.g.dart'; // the generated code will be there

/// The database class for the application.
@Database(version: 1, entities: [Airplane])
abstract class AppDatabase extends FloorDatabase {
  /// Provides access to the [AirplaneDao].

  AirplaneDao get airplaneDao;
}
