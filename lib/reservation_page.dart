import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'add_reservation_page.dart';
import 'app_localizations.dart';

class ReservationPage extends StatefulWidget {
  final Database database;
  final Function(Locale) onLanguageChanged;

  ReservationPage({required this.database, required this.onLanguageChanged});

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final StoreRef<int, Map<String, dynamic>> store = intMapStoreFactory.store('reservations');
  List<RecordSnapshot<int, Map<String, dynamic>>> _reservations = [];
  bool _isAddingReservation = false;
  final _secureStorage = const FlutterSecureStorage();
  Locale _currentLocale = Locale('en');

  @override
  void initState() {
    super.initState();
    _loadReservations();
    _loadPreferences();
  }

  Future<void> _loadReservations() async {
    final records = await store.find(widget.database);
    setState(() {
      _reservations = records;
    });
  }

  Future<void> _addReservation(Map<String, String> reservation) async {
    await store.add(widget.database, {
      'customer': reservation['customer']!,
      'flight': reservation['flight']!,
      'date': reservation['date']!,
    });
    _loadReservations();
  }

  Future<void> _deleteReservation(int id) async {
    await store.record(id).delete(widget.database);
    _loadReservations();
  }

  void _showReservationDetails(Map<String, dynamic> reservation, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).getTranslatedValue('reservationDetails') ?? 'Reservation Details'),
          content: Text(
              '${AppLocalizations.of(context).getTranslatedValue('customer') ?? 'Customer'}: ${reservation['customer']}\n'
                  '${AppLocalizations.of(context).getTranslatedValue('flight') ?? 'Flight'}: ${reservation['flight']}\n'
                  '${AppLocalizations.of(context).getTranslatedValue('date') ?? 'Date'}: ${reservation['date']}'),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context).getTranslatedValue('delete') ?? 'Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteReservation(id);
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context).getTranslatedValue('ok') ?? 'OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadPreferences() async {
    String? lastCustomer = await _secureStorage.read(key: 'lastCustomer');
    if (lastCustomer != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Last customer: $lastCustomer')),
      );
    }
  }

  void _changeLanguage(Locale? locale) {
    if (locale != null) {
      widget.onLanguageChanged?.call(locale);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).getTranslatedValue('title') ?? 'Airline Reservation System'),
        actions: [
          DropdownButton<Locale>(
            underline: SizedBox(),
            icon: Icon(Icons.language, color: Colors.black),
            onChanged: _changeLanguage,
            items: [
              DropdownMenuItem(
                value: Locale('en'),
                child: Text('English'),
              ),
              DropdownMenuItem(
                value: Locale('fr'),
                child: Text('Français'),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context).getTranslatedValue('instructions') ?? 'Instructions'),
                    content: Text(AppLocalizations.of(context).getTranslatedValue('instructionsDetails') ?? 'Instructions not available.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(AppLocalizations.of(context).getTranslatedValue('ok') ?? 'OK'),
                      ),
                    ],
                  );
                },
              );
            },
          )
        ],
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
          if (_isAddingReservation)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0.1),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _reservations.length,
                    itemBuilder: (context, index) {
                      final reservation = _reservations[index];
                      return ListTile(
                        title: Text('${reservation.value['customer']} - ${reservation.value['flight']}'),
                        subtitle: Text(reservation.value['date']),
                        onTap: () => _showReservationDetails(reservation.value, reservation.key),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text(AppLocalizations.of(context).getTranslatedValue('addReservation') ?? 'Add Reservation'),
                  onPressed: () async {
                    setState(() {
                      _isAddingReservation = true;
                    });
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddReservationPage(
                            onLanguageChanged: widget.onLanguageChanged,
                          )),
                    );
                    setState(() {
                      _isAddingReservation = false;
                    });
                    if (result != null) {
                      await _secureStorage.write(key: 'lastCustomer', value: result['customer']);
                      _addReservation(result);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
