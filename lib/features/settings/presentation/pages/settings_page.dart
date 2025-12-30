import 'package:chessground_game_app/core/l10n_build_context.dart';
import 'package:chessground_game_app/l10n/l10n.dart';
import 'package:chessground_game_app/features/settings/presentation/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    
    final uniqueLanguageCodes = AppLocalizations.supportedLocales
        .map((l) => l.languageCode)
        .toSet()
        .toList();

    final currentLanguageCode = Get.locale?.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsSettings),
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, l10n.language),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(_getLanguageName(currentLanguageCode ?? 'en')),
            trailing: DropdownButton<String>(
              value: currentLanguageCode,
              underline: const SizedBox.shrink(),
              items: uniqueLanguageCodes.map((code) {
                return DropdownMenuItem<String>(
                  value: code,
                  child: Text(_getLanguageName(code)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) controller.changeLocale(val);
              },
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      default:
        return code;
    }
  }
}