/// Represents a flight with departure and destination details.
///
/// This class models the essential information about a flight, including
/// its unique identifier, departure city, destination city, departure time,
/// and arrival time.
///
/// Author: Khushpreet Kaur
class Flight {
  /// The unique identifier for the flight (optional).
  int? id;

  /// The city from which the flight departs.
  String departureCity;

  /// The city to which the flight is destined.
  String destinationCity;

  /// The scheduled departure time of the flight.
  String departureTime;

  /// The scheduled arrival time of the flight.
  String arrivalTime;

  /// Creates a new `Flight` object with required details.
  ///
  /// The [departureCity], [destinationCity], [departureTime], and [arrivalTime]
  /// parameters are mandatory, while the [id] parameter is optional.
  Flight({
    this.id,
    required this.departureCity,
    required this.destinationCity,
    required this.departureTime,
    required this.arrivalTime,
  });

  /// Converts the `Flight` object into a map for database storage.
  ///
  /// The map's keys correspond to the column names in the database.
  /// If the `id` is not null, it is included in the map.
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'departure_city': departureCity,
      'destination_city': destinationCity,
      'departure_time': departureTime,
      'arrival_time': arrivalTime,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  /// Creates a `Flight` object from a map retrieved from the database.
  ///
  /// The map's keys should correspond to the column names in the database.
  /// This factory constructor is used to instantiate a `Flight` object using
  /// a map, typically when retrieving data from the database.
  ///
  /// Returns a new `Flight` object populated with the map's data.
  factory Flight.fromMap(Map<String, dynamic> map) {
    return Flight(
      id: map['id'],
      departureCity: map['departure_city'],
      destinationCity: map['destination_city'],
      departureTime: map['departure_time'],
      arrivalTime: map['arrival_time'],
    );
  }
}
