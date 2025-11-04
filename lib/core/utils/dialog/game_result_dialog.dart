import 'dart:async';
import 'dart:math';

import 'package:chessground_game_app/core/utils/dialog/constants/const.dart';
import 'package:chessground_game_app/core/l10n_build_context.dart';
import 'package:chessground_game_app/core/utils/dialog/status_l10n.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/game_state/game_state.dart';
import 'game_status.dart';

class GameResultDialog extends StatefulWidget {
  const GameResultDialog({
    super.key,
    required this.gameState,
    required this.gameStatus,
    required this.reset,
  });
  final void Function() reset;
  final GameState gameState;
  final GameStatus gameStatus;
  @override
  State<GameResultDialog> createState() => _GameResultDialogState();
}

class _GameResultDialogState extends State<GameResultDialog> {
  late Timer _buttonActivationTimer;
  bool _activateButtons = false;
  @override
  void initState() {
    _buttonActivationTimer = Timer(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _activateButtons = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _buttonActivationTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: GameResult(
            gameState: widget.gameState,
            gameStatus: widget.gameStatus,
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 400),
          firstCurve: Curves.easeOutExpo,
          secondCurve: Curves.easeInExpo,
          sizeCurve: Curves.easeInOut,
          firstChild: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Flexible(
              //   // flex: 3,
              //   child: Text(
              //     // maxLines: ,
              //     context.l10n.rematchOfferSent,
              //     // overflow: TextOverflow.ellipsis,
              //   ),
              // ),
              // const Spacer(),
              // IconButton.outlined(
              //   onPressed: () {},
              //   tooltip: context.l10n.cancelRematchOffer,
              //   icon: const Icon(Icons.cancel),
              // ),
              Expanded(
                child: FilledButton(
                  onPressed: _activateButtons
                      ? () {
                          Get.back(); // Close the dialog
                          Get.back(); // Close the dialog
                          widget.reset();
                        }
                      : null,
                  child: Text(context.l10n.rematch),
                ),
              ),
              FilledButton.tonal(
                onPressed: () {
                  Get.back(); // Close the dialog
                },
                child: Text(context.l10n.no, textAlign: TextAlign.center),
              ),
              const SizedBox.shrink(),
            ],
          ),
          secondChild: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Text(
                  context.l10n.yourOpponentWantsToPlayANewGameWithYou,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton.filled(
                      icon: const Icon(Icons.check),
                      style: FilledButton.styleFrom(
                        foregroundColor: ColorScheme.of(context).onPrimary,
                        backgroundColor: ColorScheme.of(context).primary,
                      ),
                      tooltip: context.l10n.accept,
                      onPressed: () {},
                    ),
                    IconButton.filled(
                      icon: const Icon(Icons.close),
                      style: FilledButton.styleFrom(
                        foregroundColor: ColorScheme.of(context).onError,
                        backgroundColor: ColorScheme.of(context).error,
                      ),
                      tooltip: context.l10n.decline,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
          // crossFadeState: widget.gameStatus == GameStatus.noStart
          //     ? CrossFadeState.showSecond
          //     : CrossFadeState.showFirst,
          crossFadeState: CrossFadeState.showFirst,
        ),
        // if (widget.gameState.isGameOverExtended)
        //   FilledButton.tonal(
        //     onPressed: () {},
        //     child: Text(context.l10n.newOpponent, textAlign: TextAlign.center),
        //   ),

        // FilledButton.icon(
        //   icon: const Icon(Icons.play_arrow),
        //   onPressed: () {
        //     Navigator.of(context).popUntil((route) => route is! PopupRoute);
        //     WidgetsBinding.instance.addPostFrameCallback((_) {
        //       Navigator.of(context).pop(); // Pop the screen after frame
        //     });
        //   },
        //   label: Text(
        //     context.l10n.backToTournament,
        //     textAlign: TextAlign.center,
        //   ),
        // ),

        // FilledButton.tonalIcon(
        //   icon: const Icon(Icons.pause),
        //   onPressed: () {
        //     Navigator.of(context).popUntil((route) => route is! PopupRoute);
        //     // Close the game screen
        //     WidgetsBinding.instance.addPostFrameCallback((_) {
        //       Navigator.of(context).pop(); // Pop the screen after frame
        //     });
        //   },
        //   label: Text(context.l10n.pause, textAlign: TextAlign.center),
        // ),

        // FilledButton.tonal(
        //   onPressed: () {},
        //   child: Text(context.l10n.analysis, textAlign: TextAlign.center),
        // ),
      ],
    );

    return _ResultDialog(child: content);
  }
}

class GameResult extends StatelessWidget {
  const GameResult({
    super.key,
    required this.gameState,
    required this.gameStatus,
  });
  final GameState gameState;
  final GameStatus gameStatus;

  @override
  Widget build(BuildContext context) {
    final showWinner = gameState.result != null
        ? ' • ${gameState.result?.winner == Side.white ? context.l10n.whiteIsVictorious : context.l10n.blackIsVictorious}'
        : '';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (gameStatus.value >= GameStatus.checkmate.value)
          Text(
            gameState.result?.winner == null
                ? '½-½'
                : gameState.result?.winner == Side.white
                ? '1-0'
                : '0-1',
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        const SizedBox(height: 6.0),
        Text(
          '${gameStatusL10n(context, gameStatus: gameStatus, lastPosition: gameState.position, winner: gameState.result?.winner, isThreefoldRepetition: gameState.isThreefoldRepetition())}$showWinner',
          style: const TextStyle(fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ResultDialog extends StatelessWidget {
  const _ResultDialog({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final paddedContent = Padding(
      padding: const EdgeInsets.all(16.0),
      child: child,
    );
    final sizedContent = SizedBox(
      width: min(screenWidth, kMaterialPopupMenuMaxWidth),
      child: paddedContent,
    );
    return Dialog(child: sizedContent);
  }
}
