import 'package:chessground_game_app/l10n/l10n.dart';
import 'package:flutter/widgets.dart';

extension LocalizedBuildContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}