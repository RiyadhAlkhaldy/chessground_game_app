// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chess_game_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChessGameModelImpl _$$ChessGameModelImplFromJson(Map<String, dynamic> json) =>
    _$ChessGameModelImpl(
      id: (json['id'] as num?)?.toInt(),
      uuid: json['uuid'] as String,
      event: json['event'] as String?,
      site: json['site'] as String?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      round: json['round'] as String?,
      whitePlayer:
          PlayerModel.fromJson(json['whitePlayer'] as Map<String, dynamic>),
      blackPlayer:
          PlayerModel.fromJson(json['blackPlayer'] as Map<String, dynamic>),
      result: json['result'] as String? ?? '*',
      termination:
          $enumDecodeNullable(_$GameTerminationEnumMap, json['termination']) ??
              GameTermination.ongoing,
      eco: json['eco'] as String?,
      whiteElo: (json['whiteElo'] as num?)?.toInt(),
      blackElo: (json['blackElo'] as num?)?.toInt(),
      timeControl: json['timeControl'] as String?,
      startingFen: json['startingFen'] as String?,
      fullPgn: json['fullPgn'] as String?,
      movesCount: (json['movesCount'] as num?)?.toInt() ?? 0,
      moves: (json['moves'] as List<dynamic>?)
              ?.map((e) => MoveDataModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ChessGameModelImplToJson(
        _$ChessGameModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'event': instance.event,
      'site': instance.site,
      'date': instance.date?.toIso8601String(),
      'round': instance.round,
      'whitePlayer': instance.whitePlayer,
      'blackPlayer': instance.blackPlayer,
      'result': instance.result,
      'termination': _$GameTerminationEnumMap[instance.termination]!,
      'eco': instance.eco,
      'whiteElo': instance.whiteElo,
      'blackElo': instance.blackElo,
      'timeControl': instance.timeControl,
      'startingFen': instance.startingFen,
      'fullPgn': instance.fullPgn,
      'movesCount': instance.movesCount,
      'moves': instance.moves,
    };

const _$GameTerminationEnumMap = {
  GameTermination.checkmate: 'checkmate',
  GameTermination.stalemate: 'stalemate',
  GameTermination.timeout: 'timeout',
  GameTermination.resignation: 'resignation',
  GameTermination.agreement: 'agreement',
  GameTermination.threefoldRepetition: 'threefoldRepetition',
  GameTermination.fiftyMoveRule: 'fiftyMoveRule',
  GameTermination.insufficientMaterial: 'insufficientMaterial',
  GameTermination.ongoing: 'ongoing',
};
