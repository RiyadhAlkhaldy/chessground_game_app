import 'package:chessground_game_app/features/analysis/domain/repositories/stockfish_repository.dart';
import 'package:chessground_game_app/features/analysis/domain/usecases/stockfish/analyze_position_usecase.dart';
import 'package:chessground_game_app/features/analysis/domain/usecases/stockfish/get_best_move_usecase.dart';
import 'package:chessground_game_app/features/analysis/domain/usecases/stockfish/get_best_move_with_time_usecase.dart';
import 'package:chessground_game_app/features/analysis/domain/usecases/stockfish/get_best_move_with_time_and_depth_usecase.dart';
import 'package:chessground_game_app/features/analysis/domain/usecases/stockfish/get_hint_usecase.dart';
import 'package:chessground_game_app/features/analysis/domain/usecases/stockfish/set_engine_level_usecase.dart';
import 'package:chessground_game_app/features/analysis/domain/usecases/stockfish/stream_analysis_usecase.dart';
import 'package:get/get.dart';
import 'package:chessground_game_app/di/ingection_container.dart';
import 'package:chessground_game_app/features/analysis/presentation/controllers/stockfish_controller.dart';

/// Binding for StockfishController
/// ربط StockfishController
class StockfishBinding extends Bindings {
  @override
  void dependencies() {
    // Register StockfishController as singleton (shared across app)
    Get.put<StockfishController>(
      StockfishController(
        repository: sl<StockfishRepository>(),
        analyzePositionUseCase: sl<AnalyzePositionUseCase>(),
        getBestMoveUseCase: sl<GetBestMoveUseCase>(),
        getBestMoveWithTimeUseCase: sl<GetBestMoveWithTimeUseCase>(),
        getBestMoveWithTimeAndDepthUseCase:
            sl<GetBestMoveWithTimeAndDepthUseCase>(),
        getHintUseCase: sl<GetHintUseCase>(),
        streamAnalysisUseCase: sl<StreamAnalysisUseCase>(),
        setEngineLevelUseCase: sl<SetEngineLevelUseCase>(),
      ),
      // permanent: true, // Keep alive throughout app lifecycle
    );
  }
}

// lib/presentation/bindings/game_analysis_binding.dart
