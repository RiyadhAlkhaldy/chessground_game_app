import 'package:chessground_game_app/core/l10n_build_context.dart';
import 'package:chessground_game_app/core/utils/dialog/game_status.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/widgets.dart';

String gameStatusL10n(
  BuildContext context, {
  required GameStatus gameStatus,
  required Position lastPosition,
  Side? winner,
  bool? isThreefoldRepetition,
}) {
  switch (gameStatus) {
    case GameStatus.started:
      return context.l10n.playingRightNow;
    case GameStatus.aborted:
      return context.l10n.gameAborted;
    case GameStatus.checkmate:
      return context.l10n.checkmate;
    case GameStatus.resign:
      return winner == Side.black ? context.l10n.whiteResigned : context.l10n.blackResigned;
    case GameStatus.stalemate:
      return context.l10n.stalemate;
    case GameStatus.timeout:
      return winner == null
          ? lastPosition.turn == Side.white
                ? '${context.l10n.whiteLeftTheGame} • ${context.l10n.draw}'
                : '${context.l10n.blackLeftTheGame} • ${context.l10n.draw}'
          : winner == Side.black
          ? context.l10n.whiteLeftTheGame
          : context.l10n.blackLeftTheGame;
    case GameStatus.insufficientMaterialClaim:
      return '${context.l10n.insufficientMaterial} • ${context.l10n.draw}';
    case GameStatus.draw:
      if (lastPosition.isInsufficientMaterial) {
        return '${context.l10n.insufficientMaterial} • ${context.l10n.draw}';
      } else if (isThreefoldRepetition == true) {
        return '${context.l10n.threefoldRepetition} • ${context.l10n.draw}';
      } else {
        return context.l10n.draw;
      }
    case GameStatus.outoftime:
      return winner == null
          ? lastPosition.turn == Side.white
                ? '${context.l10n.whiteTimeOut} • ${context.l10n.draw}'
                : '${context.l10n.blackTimeOut} • ${context.l10n.draw}'
          : winner == Side.black
          ? context.l10n.whiteTimeOut
          : context.l10n.blackTimeOut;
    case GameStatus.noStart:
      return winner == Side.black ? context.l10n.whiteDidntMove : context.l10n.blackDidntMove;
    case GameStatus.unknownFinish:
      return context.l10n.finished;
    case GameStatus.cheat:
      return context.l10n.cheatDetected;
    default:
      return gameStatus.toString();
  }
}
