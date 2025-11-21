import 'package:chessground_game_app/core/global_feature/data/models/chess_game_model.dart';
import 'package:chessground_game_app/core/global_feature/data/models/move_data_model.dart';
import 'package:chessground_game_app/core/global_feature/data/models/player_model.dart'; // يتم هنا استيراد Model
import 'package:chessground_game_app/core/global_feature/domain/entities/chess_game_entity.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/move_data_entity.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/player_entity.dart';

extension PlayerEntityToModelMapper on PlayerEntity {
  PlayerModel toModel() {
    return PlayerModel(
      id: id,
      uuid: uuid,
      name: name,
      type: type,
      playerRating: playerRating,
      email: email,
      image: image,
      createdAt: createdAt,
    );
  }
}

extension ChessGameEntityToModelMapper on ChessGameEntity {
  ChessGameModel toModel() {
    return ChessGameModel(
      id: id,
      uuid: uuid,
      event: event,
      site: site,
      date: date,
      round: round,
      whitePlayer: whitePlayer.toModel(),
      blackPlayer: blackPlayer.toModel(),
      result: result,
      termination: termination,
      eco: eco,
      whiteElo: whiteElo,
      blackElo: blackElo,
      timeControl: timeControl,
      startingFen: startingFen,
      fullPgn: fullPgn,
      movesCount: movesCount,
      moves: moves.map((m) => m.toModel()).toList(),
    );
  }
}

// 💡 ملاحظة: يجب أيضاً إنشاء Mapper من Entity إلى Model إذا احتجت إلى إرسال البيانات
extension MoveDataEntityMapper on MoveDataEntity {
  MoveDataModel toModel() {
    return MoveDataModel(
      san: san,
      lan: lan,
      comment: comment,
      nags: nags,
      fenAfter: fenAfter,
      variations: variations,
      wasCapture: wasCapture,
      wasCheck: wasCheck,
      wasCheckmate: wasCheckmate,
      wasPromotion: wasPromotion,
      isWhiteMove: isWhiteMove,
      halfmoveIndex: halfmoveIndex,
      moveNumber: moveNumber,
    );
  }
}
