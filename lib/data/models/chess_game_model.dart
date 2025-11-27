import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/game_termination_enum.dart';
import '../../domain/entities/chess_game_entity.dart';
import '../collections/chess_game.dart';
import 'move_data_model.dart';
import 'player_model.dart';

part 'chess_game_model.freezed.dart';
part 'chess_game_model.g.dart'; // لترميز/فك ترميز JSON

@freezed
abstract class ChessGameModel with _$ChessGameModel {
  const factory ChessGameModel({
    required final int? id,
    required final String uuid,
    String? event,
    String? site,
    DateTime? date,
    String? round,
    required final PlayerModel whitePlayer,
    required final PlayerModel blackPlayer,

    @Default('*') String result, // "1-0", "0-1", "1/2-1/2", "*"
    @Default(GameTermination.ongoing) GameTermination termination,
    // إضافات تحليلية ووصفية
    String? eco,
    int? whiteElo,
    int? blackElo,
    String? timeControl,
    String? startingFen, // للـ non-standard start
    String? fullPgn, // النص الكامل للمباراة (مصدر)
    @Default(0) int movesCount,
    @Default([]) List<MoveDataModel> moves,
  }) = _ChessGameModel;

  // مُنشئ المصنع (Factory) لتحويل JSON إلى كائن ChessGameModel
  factory ChessGameModel.fromJson(Map<String, dynamic> json) =>
      _$ChessGameModelFromJson(json);
}

// امتداد لتحويل ChessGameModel إلى Isar Collection
extension ChessGameModelMapper on ChessGameModel {
  ChessGame toCollection() {
    final collection = ChessGame()
      ..uuid = uuid
      ..event = event
      ..site = site
      ..date = date
      ..round = round
      ..result = result
      ..termination = termination
      ..eco = eco
      ..whiteElo = whiteElo
      ..blackElo = blackElo
      ..timeControl = timeControl
      ..startingFen = startingFen
      ..fullPgn = fullPgn
      ..movesCount = movesCount
      ..moves = moves.map((m) => m.toCollection()).toList();

    // تعيين الحقول التي لا يتم تمريرها في مُنشئ Isar
    if (id != null) {
      collection.id = id!;
    }
    collection.whitePlayer.value = whitePlayer.toCollection();
    collection.blackPlayer.value = blackPlayer.toCollection();
    return collection;
  }

  // ⚠️ الأهم في المعمارية النظيفة: وظيفة التحويل (Mapper)
  // تحويل PlayerModel (البيانات الخارجية) إلى PlayerEntity (الكيان الداخلي)
  ChessGameEntity toEntity() {
    return ChessGameEntity(
      id: id,
      uuid: uuid,
      event: event,
      site: site,
      date: date,
      round: round,
      whitePlayer: whitePlayer.toEntity(),
      blackPlayer: blackPlayer.toEntity(),
      result: result,
      termination: termination,
      eco: eco,
      whiteElo: whiteElo,
      blackElo: blackElo,
      timeControl: timeControl,
      startingFen: startingFen,
      fullPgn: fullPgn,
      movesCount: movesCount,
      moves: moves.map((m) => m.toEntity()).toList(),
    );
  }
}
