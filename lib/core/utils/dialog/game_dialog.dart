import 'package:chessground_game_app/core/l10n_build_context.dart';
import 'package:chessground_game_app/core/utils/dialog/platform_alert_dialog.dart';
import 'package:flutter/material.dart';

class GameNegotiationDialog extends StatelessWidget {
  const GameNegotiationDialog({
    super.key,
    required this.title,
    required this.onAccept,
    required this.onDecline,
  });

  final Widget title;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  @override
  Widget build(BuildContext context) {
    void decline() {
      Navigator.of(context).pop();
      onDecline();
    }

    void accept() {
      Navigator.of(context).pop();
      onAccept();
    }

    return AlertDialog.adaptive(
      content: title,
      actions: [
        PlatformDialogAction(onPressed: accept, child: Text(context.l10n.accept)),
        PlatformDialogAction(onPressed: decline, child: Text(context.l10n.decline)),
      ],
    );
  }
}
