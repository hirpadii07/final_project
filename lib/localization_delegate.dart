import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Localization {
  final Locale locale;

  Localization(this.locale);

  static Localization of(BuildContext context) {
    final instance = Localizations.of<Localization>(context, Localization);
    assert(instance != null, 'No Localization found in context');
    return instance!;
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en_US': {
      'app_title': 'Airplane Management',
      'add_airplane': 'Add Airplane',
      'edit_airplane': 'Edit Airplane',
      'type': 'Type',
      'passengers': 'Passengers',
      'speed': 'Speed',
      'range': 'Range',
      'add': 'Add',
      'update': 'Update',
      'delete': 'Delete',
      'instructions': 'Instructions',
      'instructions_content': 'Instructions on how to use the interface.',
      'ok': 'OK',
      'error_fill_all_fields': 'Please fill all fields correctly',
    },
    'en_GB': {
      'app_title': 'Aeroplane Management',
      'add_airplane': 'Add Aeroplane',
      'edit_airplane': 'Edit Aeroplane',
      'type': 'Type',
      'passengers': 'Passengers',
      'speed': 'Speed',
      'range': 'Range',
      'add': 'Add',
      'update': 'Update',
      'delete': 'Delete',
      'instructions': 'Instructions',
      'instructions_content': 'Instructions on how to use the interface.',
      'ok': 'OK',
      'error_fill_all_fields': 'Please fill all fields correctly',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.toString()]?[key] ?? key;
  }
}

class LocalizationDelegate extends LocalizationsDelegate<Localization> {
  const LocalizationDelegate();

  @override
  bool isSupported(Locale locale) => ['en_US', 'en_GB'].contains(locale.toString());

  @override
  Future<Localization> load(Locale locale) {
    return SynchronousFuture<Localization>(Localization(locale));
  }

  @override
  bool shouldReload(LocalizationDelegate old) => false;
}
