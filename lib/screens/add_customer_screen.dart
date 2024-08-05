import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../services/database_helper.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../localization.dart';

class AddCustomerScreen extends StatefulWidget {
  final Customer? customer;
  final Function(Locale) setLocale;

  AddCustomerScreen({required this.customer, required this.setLocale});

  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  late String _firstName;
  late String _lastName;
  late String _address;
  late DateTime _birthday;

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      _firstName = widget.customer!.firstName;
      _lastName = widget.customer!.lastName;
      _address = widget.customer!.address;
      _birthday = widget.customer!.birthday;
    } else {
      _firstName = '';
      _lastName = '';
      _address = '';
      _birthday = DateTime.now();
    }
    _loadFromSecureStorage();
  }

  _saveCustomer() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Customer customer = Customer(
        id: widget.customer?.id ?? 0,
        firstName: _firstName,
        lastName: _lastName,
        address: _address,
        birthday: _birthday,
      );
      try {
        if (widget.customer == null) {
          await _dbHelper.insertCustomer(customer);
          if (mounted) {
            Navigator.pop(context, AppLocalizations.of(context).translate('customerAdded'));
          }
        } else {
          await _dbHelper.updateCustomer(customer);
          if (mounted) {
            Navigator.pop(context, AppLocalizations.of(context).translate('customerUpdated'));
          }
        }
      } catch (e) {
        print('Error saving customer: $e');
      }
    }
  }

  _deleteCustomer() async {
    try {
      await _dbHelper.deleteCustomer(widget.customer!.id);
      if (mounted) {
        Navigator.pop(context, AppLocalizations.of(context).translate('customerDeleted'));
      }
    } catch (e) {
      print('Error deleting customer: $e');
    }
  }

  _saveToSecureStorage() async {
    await _secureStorage.write(key: 'firstName', value: _firstName);
    await _secureStorage.write(key: 'lastName', value: _lastName);
    await _secureStorage.write(key: 'address', value: _address);
  }

  _loadFromSecureStorage() async {
    _firstName = await _secureStorage.read(key: 'firstName') ?? '';
    _lastName = await _secureStorage.read(key: 'lastName') ?? '';
    _address = await _secureStorage.read(key: 'address') ?? '';
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthday,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthday) {
      if (mounted) {
        setState(() {
          _birthday = picked;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer == null ? AppLocalizations.of(context).translate('addCustomer') ?? 'Add Customer' : AppLocalizations.of(context).translate('editCustomer') ?? 'Edit Customer'),
        actions: [
          if (widget.customer != null)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteCustomer,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _firstName,
                decoration: InputDecoration(labelText: AppLocalizations.of(context).translate('firstName') ?? 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) return AppLocalizations.of(context).translate('firstName') ?? 'Please enter first name';
                  return null;
                },
                onSaved: (value) {
                  _firstName = value!;
                  _saveToSecureStorage();
                },
              ),
              TextFormField(
                initialValue: _lastName,
                decoration: InputDecoration(labelText: AppLocalizations.of(context).translate('lastName') ?? 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) return AppLocalizations.of(context).translate('lastName') ?? 'Please enter last name';
                  return null;
                },
                onSaved: (value) {
                  _lastName = value!;
                  _saveToSecureStorage();
                },
              ),
              TextFormField(
                initialValue: _address,
                decoration: InputDecoration(labelText: AppLocalizations.of(context).translate('address') ?? 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) return AppLocalizations.of(context).translate('address') ?? 'Please enter address';
                  return null;
                },
                onSaved: (value) {
                  _address = value!;
                  _saveToSecureStorage();
                },
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "${AppLocalizations.of(context).translate('birthday')}: ${_birthday.toLocal()}".split(' ')[0],
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text(AppLocalizations.of(context).translate('selectDate') ?? 'Select date'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCustomer,
                child: Text(widget.customer == null ? AppLocalizations.of(context).translate('addCustomer') ?? 'Add Customer' : AppLocalizations.of(context).translate('editCustomer') ?? 'Update Customer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
