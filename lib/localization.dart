import 'dart:convert';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ?? AppLocalizations(Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  Map<String, String>? _localizedStrings;

  static const Map<String, String> en = {
    "title": "Customer List App",
    "addCustomer": "Add Customer",
    "editCustomer": "Edit Customer",
    "firstName": "First Name",
    "lastName": "Last Name",
    "address": "Address",
    "birthday": "Birthday",
    "selectDate": "Select date",
    "customerAdded": "Customer added",
    "customerUpdated": "Customer updated",
    "customerDeleted": "Customer deleted",
    "instructions": "Add, view, update, and delete customers."
  };

  static const Map<String, String> es = {
    "title": "Aplicación de Lista de Clientes",
    "addCustomer": "Agregar Cliente",
    "editCustomer": "Editar Cliente",
    "firstName": "Nombre",
    "lastName": "Apellido",
    "address": "Dirección",
    "birthday": "Cumpleaños",
    "selectDate": "Seleccionar fecha",
    "customerAdded": "Cliente agregado",
    "customerUpdated": "Cliente actualizado",
    "customerDeleted": "Cliente eliminado",
    "instructions": "Agregar, ver, actualizar y eliminar clientes."
  };

  Future<bool> load() async {
    String jsonString = jsonEncode(locale.languageCode == 'es' ? es : en);
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String? translate(String key) {
    return _localizedStrings?[key];
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
