// lib/app_localizations.dart

import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Flight Manager',
      'add_flight': 'Add Flight',
      'update_flight': 'Update Flight',
      'departure_city': 'Departure City',
      'destination_city': 'Destination City',
      'departure_time': 'Departure Time',
      'arrival_time': 'Arrival Time',
      'flight_added': 'Flight added',
      'flight_updated': 'Flight updated',
      'flight_deleted': 'Flight deleted',
      'instructions': 'Instructions',
      'instruction_message':
      'Click on the plus button to add your flight. You can update or delete your flights as needed.',
      'select_flight': 'Select a flight to view details',
      'change_language': 'Change Language',
      'english': 'English',
      'italian': 'Italian',
    },
    'it': {
      'title': 'Gestore Volo',
      'add_flight': 'Aggiungi Volo',
      'update_flight': 'Aggiorna Volo',
      'departure_city': 'Città di Partenza',
      'destination_city': 'Città di Destinazione',
      'departure_time': 'Orario di Partenza',
      'arrival_time': 'Orario di Arrivo',
      'flight_added': 'Volo aggiunto',
      'flight_updated': 'Volo aggiornato',
      'flight_deleted': 'Volo eliminato',
      'instructions': 'Istruzioni',
      'instruction_message':
      'Clicca sul pulsante più per aggiungere il tuo volo. Puoi aggiornare o eliminare i tuoi voli secondo necessità.',
      'select_flight': 'Seleziona un volo per visualizzare i dettagli',
      'change_language': 'Cambia Lingua',
      'english': 'Inglese',
      'italian': 'Italiano',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'it'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
