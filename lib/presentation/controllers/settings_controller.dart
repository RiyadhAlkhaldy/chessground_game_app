import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'get_storage_controller.dart';

class SettingsController extends GetxController {
  final storage = Get.put(GetStorageControllerImp());

  void changeLocale(String langCode) async {
    final Locale locale = Locale(langCode);
    await storage.instance.write('locale', locale.languageCode);
    // Intl.defaultLocale = locale.toLanguageTag(); // e.g. en or ar

    Get.updateLocale(locale);
  }
}
