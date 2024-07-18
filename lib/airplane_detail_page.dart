import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_database.dart';
import 'airplane.dart';

class AirplaneDetailPage extends StatefulWidget {
  final AppDatabase database;
  final Airplane? airplane;

  AirplaneDetailPage({required this.database, this.airplane});

  @override
  _AirplaneDetailPageState createState() => _AirplaneDetailPageState();
}

class _AirplaneDetailPageState extends State<AirplaneDetailPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _typeController;
  late TextEditingController _passengersController;
  late TextEditingController _speedController;
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        title: Text(widget.airplane == null ? 'Add Airplane' : 'Edit Airplane', style: TextStyle(color: Colors.white)),
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
                        labelText: 'Type',
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a type';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _passengersController,
                      decoration: InputDecoration(
                        labelText: 'Passengers',
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the number of passengers';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _speedController,
                      decoration: InputDecoration(
                        labelText: 'Speed',
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the speed';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _rangeController,
                      decoration: InputDecoration(
                        labelText: 'Range',
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the range';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveAirplane,
                      child: Text('Save'),
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
