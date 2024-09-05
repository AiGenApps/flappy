import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LanguageController extends GetxController {
  var locale = const Locale('zh').obs;

  void toggleLanguage() {
    if (locale.value.languageCode == 'zh') {
      locale.value = const Locale('en');
    } else {
      locale.value = const Locale('zh');
    }
  }
}
