import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'flight.dart';
import 'flight_form.dart';
import 'secure_storage_helper.dart';
import 'app_localizations.dart';

/// Author: Khushpreet Kaur
///
/// The main screen of the Flight Manager application, displaying the list of flights.
class MainScreen extends StatefulWidget {
  final Function(Locale) changeLanguage;

  MainScreen({required this.changeLanguage});

  @override
  _MainScreenState createState() => _MainScreenState();
}

/// The state for the MainScreen widget.
class _MainScreenState extends State<MainScreen> {
  /// The list of flights displayed on the screen.
  late List<Flight> _flightList;

  /// Helper for managing secure storage.
  final SecureStorageHelper _storageHelper = SecureStorageHelper();

  /// Initializes the state of the MainScreen widget.
  @override
  void initState() {
    super.initState();
    _initializeFlightList();
  }

  /// Initializes the flight list with an empty list.
  void _initializeFlightList() {
    _flightList = [];
    _updateFlightList();
  }

  /// Updates the flight list by fetching data from the database.
  Future<void> _updateFlightList() async {
    final flightMapList = await DatabaseHelper.instance.getFlightMapList();
    setState(() {
      _flightList = flightMapList.map((flightMap) => Flight.fromMap(flightMap)).toList();
    });
  }

  /// Deletes a flight from the database and updates the flight list.
  ///
  /// [id] is the identifier of the flight to be deleted.
  Future<void> _deleteFlight(int id) async {
    await DatabaseHelper.instance.deleteFlight(id);
    _updateFlightList();
  }

  /// Shows a snackbar with a specified message.
  ///
  /// [context] is the build context.
  /// [message] is the message to display in the snackbar.
  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  /// Shows an alert dialog with a specified title and message.
  ///
  /// [context] is the build context.
  /// [title] is the title of the alert dialog.
  /// [message] is the message of the alert dialog.
  void _showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Builds the widget tree for the MainScreen.
  ///
  /// [context] is the build context.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('title')),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              _showAlertDialog(
                context,
                AppLocalizations.of(context).translate('instructions'),
                AppLocalizations.of(context).translate('instruction_message'),
              );
            },
          ),
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return _buildMobileLayout();
          } else {
            return _buildTabletDesktopLayout();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FlightForm(
                updateFlightList: _updateFlightList,
                changeLanguage: widget.changeLanguage,
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds the layout for mobile devices.
  ///
  /// Returns a ListView displaying the flight list.
  Widget _buildMobileLayout() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _flightList.length,
      itemBuilder: (BuildContext context, int index) {
        Flight flight = _flightList[index];
        return Card(
          elevation: 2.0,
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            leading: Icon(Icons.flight),
            title: Text('${flight.departureCity} to ${flight.destinationCity}'),
            subtitle: Text(
              '${AppLocalizations.of(context).translate('departure_time')}: ${flight.departureTime} ${AppLocalizations.of(context).translate('arrival_time')}: ${flight.arrivalTime}',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FlightForm(
                    flight: flight,
                    updateFlightList: _updateFlightList,
                    changeLanguage: widget.changeLanguage,
                  ),
                ),
              );
            },
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteFlight(flight.id!);
                _showSnackbar(
                  context,
                  AppLocalizations.of(context).translate('flight_deleted'),
                );
              },
            ),
          ),
        );
      },
    );
  }

  /// Builds the layout for tablets and desktop devices.
  ///
  /// Returns a Row with a ListView on the left and a details view on the right.
  Widget _buildTabletDesktopLayout() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _flightList.length,
            itemBuilder: (BuildContext context, int index) {
              Flight flight = _flightList[index];
              return Card(
                elevation: 2.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  leading: Icon(Icons.flight),
                  title: Text('${flight.departureCity} to ${flight.destinationCity}'),
                  subtitle: Text(
                    '${AppLocalizations.of(context).translate('departure_time')}: ${flight.departureTime} ${AppLocalizations.of(context).translate('arrival_time')}: ${flight.arrivalTime}',
                  ),
                  onTap: () {
                    setState(() {
                      // Code to show flight details in the right pane
                    });
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteFlight(flight.id!);
                      _showSnackbar(
                        context,
                        AppLocalizations.of(context).translate('flight_deleted'),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            child: Center(
              child: Text(
                AppLocalizations.of(context).translate('select_flight'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
