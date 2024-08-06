import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

/// Handles the translation of strings in the app based on the current locale.
class Localization {
  /// The locale for which this instance provides translations.
  final Locale locale;

  /// Creates an instance of [Localization] for the given [locale].
  Localization(this.locale);

  /// Retrieves the [Localization] instance from the given [BuildContext].
  ///
  /// Throws an assertion error if no [Localization] is found in the context.
  static Localization of(BuildContext context) {
    final instance = Localizations.of<Localization>(context, Localization);
    assert(instance != null, 'No Localization found in context');
    return instance!;
  }

  /// A map containing localized strings for supported locales.
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
      'instructions_content': 'This is the airplane management app.\n\n'
          '1. To add a new airplane, click the "+" button at the bottom right corner of the screen.\n'
          '2. Fill in the details (type, passengers, speed, range) and click "Save".\n'
          '3. The airplane will be added to the list.\n'
          '4. To edit an airplane, click the "edit" icon next to the airplane.\n'
          '5. To delete an airplane, click the "delete" icon next to the airplane.\n'
          '6. Long press on an airplane to view its details.\n'
          '7. Use the menu in the top right corner to switch between US and UK English.\n'
          '8. The list of airplanes is saved using encrypted storage and will be loaded when the app is restarted.',
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
      'instructions_content': 'This is the aeroplane management app.\n\n'
          '1. To add a new aeroplane, click the "+" button at the bottom right corner of the screen.\n'
          '2. Fill in the details (type, passengers, speed, range) and click "Save".\n'
          '3. The aeroplane will be added to the list.\n'
          '4. To edit an aeroplane, click the "edit" icon next to the aeroplane.\n'
          '5. To delete an aeroplane, click the "delete" icon next to the aeroplane.\n'
          '6. Long press on an aeroplane to view its details.\n'
          '7. Use the menu in the top right corner to switch between US and UK English.\n'
          '8. The list of aeroplanes is saved using encrypted storage and will be loaded when the app is restarted.',
      'ok': 'OK',
      'error_fill_all_fields': 'Please fill all fields correctly',
    },
  };

  /// Translates the given [key] to the current locale.
  ///
  /// If the translation is not available, the key itself is returned.
  String translate(String key) {
    return _localizedValues[locale.toString()]?[key] ?? key;
  }
}

/// A delegate that loads the [Localization] resources.
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
