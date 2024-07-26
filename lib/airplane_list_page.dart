import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'app_database.dart';
import 'airplane_detail_page.dart';
import 'airplane.dart';
import 'localization.dart';

class AirplaneListPage extends StatefulWidget {
  final AppDatabase database;
  final Function(Locale) changeLanguage;

  AirplaneListPage({required this.database, required this.changeLanguage});

  @override
  _AirplaneListPageState createState() => _AirplaneListPageState();
}

class _AirplaneListPageState extends State<AirplaneListPage> {
  late Future<List<Airplane>> _airplanes = Future.value([]); // Initialize with an empty list
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  Airplane? selectedAirplane; // Track the selected airplane for larger screens

  @override
  void initState() {
    super.initState();
    _loadAirplanes();
  }

  void _loadAirplanes() async {
    final airplanesString = await secureStorage.read(key: 'airplanes');
    if (airplanesString != null) {
      final List<dynamic> jsonList = jsonDecode(airplanesString);
      final List<Airplane> airplanes = jsonList.map((json) => Airplane.fromJson(json)).toList();
      setState(() {
        _airplanes = Future.value(airplanes);
      });
      print("Loaded airplanes from EncryptedSharedPreferences.");
    } else {
      final airplanes = await widget.database.airplaneDao.findAllAirplanes();
      setState(() {
        _airplanes = Future.value(airplanes);
      });
      print("Loaded airplanes from database.");
    }
  }

  Future<void> _saveAirplanes(List<Airplane> airplanes) async {
    final jsonList = airplanes.map((airplane) => airplane.toJson()).toList();
    final airplanesString = jsonEncode(jsonList);
    await secureStorage.write(key: 'airplanes', value: airplanesString);
  }

  @override
  Widget build(BuildContext context) {
    var localization = Localization.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        title: Text(localization.translate('app_title'), style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.info, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(localization.translate('instructions')),
                  content: Text(localization.translate('instructions_content')),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(localization.translate('ok')),
                    ),
                  ],
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'en_US':
                  widget.changeLanguage(Locale('en', 'US'));
                  break;
                case 'en_GB':
                  widget.changeLanguage(Locale('en', 'GB'));
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'en_US',
                  child: Text('English (US)'),
                ),
                PopupMenuItem<String>(
                  value: 'en_GB',
                  child: Text('English (UK)'),
                ),
              ];
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Tablet/Desktop layout: Show details beside the ListView
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildListView(context, localization),
                ),
                Expanded(
                  flex: 2,
                  child: selectedAirplane != null
                      ? AirplaneDetailPage(
                    database: widget.database,
                    airplane: selectedAirplane,
                    changeLanguage: widget.changeLanguage,
                  )
                      : Center(
                    child: Text(
                      localization.translate('select_airplane'),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Phone layout: Show details on a new page
            return _buildListView(context, localization);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AirplaneDetailPage(database: widget.database, changeLanguage: widget.changeLanguage),
            ),
          );
          _loadAirplanes();
        },
      ),
    );
  }

  Widget _buildListView(BuildContext context, Localization localization) {
    return Stack(
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
                                  builder: (context) => AirplaneDetailPage(database: widget.database, airplane: airplane, changeLanguage: widget.changeLanguage),
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
                      onTap: () {
                        if (MediaQuery.of(context).size.width > 600) {
                          setState(() {
                            selectedAirplane = airplane;
                          });
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AirplaneDetailPage(database: widget.database, airplane: airplane, changeLanguage: widget.changeLanguage),
                            ),
                          );
                        }
                      },
                      onLongPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AirplaneDetailPage(database: widget.database, airplane: airplane, changeLanguage: widget.changeLanguage),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }
}
