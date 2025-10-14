import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/player.dart';
import '../../domain/services/chess_game_storage_service.dart';
import '../../presentation/controllers/get_storage_controller.dart';

// create a guest player if not exists and return it
Future<Player?> createPlayerIfNotExists(GetStorageControllerImp storage) async {
  final chessGame = ChessGameStorageService();
  String? uuid = storage.getUUid('user_uuid');
  if (uuid == null || uuid.isEmpty) {
    uuid = Uuid().v4();
    var newPlayer = Player(
      name: 'Guest-$uuid',
      uuid: uuid,
      type: 'guest',
      email: '',
      image: null,
      playerRating: 1200,
    );
    newPlayer = await chessGame.createPlayer(newPlayer);
    storage.saveUUid('user_uuid', newPlayer.uuid);
    return newPlayer;
  } else {
    final p = await chessGame.getPlayerByUuid(uuid);
    return p;
  }
}

// create an AI player if not exists and return it
Future<Player?> createAIPlayerIfNotExists(
  GetStorageControllerImp storage,
) async {
  final chessGame = ChessGameStorageService();
  String? uuid = storage.getUUid('ai_user_uuid');
  if (uuid == null || uuid.isEmpty) {
    uuid = Uuid().v4();
    final newPlayer = Player(
      name: 'ai-$uuid',
      uuid: uuid,
      type: 'ai',
      email: '',
      image: null,
      playerRating: 1200,
    );
    await chessGame.createPlayer(newPlayer);
    storage.saveUUid('ai_user_uuid', newPlayer.uuid);
    return newPlayer;
  } else {
    return await chessGame.getPlayerByUuid(uuid);
  }
}

void makeShowChoicesPicker<T extends Enum>(
  BuildContext context, {
  required List<T> choices,
  required T selectedItem,
  required Widget Function(T choice) labelBuilder,
  required void Function(T choice) onSelectedItemChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.only(top: 12),
        scrollable: true,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: choices
              .map((value) {
                return RadioListTile<T>(
                  title: labelBuilder(value),
                  value: value,
                  groupValue: selectedItem,
                  onChanged: (value) {
                    if (value != null) onSelectedItemChanged(value);
                    Navigator.of(context).pop();
                  },
                );
              })
              .toList(growable: false),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    },
  );
}

// هذه الدالة تعرض نافذة تأكيد الاستسلام
Future<bool?> showExitConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('إنهاء اللعبة؟'),
        content: Text('هل أنت متأكد أنك تريد الاستسلام وإنهاء اللعبة؟'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // لا تسمح بالخروج
            },
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // تسمح بالخروج
            },
            child: Text('استسلام'),
          ),
        ],
      );
    },
  );
}

// هذه الدالة الجديدة تعرض نافذة "نهاية اللعبة"
Future<void> showGameOverDialog(BuildContext context, Outcome? outcome) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // يمنع إغلاقها بالضغط خارجها
    builder: (context) {
      return AlertDialog(
        title: Text('انتهت اللعبة!'),
        content: Text(
          '${outcome != null ? "الفائز هو :${outcome.winner == Side.white ? 'الأبيض' : 'الأسود'}" : ""} لقد خسرت هذه اللعبة. يمكنك الآن العودة إلى الصفحة الرئيسية.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // إغلاق النافذة المنبثقة
            },
            child: Text('حسناً'),
          ),
        ],
      );
    },
  );
}
