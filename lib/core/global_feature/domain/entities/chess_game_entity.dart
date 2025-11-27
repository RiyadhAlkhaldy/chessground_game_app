import 'package:chessground_game_app/core/game_termination_enum.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/move_data_entity.dart';
import 'package:chessground_game_app/core/global_feature/domain/entities/player_entity.dart';

class ChessGameEntity {
  final int? id;
  final String uuid;
  final String? event;
  final String? site;
  final DateTime? date;
  final String? round;

  // 🛑 تم استبدال PlayerModel بـ PlayerEntity
  final PlayerEntity whitePlayer;
  final PlayerEntity blackPlayer;

  final String result; // "1-0", "0-1", "1/2-1/2", "*"
  final GameTermination termination;

  // إضافات تحليلية ووصفية
  final String? eco;
  final int? whiteElo;
  final int? blackElo;
  final String? timeControl;
  final String? startingFen;
  final String? fullPgn;
  final int movesCount;

  // 🛑 تم استبدال List<MoveDataModel> بـ List<MoveDataEntity>
  final List<MoveDataEntity> moves;

  ChessGameEntity({
    this.id,
    required this.uuid,
    this.event,
    this.site,
    this.date,
    this.round,
    required this.whitePlayer,
    required this.blackPlayer,
    this.result = '*',
    this.termination = GameTermination.ongoing,
    this.eco,
    this.whiteElo,
    this.blackElo,
    this.timeControl,
    this.startingFen,
    this.fullPgn,
    this.movesCount = 0,
    this.moves = const [],
  });

  // 💡 يجب إضافة دالة copyWith للمساعدة في تحديث الكيان في حالات الاستخدام
  ChessGameEntity copyWith({
    int? id,
    String? uuid,
    String? event,
    String? site,
    DateTime? date,
    String? round,
    PlayerEntity? whitePlayer,
    PlayerEntity? blackPlayer,
    String? result,
    GameTermination? termination,
    String? eco,
    int? whiteElo,
    int? blackElo,
    String? timeControl,
    String? startingFen,
    String? fullPgn,
    int? movesCount,
    List<MoveDataEntity>? moves,
  }) {
    // ... منطق العودة إلى كائن جديد
    return ChessGameEntity(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      event: event ?? this.event,
      site: site ?? this.site,
      date: date ?? this.date,
      round: round ?? this.round,
      whitePlayer: whitePlayer ?? this.whitePlayer,
      blackPlayer: blackPlayer ?? this.blackPlayer,
      result: result ?? this.result,
      termination: termination ?? this.termination,
      eco: eco ?? this.eco,
      whiteElo: whiteElo ?? this.whiteElo,
      blackElo: blackElo ?? this.blackElo,
      timeControl: timeControl ?? this.timeControl,
      startingFen: startingFen ?? this.startingFen,
      fullPgn: fullPgn ?? this.fullPgn,
      movesCount: movesCount ?? this.movesCount,
      moves: moves ?? this.moves,
    );
  }
}
