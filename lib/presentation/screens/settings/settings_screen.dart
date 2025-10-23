import 'package:auto_size_text/auto_size_text.dart';
import 'package:chessground_game_app/core/l10n_build_context.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../l10n/l10n.dart';
import '../../controllers/settings_controller.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsSettings)),
      body: Column(
        children: [
          ListTile(
            title: Text(context.l10n.language),

            trailing: DropdownButton(
              value: Get.locale?.countryCode,

              // enableFeedback: true,
              items:
                  AppLocalizations.supportedLocales.map((locale) {
                    return DropdownMenuItem(
                      value: locale.languageCode,
                      // enabled:
                      //     locale.countryCode !=
                      //     controller.storage.instance.read('locale'),
                      child: AutoSizeText(locale.languageCode),
                      
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
