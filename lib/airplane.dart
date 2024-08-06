import 'package:floor/floor.dart';

/// Represents an airplane entity in the database.
@entity
class Airplane {
  /// The unique identifier of the airplane.
  @primaryKey
  final int id;

  /// The type of the airplane.
  final String type;

  /// The number of passengers the airplane can carry.
  final int passengers;

  /// The speed of the airplane.
  final int speed;

  /// The range of the airplane.
  final int range;

  /// Creates a new [Airplane] instance.
  Airplane({required this.id, required this.type, required this.passengers, required this.speed, required this.range});

  /// Creates a new [Airplane] instance from a JSON object.
  factory Airplane.fromJson(Map<String, dynamic> json) {
    return Airplane(
      id: json['id'],
      type: json['type'],
      passengers: json['passengers'],
      speed: json['speed'],
      range: json['range'],
    );
  }

  /// Converts the [Airplane] instance to a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'passengers': passengers,
      'speed': speed,
      'range': range,
    };
  }
}
