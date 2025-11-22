import 'package:chessground_game_app/core/global_feature/data/collections/player.dart';
import 'package:chessground_game_app/core/global_feature/domain/services/chess_game_storage_service.dart';
import 'package:chessground_game_app/core/utils/dialog/constants/const.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/get_storage_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

Future<Locale> getLocale() async {
  final storage = Get.find<GetStorageControllerImp>();

  Locale? locale;

  final String? languageCode = storage.instance.read('locale');
  String? countryCode = storage.instance.read('countryCode');

  if (languageCode == null) {
    await storage.instance.write('locale', 'en');
    await storage.instance.write('countryCode', 'en-US');
    locale = const Locale('en', 'en-US');
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
    uuid = const Uuid().v4();
    var newPlayer = Player(
      name: key == uuidKeyForUser ? 'Guest${uuid.substring(0, 5)}' : 'stockfish',
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
                return RadioGroup<T>(
                  groupValue: selectedItem, // Managed by RadioGroup now
                  onChanged: (value) {
                    if (value != null) onSelectedItemChanged(value);
                    Navigator.of(context).pop();
                  },
                  child: RadioMenuButton<T>(
                    onChanged: (value) {
                      if (value != null) onSelectedItemChanged(value);
                      Navigator.of(context).pop();
                    },
                    value: value,
                    groupValue: selectedItem,

                    child: labelBuilder(value),
                  ),
                );
              })
              .toList(growable: false),
        ),
        actions: [
          TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(context).pop()),
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
        title: const Text('إنهاء اللعبة؟'),
        content: const Text('هل أنت متأكد أنك تريد الاستسلام وإنهاء اللعبة؟'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // لا تسمح بالخروج
            },
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // تسمح بالخروج
            },
            child: const Text('استسلام'),
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
        title: const Text('انتهت اللعبة!'),
        content: Text(outcome),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // إغلاق النافذة المنبثقة
            },
            child: const Text('حسناً'),
          ),
        ],
      );
    },
  );
}
