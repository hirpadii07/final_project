import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'app_database.dart';
import 'airplane.dart';
import 'localization.dart';

/// A page for adding or editing an airplane.
class AirplaneDetailPage extends StatefulWidget {
  /// The database instance.
  final AppDatabase database;

  /// The airplane to be edited, or null if adding a new airplane.
  final Airplane? airplane;

  /// Function to change the application language.
  final Function(Locale) changeLanguage;

  /// Creates an instance of AirplaneDetailPage.
  AirplaneDetailPage({required this.database, this.airplane, required this.changeLanguage});

  @override
  _AirplaneDetailPageState createState() => _AirplaneDetailPageState();
}

/// The state class for [AirplaneDetailPage].
class _AirplaneDetailPageState extends State<AirplaneDetailPage> {
  /// The form key for validating the form.
  final _formKey = GlobalKey<FormState>();

  /// Controller for the airplane type field.
  late TextEditingController _typeController;

  /// Controller for the passengers field.
  late TextEditingController _passengersController;

  /// Controller for the speed field.
  late TextEditingController _speedController;

  /// Controller for the range field.
  late TextEditingController _rangeController;

  @override
  void initState() {
    super.initState();
    _typeController = TextEditingController(text: widget.airplane?.type ?? '');
    _passengersController = TextEditingController(text: widget.airplane?.passengers.toString() ?? '');
    _speedController = TextEditingController(text: widget.airplane?.speed.toString() ?? '');
    _rangeController = TextEditingController(text: widget.airplane?.range.toString() ?? '');
  }

  @override
  void dispose() {
    _typeController.dispose();
    _passengersController.dispose();
    _speedController.dispose();
    _rangeController.dispose();
    super.dispose();
  }

  /// Saves the airplane to the database.
  Future<void> _saveAirplane() async {
    if (_formKey.currentState!.validate()) {
      final type = _typeController.text;
      final passengers = int.parse(_passengersController.text);
      final speed = int.parse(_speedController.text);
      final range = int.parse(_rangeController.text);

      final airplane = Airplane(
        type: type,
        passengers: passengers,
        speed: speed,
        range: range,
        id: widget.airplane?.id ?? DateTime.now().millisecondsSinceEpoch,
      );

      if (widget.airplane == null) {
        await widget.database.airplaneDao.insertAirplane(airplane);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Airplane added')));
      } else {
        await widget.database.airplaneDao.updateAirplane(airplane);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Airplane updated')));
      }

      final prefs = await SharedPreferences.getInstance();
      final airplanes = await widget.database.airplaneDao.findAllAirplanes();
      final jsonList = airplanes.map((a) => a.toJson()).toList();
      await prefs.setString('airplanes', jsonEncode(jsonList));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var localization = Localization.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        title: Text(widget.airplane == null ? localization.translate('add_airplane') : localization.translate('edit_airplane'), style: TextStyle(color: Colors.white)),
        actions: [
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
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/airplane1.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    ClipOval(
                      child: Image.asset(
                        "images/airplane.jpg",
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _typeController,
                      decoration: InputDecoration(
                        labelText: localization.translate('type'),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localization.translate('error_fill_all_fields');
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _passengersController,
                      decoration: InputDecoration(
                        labelText: localization.translate('passengers'),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localization.translate('error_fill_all_fields');
                        }
                        if (int.tryParse(value) == null) {
                          return localization.translate('error_fill_all_fields');
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _speedController,
                      decoration: InputDecoration(
                        labelText: localization.translate('speed'),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localization.translate('error_fill_all_fields');
                        }
                        if (int.tryParse(value) == null) {
                          return localization.translate('error_fill_all_fields');
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _rangeController,
                      decoration: InputDecoration(
                        labelText: localization.translate('range'),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return localization.translate('error_fill_all_fields');
                        }
                        if (int.tryParse(value) == null) {
                          return localization.translate('error_fill_all_fields');
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveAirplane,
                      child: Text(localization.translate('save')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
