import 'package:floor/floor.dart';
import 'airplane.dart';

/// Data Access Object for the [Airplane] entity.
@dao
abstract class AirplaneDao {
  /// Finds all airplanes in the database.
  @Query('SELECT * FROM Airplane')
  Future<List<Airplane>> findAllAirplanes();

  /// Inserts a new airplane into the database.
  @insert
  Future<void> insertAirplane(Airplane airplane);

  /// Updates an existing airplane in the database.
  @update
  Future<void> updateAirplane(Airplane airplane);

  /// Deletes an airplane from the database.
  @delete
  Future<void> deleteAirplane(Airplane airplane);
}
