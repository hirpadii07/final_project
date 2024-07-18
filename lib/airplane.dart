import 'package:floor/floor.dart';

@entity
class Airplane {
  @primaryKey
  final int id;
  final String type;
  final int passengers;
  final int speed;
  final int range;

  Airplane({required this.id, required this.type, required this.passengers, required this.speed, required this.range});

  factory Airplane.fromJson(Map<String, dynamic> json) {
    return Airplane(
      id: json['id'],
      type: json['type'],
      passengers: json['passengers'],
      speed: json['speed'],
      range: json['range'],
    );
  }

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
