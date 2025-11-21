import 'package:chessground_game_app/core/global_feature/data/datasources/local_datasource.dart';
import 'package:chessground_game_app/core/global_feature/data/datasources/stockfish_datasource.dart';
import 'package:chessground_game_app/core/global_feature/data/repositories/game_repository_impl.dart';
import 'package:chessground_game_app/core/global_feature/domain/services/chess_game_storage_service.dart';
import 'package:chessground_game_app/core/global_feature/domain/services/service/sound_effect_service.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/play_move.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/play_sound_usecase.dart'; 
import 'package:chessground_game_app/features/free_game/presentation/controllers/freee_game_controller.dart';
import 'package:chessground_game_app/presentation/controllers/chess_board_settings_controller.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';

void main() {
  group('FreeGameController Tests', () {
    late FreeGameController ctrl;

    setUp(() async {
      await ChessGameStorageService.initForTest('free_game_controller_test');
      Get.put(ChessBoardSettingsController());
      ctrl = FreeGameController(
        PlaySoundUseCase(SoundEffectService()),
        PlayMove(
          GameRepositoryImpl(
            local: LocalDataSourceImpl(Get.find<Isar>()),
            stockfish: Get.find<StockfishDataSource>(),
          ),
        ),
        Get.find(),
      );
      ctrl.onInit();
    });

    test('Initial FEN is standard chess', () {
      expect(ctrl.fen, equals(kInitialFEN));
    });

    test('Playing move updates fen', () {
      final move = Move.parse('e4');
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
      // final move = NormalMove(
      //   from: Square.fromName('a7'),
      //   to: Square.fromName('a8'),
      // );
      ctrl.onPromotionSelection(Role.queen);
      expect(ctrl.promotionMove, isNull);
    });
  });
}
