import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../data/collections/player.dart';
import '../../../domain/services/chess_game_storage_service.dart';
import '../../../presentation/controllers/get_storage_controller.dart';
import '../dialog/constants/const.dart';
import '../logger.dart';

Future<Locale> getLocale() async {
  final storage = Get.find<GetStorageControllerImp>();

  Locale? locale;

  String? languageCode = storage.instance.read('locale');
  String? countryCode = storage.instance.read('countryCode');

  if (languageCode == null) {
    await storage.instance.write('locale', 'en');
    await storage.instance.write('countryCode', 'en-US');
    locale = Locale('en', 'en-US');
  } else {
    if (countryCode == null) {
      await storage.instance.write('countryCode', 'en-US');
      countryCode = storage.instance.read('countryCode');
    }

    locale = Locale(languageCode, countryCode);
  }
  return locale;
}

// create a guest player if not exists and return it
Future<Player?> createOrGetGustPlayer([String key = uuidKeyForUser]) async {
  final storage = Get.find<GetStorageControllerImp>();
  final chessGame = Get.find<ChessGameStorageService>();

  String? uuid = storage.getUUid(key);

  if (uuid == null || uuid.isEmpty) {
    uuid = Uuid().v4();
    var newPlayer = Player(
      name: key == uuidKeyForUser
          ? 'Guest${uuid.substring(0, 5)}'
          : 'stockfish',
      uuid: uuid,
      type: key == uuidKeyForUser ? 'guest' : 'AI',
      email: '',
      image: null,
      playerRating: 1200,
    );
    newPlayer = await chessGame.createPlayer(newPlayer);
    storage.saveUUid(key, newPlayer.uuid);
    AppLoggerr.info("$newPlayer");

    return newPlayer;
  } else {
    final player = await chessGame.getPlayerByUuid(uuid);
    AppLoggerr.info("$player");

    return player;
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
Future<void> showGameOverDialog(BuildContext context, String outcome) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // يمنع إغلاقها بالضغط خارجها
    builder: (context) {
      return AlertDialog(
        title: Text('انتهت اللعبة!'),
        content: Text(outcome),
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
