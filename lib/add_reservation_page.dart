import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddReservationPage extends StatefulWidget {
  @override
  _AddReservationPageState createState() => _AddReservationPageState();
}

class _AddReservationPageState extends State<AddReservationPage> {
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  List<Map<String, String>> _flights = [];
  List<Map<String, String>> _filteredFlights = [];
  String? _selectedFlight;
  String? _departureCity;
  String? _destinationCity;

  final List<String> _cities = [
    'Toronto',
    'Vancouver',
    'Montreal',
    'Calgary',
    'Ottawa'
  ];

  @override
  void initState() {
    super.initState();
    _loadFlights();
  }

  void _loadFlights() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? flightList = prefs.getStringList('flights');
    if (flightList != null) {
      setState(() {
        _flights = flightList
            .map((e) => Map<String, String>.from(json.decode(e)))
            .toList();
      });
    } else {
      // Initialize with some predefined flights if no flights are saved in SharedPreferences
      _flights = [
        {
          'flightNumber': 'AC 456',
          'route': 'Toronto to Vancouver',
          'time': '08:00 AM'
        },
        {
          'flightNumber': 'AC 457',
          'route': 'Toronto to Vancouver',
          'time': '12:00 PM'
        },
        {
          'flightNumber': 'AC 345',
          'route': 'Toronto to Vancouver',
          'time': '06:00 PM'
        },
        {
          'flightNumber': 'AC 123',
          'route': 'Toronto to Montreal',
          'time': '09:00 AM'
        },
        {
          'flightNumber': 'AC 124',
          'route': 'Toronto to Montreal',
          'time': '03:00 PM'
        },
        {
          'flightNumber': 'AC 125',
          'route': 'Toronto to Calgary',
          'time': '11:00 AM'
        },
      ];
      _saveFlights();
    }
  }

  void _saveFlights() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> flightList = _flights.map((e) => json.encode(e)).toList();
    prefs.setStringList('flights', flightList);
  }

  void _filterFlights() {
    if (_departureCity != null && _destinationCity != null) {
      setState(() {
        _filteredFlights = _flights
            .where((flight) =>
        flight['route'] == '$_departureCity to $_destinationCity')
            .toList();
        _selectedFlight = null;
      });
    }
  }

  void _submitReservation() {
    if (_customerController.text.isEmpty ||
        _selectedFlight == null ||
        _dateController.text.isEmpty) {
      _showSnackbar('Please fill all fields');
      return;
    }

    if (!_isValidDate(_dateController.text)) {
      _showSnackbar('Invalid date format. Use DD-MM-YYYY.');
      return;
    }

    final reservation = {
      'customer': _customerController.text,
      'flight': _selectedFlight!,
      'date': _dateController.text,
    };

    Navigator.pop(context, reservation);
  }

  bool _isValidDate(String date) {
    final regex = RegExp(r'^\d{2}-\d{2}-\d{4}$');
    return regex.hasMatch(date);
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Reservation'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _customerController,
                  decoration: InputDecoration(
                    labelText: 'Customer',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _departureCity,
                  hint: Text('Select Departure City'),
                  items: _cities.map((city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _departureCity = value;
                      _filterFlights();
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _destinationCity,
                  hint: Text('Select Destination City'),
                  items: _cities.map((city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(city),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _destinationCity = value;
                      _filterFlights();
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedFlight,
                  hint: Text('Select Flight'),
                  items: _filteredFlights.map((flight) {
                    return DropdownMenuItem<String>(
                      value: flight['flightNumber'],
                      child: Text(
                          '${flight['flightNumber']} - ${flight['route']} at ${flight['time']}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFlight = value;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Date (DD-MM-YYYY)',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'\d|-')),
                    DateInputFormatter(),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Submit Reservation'),
                  onPressed: _submitReservation,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    final newTextLength = newValue.text.length;
    final oldTextLength = oldValue.text.length;

    if (newTextLength > oldTextLength) {
      if (newTextLength == 2 || newTextLength == 5) {
        text += '-';
      }
    } else if (newTextLength < oldTextLength) {
      if (newTextLength == 3 || newTextLength == 6) {
        text = text.substring(0, newTextLength - 1);
      }
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
