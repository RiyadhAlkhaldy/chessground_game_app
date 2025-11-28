import 'package:chessground_game_app/core/global_feature/domain/services/chess_game_storage_service.dart';
import 'package:chessground_game_app/di/ingection_container.dart';
import 'package:chessground_game_app/features/offline_game/fee_game_bindings.dart';
import 'package:chessground_game_app/features/offline_game/presentation/controllers/freee_game_controller.dart';
import 'package:chessground_game_app/core/global_feature/presentaion/controllers/chess_board_settings_controller.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() async {
  setUpAll(() async {
    await InjectionContainer.init();
    FreeGameBindings().dependencies();
  });
  group('FreeGameController Tests', () {
    late FreeGameController ctrl;

    setUp(() async {
      await ChessGameStorageService.initForTest('free_game_controller_test');
      Get.put(ChessBoardSettingsController());
      ctrl = Get.find<FreeGameController>();
      ctrl.onInit();
    });

    test('Initial FEN is standard chess', () {
      expect(ctrl.fen, equals(kInitialFEN));
    });

    test('Playing move updates fen', () {
      final move = Move.parse('e4');
      ctrl.onUserMove(move as NormalMove);
      expect(ctrl.fen.contains('e4'), isTrue);
    });

    test('Reset restores initial state', () {
      // final move = Move.fromSan(ctrl.gameState.position, 'e4');
      final move = NormalMove.fromUci('e4');

      ctrl.onUserMove(move);
      ctrl.reset();
      expect(ctrl.fen, equals(kInitialFEN));
    });

    test('Promotion triggers correct flow', () {
      // final move = NormalMove(
      //   from: Square.fromName('a7'),
      //   to: Square.fromName('a8'),
      // );
      ctrl.onPromotionSelection(Role.queen);
      expect(ctrl.promotionMove, isNull);
    });
  });
}
