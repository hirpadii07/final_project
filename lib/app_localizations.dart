// localization.dart

import 'package:flutter/material.dart';

class Localization {
  static Localization? of(BuildContext context) {
    return Localizations.of<Localization>(context, Localization);
  }

  String translate(String key) {
    // Provide default values if translation is not found
    switch (key) {
      case 'app_title':
        return 'App Title';
      case 'instructions':
        return 'Instructions';
      case 'instructions_content':
        return 'Navigate to each page to manage customers, airplanes, flights, and reservations.';
      case 'ok':
        return 'OK';
      case 'select_airplane':
        return 'Select an airplane to view details';
      default:
        return 'Unknown';
    }
  }
}
