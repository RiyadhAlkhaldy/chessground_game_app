import 'package:chessground_game_app/core/l10n_build_context.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';

import 'game_status.dart';
import '../styles/lichess_icons.dart';

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
      return winner == Side.black
          ? context.l10n.whiteResigned
          : context.l10n.blackResigned;
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
      return winner == Side.black
          ? context.l10n.whiteDidntMove
          : context.l10n.blackDidntMove;
    case GameStatus.unknownFinish:
      return context.l10n.finished;
    case GameStatus.cheat:
      return context.l10n.cheatDetected;
    default:
      return gameStatus.toString();
  }
}

/// Set of supported variants for reading a game (not playing).
const ISet<Variant> readSupportedVariants = ISetConst({
  Variant.standard,
  Variant.chess960,
  Variant.fromPosition,
  Variant.antichess,
  Variant.kingOfTheHill,
  Variant.threeCheck,
  Variant.racingKings,
  Variant.horde,
});

/// Set of supported variants for playing a game.
const ISet<Variant> playSupportedVariants = ISetConst({
  Variant.standard,
  Variant.chess960,
  Variant.fromPosition,
});

enum Variant {
  standard('Standard', LichessIcons.crown),
  chess960('Chess960', LichessIcons.die_six),
  fromPosition('From Position', LichessIcons.feather),
  antichess('Antichess', LichessIcons.antichess),
  kingOfTheHill('King of the Hill', LichessIcons.flag),
  threeCheck('Three Check', LichessIcons.three_check),
  atomic('Atomic', LichessIcons.atom),
  horde('Horde', LichessIcons.horde),
  racingKings('Racing Kings', LichessIcons.racing_kings),
  crazyhouse('Crazyhouse', LichessIcons.h_square);

  const Variant(this.label, this.icon);

  final String label;
  final IconData icon;

  bool get isReadSupported => readSupportedVariants.contains(this);

  bool get isPlaySupported => playSupportedVariants.contains(this);

  static final IMap<String, Variant> nameMap = IMap(values.asNameMap());

  static Variant fromRule(Rule rule) {
    switch (rule) {
      case Rule.chess:
        return Variant.standard;
      case Rule.antichess:
        return Variant.antichess;
      case Rule.kingofthehill:
        return Variant.kingOfTheHill;
      case Rule.threecheck:
        return Variant.threeCheck;
      case Rule.atomic:
        return Variant.atomic;
      case Rule.horde:
        return Variant.horde;
      case Rule.racingKings:
        return Variant.racingKings;
      case Rule.crazyhouse:
        return Variant.crazyhouse;
    }
  }

  /// Returns the initial position for this [Variant].
  ///
  /// Will throw an [ArgumentError] if called on [Variant.chess960] or [Variant.fromPosition].
  Position get initialPosition {
    switch (this) {
      case Variant.standard:
        return Chess.initial;
      case Variant.chess960:
        throw ArgumentError(
          'Chess960 has not single initial position, use randomChess960Position() instead.',
        );
      case Variant.fromPosition:
        throw ArgumentError('This variant has no defined initial position!');
      case Variant.antichess:
        return Antichess.initial;
      case Variant.kingOfTheHill:
        return KingOfTheHill.initial;
      case Variant.threeCheck:
        return ThreeCheck.initial;
      case Variant.atomic:
        return Atomic.initial;
      case Variant.crazyhouse:
        return Crazyhouse.initial;
      case Variant.horde:
        return Horde.initial;
      case Variant.racingKings:
        return RacingKings.initial;
    }
  }

  Rule get rule {
    switch (this) {
      case Variant.standard:
      case Variant.chess960:
      case Variant.fromPosition:
        return Rule.chess;
      case Variant.antichess:
        return Rule.antichess;
      case Variant.kingOfTheHill:
        return Rule.kingofthehill;
      case Variant.threeCheck:
        return Rule.threecheck;
      case Variant.atomic:
        return Rule.atomic;
      case Variant.horde:
        return Rule.horde;
      case Variant.racingKings:
        return Rule.racingKings;
      case Variant.crazyhouse:
        return Rule.crazyhouse;
    }
  }
}
