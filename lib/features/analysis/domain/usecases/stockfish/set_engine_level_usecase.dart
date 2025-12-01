import 'package:chessground_game_app/core/errors/failures.dart';
import 'package:chessground_game_app/core/global_feature/domain/usecases/base/usecase.dart';
import 'package:chessground_game_app/core/utils/logger.dart';
import 'package:chessground_game_app/features/analysis/domain/repositories/stockfish_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

/// Use case for setting engine difficulty level
/// حالة استخدام لتعيين مستوى صعوبة المحرك
class SetEngineLevelUseCase implements UseCase<void, SetEngineLevelParams> {
  final StockfishRepository repository;

  SetEngineLevelUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SetEngineLevelParams params) async {
    try {
      AppLogger.info(
        'UseCase: Setting engine level to ${params.level}',
        tag: 'SetEngineLevelUseCase',
      );

      // Validate level
      if (params.level < 0 || params.level > 20) {
        return Left(
          ValidationFailure(message: 'Skill level must be between 0 and 20'),
        );
      }

      final result = await repository.setSkillLevel(params.level);

      result.fold(
        (failure) => AppLogger.error(
          'UseCase: Failed to set engine level - ${failure.message}',
          tag: 'SetEngineLevelUseCase',
        ),
        (_) => AppLogger.info(
          'UseCase: Engine level set successfully',
          tag: 'SetEngineLevelUseCase',
        ),
      );

      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'UseCase: Unexpected error',
        error: e,
        stackTrace: stackTrace,
        tag: 'SetEngineLevelUseCase',
      );

      return Left(
        DatabaseFailure(message: 'Failed to set engine level: ${e.toString()}'),
      );
    }
  }
}

class SetEngineLevelParams extends Equatable {
  final int level;

  const SetEngineLevelParams({required this.level});

  @override
  List<Object?> get props => [level];
}
