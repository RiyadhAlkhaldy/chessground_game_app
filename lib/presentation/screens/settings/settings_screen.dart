import 'package:auto_size_text/auto_size_text.dart';
import 'package:chessground_game_app/core/l10n_build_context.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../l10n/l10n.dart';
import '../../controllers/settings_controller.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key, superkey});
  @override
  Widget build(BuildContext context) {
    // 1 استخراج مجموعة من رموز اللغة الفريدة (مثل: {'en', 'ar', 'fr'})
    final uniqueLanguageCodes =
        AppLocalizations.supportedLocales
            .map((l) => l.languageCode)
            .toSet() // تحويل إلى Set لإزالة أي تكرار
            .toList(); // تحويلها مرة أخرى إلى قائمة لعرضها

    final currentLanguageCode = Get.locale?.languageCode;

    debugPrint("Current Locale Code: $currentLanguageCode");
    debugPrint("Unique Codes for Dropdown: $uniqueLanguageCodes");

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsSettings)),
      body: Column(
        children: [
          ListTile(
            title: Text(context.l10n.language),
            trailing: DropdownButton<String>(
              // القيمة الحالية يجب أن تكون موجودة في قائمة العناصر (items) مرة واحدة فقط
              value: currentLanguageCode,
              items:
                  uniqueLanguageCodes.map((code) {
                    return DropdownMenuItem<String>(
                      value: code, // <--- الآن كل قيمة (value) ستكون فريدة
                      child: AutoSizeText(code),
                    );
                  }).toList(),
              onChanged: (val) {
                if (val != null) controller.changeLocale(val);
              },
            ),
          ),
        ],
      ),
    );
  }
}
