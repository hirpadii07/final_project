import 'package:flutter/material.dart';
import 'secure_storage_helper.dart';
import 'database_helper.dart';
import 'flight.dart';
import 'app_localizations.dart';

/// Author: Khushpreet Kaur
///
/// A form for adding or updating a flight.
class FlightForm extends StatefulWidget {
  /// The flight to be updated, or null if adding a new flight.
  final Flight? flight;

  /// A callback function to update the flight list.
  final Function updateFlightList;

  final Function(Locale) changeLanguage;

  /// Creates a [FlightForm] widget.
  ///
  /// The [updateFlightList] parameter is required.
  FlightForm({
    this.flight,
    required this.updateFlightList,
    required this.changeLanguage,
  });

  @override
  _FlightFormState createState() => _FlightFormState();
}

/// The state for the [FlightForm] widget.
class _FlightFormState extends State<FlightForm> {
  /// The form key for the flight form.
  final _formKey = GlobalKey<FormState>();

  /// The helper for managing secure storage.
  final SecureStorageHelper _storageHelper = SecureStorageHelper();

  /// The departure city of the flight.
  late String _departureCity;

  /// The destination city of the flight.
  late String _destinationCity;

  /// The departure time of the flight.
  late String _departureTime;

  /// The arrival time of the flight.
  late String _arrivalTime;

  /// Initializes the state of the [FlightForm] widget.
  @override
  void initState() {
    super.initState();
    if (widget.flight != null) {
      _departureCity = widget.flight!.departureCity;
      _destinationCity = widget.flight!.destinationCity;
      _departureTime = widget.flight!.departureTime;
      _arrivalTime = widget.flight!.arrivalTime;
    } else {
      _initializeFields();
    }
  }

  /// Initializes fields with default values.
  void _initializeFields() {
    _departureCity = '';
    _destinationCity = '';
    _departureTime = '';
    _arrivalTime = '';
    _loadSavedData();
  }

  /// Loads saved data from secure storage.
  Future<void> _loadSavedData() async {
    _departureCity = await _storageHelper.getData('departureCity') ?? '';
    _destinationCity = await _storageHelper.getData('destinationCity') ?? '';
    _departureTime = await _storageHelper.getData('departureTime') ?? '';
    _arrivalTime = await _storageHelper.getData('arrivalTime') ?? '';
    setState(() {});
  }

  /// Saves data to secure storage.
  Future<void> _saveData() async {
    await _storageHelper.saveData('departureCity', _departureCity);
    await _storageHelper.saveData('destinationCity', _destinationCity);
    await _storageHelper.saveData('departureTime', _departureTime);
    await _storageHelper.saveData('arrivalTime', _arrivalTime);
  }

  /// Submits the form and saves the flight data to the database.
  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _saveData();

      Flight flight = Flight(
        departureCity: _departureCity,
        destinationCity: _destinationCity,
        departureTime: _departureTime,
        arrivalTime: _arrivalTime,
      );

      if (widget.flight == null) {
        DatabaseHelper.instance.insertFlight(flight.toMap()).then((_) {
          _showSnackbar(AppLocalizations.of(context).translate('flight_added'));
        });
      } else {
        flight.id = widget.flight!.id;
        DatabaseHelper.instance.updateFlight(flight.toMap()).then((_) {
          _showSnackbar(
              AppLocalizations.of(context).translate('flight_updated'));
        });
      }

      widget.updateFlightList();
      Navigator.pop(context);
    }
  }

  /// Shows a snackbar with a specified message.
  ///
  /// [message] is the message to display in the snackbar.
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  /// Builds the widget tree for the [FlightForm].
  ///
  /// [context] is the build context.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.flight == null
            ? AppLocalizations.of(context).translate('add_flight')
            : AppLocalizations.of(context).translate('update_flight')),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.language), // Added language icon
            onSelected: (value) {
              if (value == 'en') {
                widget.changeLanguage(Locale('en'));
              } else if (value == 'it') {
                widget.changeLanguage(Locale('it'));
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'en',
                  child: Row(
                    children: [
                      Icon(Icons.translate),
                      SizedBox(width: 8),
                      Text(AppLocalizations.of(context).translate('english')),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'it',
                  child: Row(
                    children: [
                      Icon(Icons.translate),
                      SizedBox(width: 8),
                      Text(AppLocalizations.of(context).translate('italian')),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _departureCity,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)
                      .translate('departure_city'),
                  prefixIcon: Icon(Icons.flight_takeoff),
                ),
                validator: (input) => input!.trim().isEmpty
                    ? AppLocalizations.of(context).translate('departure_city')
                    : null,
                onSaved: (input) => _departureCity = input!,
              ),
              TextFormField(
                initialValue: _destinationCity,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)
                      .translate('destination_city'),
                  prefixIcon: Icon(Icons.flight_land),
                ),
                validator: (input) => input!.trim().isEmpty
                    ? AppLocalizations.of(context).translate('destination_city')
                    : null,
                onSaved: (input) => _destinationCity = input!,
              ),
              TextFormField(
                initialValue: _departureTime,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)
                      .translate('departure_time'),
                  prefixIcon: Icon(Icons.schedule),
                ),
                validator: (input) => input!.trim().isEmpty
                    ? AppLocalizations.of(context).translate('departure_time')
                    : null,
                onSaved: (input) => _departureTime = input!,
              ),
              TextFormField(
                initialValue: _arrivalTime,
                decoration: InputDecoration(
                  labelText:
                  AppLocalizations.of(context).translate('arrival_time'),
                  prefixIcon: Icon(Icons.access_time),
                ),
                validator: (input) => input!.trim().isEmpty
                    ? AppLocalizations.of(context).translate('arrival_time')
                    : null,
                onSaved: (input) => _arrivalTime = input!,
              ),
              SizedBox(height: 20.0),
              ElevatedButton.icon(
                icon: Icon(Icons.save),
                label: Text(widget.flight == null
                    ? AppLocalizations.of(context).translate('add_flight')
                    : AppLocalizations.of(context).translate('update_flight')),
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
