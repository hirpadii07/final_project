import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_database.dart';
import 'airplane_detail_page.dart';
import 'airplane.dart';

class AirplaneListPage extends StatefulWidget {
  final AppDatabase database;

  AirplaneListPage({required this.database});

  @override
  _AirplaneListPageState createState() => _AirplaneListPageState();
}

class _AirplaneListPageState extends State<AirplaneListPage> {
  late Future<List<Airplane>> _airplanes = Future.value([]); // Initialize with an empty list

  @override
  void initState() {
    super.initState();
    _loadAirplanes();
  }

  void _loadAirplanes() async {
    final prefs = await SharedPreferences.getInstance();
    final airplanesString = prefs.getString('airplanes');
    if (airplanesString != null) {
      final List<dynamic> jsonList = jsonDecode(airplanesString);
      final List<Airplane> airplanes = jsonList.map((json) => Airplane.fromJson(json)).toList();
      setState(() {
        _airplanes = Future.value(airplanes);
      });
      print("Loaded airplanes from SharedPreferences.");
    } else {
      final airplanes = await widget.database.airplaneDao.findAllAirplanes();
      setState(() {
        _airplanes = Future.value(airplanes);
      });
      print("Loaded airplanes from database.");
    }
  }

  Future<void> _saveAirplanes(List<Airplane> airplanes) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = airplanes.map((airplane) => airplane.toJson()).toList();
    final airplanesString = jsonEncode(jsonList);
    await prefs.setString('airplanes', airplanesString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        title: Text('Airplane Management', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.info, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Info'),
                  content: Text('This is the airplane management app.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            "images/airplane1.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          FutureBuilder<List<Airplane>>(
            future: _airplanes,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No airplanes available', style: TextStyle(color: Colors.white)));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final airplane = snapshot.data![index];
                    return Card(
                      color: Colors.black54,
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: ListTile(
                        leading: Image.asset("images/airplane.jpg", width: 50, height: 50),
                        title: Text(airplane.type, style: TextStyle(color: Colors.white)),
                        subtitle: Text(
                          'Passengers: ${airplane.passengers}, Speed: ${airplane.speed}, Range: ${airplane.range}',
                          style: TextStyle(color: Colors.white70),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.white),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AirplaneDetailPage(database: widget.database, airplane: airplane),
                                  ),
                                );
                                _loadAirplanes();
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.white),
                              onPressed: () async {
                                await widget.database.airplaneDao.deleteAirplane(airplane);
                                final airplanes = await widget.database.airplaneDao.findAllAirplanes();
                                await _saveAirplanes(airplanes);
                                _loadAirplanes();
                              },
                            ),
                          ],
                        ),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AirplaneDetailPage(database: widget.database, airplane: airplane),
                            ),
                          );
                          _loadAirplanes();
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AirplaneDetailPage(database: widget.database),
            ),
          );
          _loadAirplanes();
        },
      ),
    );
  }
}
