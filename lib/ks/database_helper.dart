import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Author: Khushpreet Kaur
///
/// A helper class for managing the SQLite database.
class DatabaseHelper {
  /// The singleton instance of the DatabaseHelper.
  static final DatabaseHelper instance = DatabaseHelper._instance();

  /// The database instance.
  static Database? _db;

  /// Private constructor for creating an instance of DatabaseHelper.
  DatabaseHelper._instance();

  /// The name of the flight table.
  final String flightTable = 'flight_table';

  /// The column name for the ID.
  final String colId = 'id';

  /// The column name for the departure city.
  final String colDepartureCity = 'departure_city';

  /// The column name for the destination city.
  final String colDestinationCity = 'destination_city';

  /// The column name for the departure time.
  final String colDepartureTime = 'departure_time';

  /// The column name for the arrival time.
  final String colArrivalTime = 'arrival_time';

  /// Gets the database instance, initializing it if necessary.
  ///
  /// Returns a Future that resolves to the database instance.
  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db!;
  }

  /// Initializes the database.
  ///
  /// Returns a Future that resolves to the initialized database.
  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'flights.db');

    final flightDb = await openDatabase(path, version: 1, onCreate: _createDb);
    return flightDb;
  }

  /// Creates the flight table in the database.
  ///
  /// [db] is the database instance.
  /// [version] is the version of the database.
  Future<void> _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $flightTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colDepartureCity TEXT, '
          '$colDestinationCity TEXT, $colDepartureTime TEXT, $colArrivalTime TEXT)',
    );
  }

  /// Retrieves the list of flights from the database.
  ///
  /// Returns a Future that resolves to a list of maps representing the flight data.
  Future<List<Map<String, dynamic>>> getFlightMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(flightTable);
    return result;
  }

  /// Inserts a flight into the database.
  ///
  /// [row] is a map representing the flight data.
  ///
  /// Returns a Future that resolves to the number of rows affected.
  Future<int> insertFlight(Map<String, dynamic> row) async {
    Database db = await this.db;
    final int result = await db.insert(flightTable, row);
    return result;
  }

  /// Updates a flight in the database.
  ///
  /// [row] is a map representing the flight data.
  ///
  /// Returns a Future that resolves to the number of rows affected.
  Future<int> updateFlight(Map<String, dynamic> row) async {
    Database db = await this.db;
    final int result = await db.update(flightTable, row, where: '$colId = ?', whereArgs: [row[colId]]);
    return result;
  }

  /// Deletes a flight from the database.
  ///
  /// [id] is the identifier of the flight to be deleted.
  ///
  /// Returns a Future that resolves to the number of rows affected.
  Future<int> deleteFlight(int id) async {
    Database db = await this.db;
    final int result = await db.delete(flightTable, where: '$colId = ?', whereArgs: [id]);
    return result;
  }
}
