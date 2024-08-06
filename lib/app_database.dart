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
  AirplaneDao get airplaneDao;
}
