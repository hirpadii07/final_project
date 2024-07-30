import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'add_reservation_page.dart';

class ReservationPage extends StatefulWidget {
  final Database database;

  ReservationPage({required this.database});

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final StoreRef<int, Map<String, dynamic>> store = intMapStoreFactory.store('reservations');
  List<RecordSnapshot<int, Map<String, dynamic>>> _reservations = [];
  bool _isAddingReservation = false;

  @override
  void initState() {
    super.initState();
    _loadReservations();
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
          title: Text('Reservation Details'),
          content: Text(
              'Customer: ${reservation['customer']}\nFlight: ${reservation['flight']}\nDate: ${reservation['date']}'),
          actions: [
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteReservation(id);
              },
            ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book your reservations here'),
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
                        title: Text(
                            '${reservation.value['customer']} - ${reservation.value['flight']}'),
                        subtitle: Text(reservation.value['date']),
                        onTap: () => _showReservationDetails(reservation.value, reservation.key),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Add Reservation'),
                  onPressed: () async {
                    setState(() {
                      _isAddingReservation = true;
                    });
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddReservationPage()),
                    );
                    setState(() {
                      _isAddingReservation = false;
                    });
                    if (result != null) {
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
