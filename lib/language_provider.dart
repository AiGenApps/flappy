import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('zh');

  Locale get locale => _locale;

  void toggleLanguage() {
    if (_locale.languageCode == 'zh') {
      _locale = const Locale('en');
    } else {
      _locale = const Locale('zh');
    }
    notifyListeners();
  }
}
