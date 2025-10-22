import 'package:chessground_game_app/data/usecases/play_sound_usecase.dart';
import 'package:chessground_game_app/domain/services/service/sound_effect_service.dart';
import 'package:chessground_game_app/presentation/controllers/chess_board_settings_controller.dart';
import 'package:chessground_game_app/presentation/controllers/freee_game_controller.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  group('FreeGameController Tests', () {
    late FreeGameController ctrl;

    setUp(() {
      Get.put(ChessBoardSettingsController());
      ctrl = FreeGameController(PlaySoundUseCase(SoundEffectService()));
      ctrl.onInit();
    });

    test('Initial FEN is standard chess', () {
      expect(ctrl.fen, equals(kInitialFEN));
    });

    test('Playing move updates fen', () {
      final move =  Move.parse('e4');
      ctrl.onUserMoveAgainstAI(move as NormalMove);
      expect(ctrl.fen.contains('e4'), isTrue);
    });

    test('Reset restores initial state', () {
      // final move = Move.fromSan(ctrl.gameState.position, 'e4');
      final move = NormalMove.fromUci('e4');

      ctrl.onUserMoveAgainstAI(move);
      ctrl.reset();
      expect(ctrl.fen, equals(kInitialFEN));
    });

    test('Promotion triggers correct flow', () {
      final move = NormalMove(
        from: Square.fromName('a7'),
        to: Square.fromName('a8'),
      );
      ctrl.onPromotionSelection(Role.queen);
      expect(ctrl.promotionMove, isNull);
    });
  });
}
