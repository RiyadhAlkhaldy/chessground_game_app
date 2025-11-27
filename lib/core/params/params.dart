import 'package:chessground_game_app/core/global_feature/domain/entities/player_entity.dart';

class TemplateParams {
  final String id;
  TemplateParams({required this.id});
}

class UserParams {
  final String id;
  UserParams({required this.id});
}

class PostParams {
  final String id;
  PostParams({required this.id});
}

class InitChessGameParams {
  InitChessGameParams({this.event, this.site, this.date, this.whitePlayer, this.blackPlayer});

  final String? event;
  final String? site;
  final DateTime? date;
  final PlayerEntity? whitePlayer;
  final PlayerEntity? blackPlayer;

  @override
  String toString() {
    return "event";
  }
}
