import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'airplane.dart';
import 'airplane_dao.dart';

part 'app_database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Airplane])
abstract class AppDatabase extends FloorDatabase {
  AirplaneDao get airplaneDao;
}
