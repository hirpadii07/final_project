import 'package:flutter/material.dart';
import 'add_customer_screen.dart';
import '../models/customer.dart';
import '../services/database_helper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../localization.dart';

class HomeScreen extends StatefulWidget {
  final Function(Locale) setLocale;

  HomeScreen({required this.setLocale});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  List<Customer> _customers = [];

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  _loadCustomers() async {
    try {
      List<Customer> customers = await _dbHelper.getCustomers();
      if (mounted) {
        setState(() {
          _customers = customers;
        });
      }
      print('Customers loaded: ${_customers.length}');
    } catch (e) {
      print('Error loading customers: $e');
    }
  }

  _showSnackbar(String message) {
    if (mounted) {
      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  _showAlertDialog(String title, String message) {
    if (mounted) {
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
  }

  _saveToSecureStorage(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> _loadFromSecureStorage(String key) async {
    return await _secureStorage.read(key: key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('title') ?? 'Customer List'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              _showAlertDialog(
                AppLocalizations.of(context).translate('instructions') ?? 'Instructions',
                'Add, view, update, and delete customers.',
              );
            },
          ),
          DropdownButton<Locale>(
            icon: Icon(Icons.language, color: Colors.white),
            onChanged: (Locale? locale) {
              if (locale != null) {
                widget.setLocale(locale);
              }
            },
            items: [
              DropdownMenuItem(
                value: Locale('en', ''),
                child: Text('English'),
              ),
              DropdownMenuItem(
                value: Locale('es', ''),
                child: Text('Español'),
              ),
            ],
          ),
        ],
      ),
      body: _customers.isEmpty
          ? Center(child: CircularProgressIndicator())
          : LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Tablet/Desktop layout
            return Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _customers.length,
                    itemBuilder: (context, index) {
                      final customer = _customers[index];
                      return ListTile(
                        title: Text('${customer.firstName} ${customer.lastName}'),
                        subtitle: Text(customer.address),
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddCustomerScreen(customer: customer, setLocale: widget.setLocale),
                            ),
                          );
                          if (result != null) {
                            _showSnackbar(result);
                            _loadCustomers();
                          }
                        },
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text('Select a customer to view details'),
                  ),
                ),
              ],
            );
          } else {
            // Phone layout
            return ListView.builder(
              itemCount: _customers.length,
              itemBuilder: (context, index) {
                final customer = _customers[index];
                return ListTile(
                  title: Text('${customer.firstName} ${customer.lastName}'),
                  subtitle: Text(customer.address),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddCustomerScreen(customer: customer, setLocale: widget.setLocale),
                      ),
                    );
                    if (result != null) {
                      _showSnackbar(result);
                      _loadCustomers();
                    }
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCustomerScreen(customer: null, setLocale: widget.setLocale)),
          );
          if (result != null) {
            _showSnackbar(result);
            _loadCustomers();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

