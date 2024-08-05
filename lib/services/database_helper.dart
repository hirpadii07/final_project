import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/customer.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<List<Customer>> getCustomers() async {
    final prefs = await SharedPreferences.getInstance();
    final customersString = prefs.getString('customers') ?? '[]';
    final List<dynamic> customerList = jsonDecode(customersString);
    return customerList.map((e) => Customer.fromMap(e)).toList();
  }

  Future<void> insertCustomer(Customer customer) async {
    final prefs = await SharedPreferences.getInstance();
    final customers = await getCustomers();
    customers.add(customer);
    final customerList = customers.map((e) => e.toMap()).toList();
    prefs.setString('customers', jsonEncode(customerList));
  }

  Future<void> updateCustomer(Customer customer) async {
    final prefs = await SharedPreferences.getInstance();
    final customers = await getCustomers();
    final index = customers.indexWhere((c) => c.id == customer.id);
    if (index != -1) {
      customers[index] = customer;
      final customerList = customers.map((e) => e.toMap()).toList();
      prefs.setString('customers', jsonEncode(customerList));
    }
  }

  Future<void> deleteCustomer(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final customers = await getCustomers();
    final newCustomers = customers.where((c) => c.id != id).toList();
    final customerList = newCustomers.map((e) => e.toMap()).toList();
    prefs.setString('customers', jsonEncode(customerList));
  }
}
