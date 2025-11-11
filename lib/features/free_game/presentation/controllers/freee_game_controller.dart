import 'dart:async';

import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/domain/entities/player_entity.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/game_termination_enum.dart';
import '../../../../core/params/params.dart';
import '../../../../core/utils/dialog/game_result_dialog.dart';
import '../../../../core/utils/dialog/game_status.dart';
import '../../../../core/utils/dialog/status_l10n.dart';
import '../../../../core/utils/game_state/game_state.dart';
import '../../../../data/collections/chess_game.dart';
import '../../../../data/models/move_data_model.dart';
import '../../../../domain/entities/chess_game_entity.dart';
import '../../../../domain/services/chess_game_storage_service.dart';
import '../../../../domain/usecases/init_chess_game.dart';
import '../../../../domain/usecases/play_move.dart';
import '../../../../domain/usecases/play_sound_usecase.dart';
import '../../../../presentation/controllers/chess_board_settings_controller.dart';
import '../../../../presentation/controllers/get_storage_controller.dart';

class FreeGameController extends GetxController {
  Position get initail => Chess.fromSetup(Setup.parseFen(_initailLocalFen));
  String get _initailLocalFen => Chess.initial.fen;
  // String get _initailLocalFen => "8/P7/8/k7/8/8/8/K7 w - - 0 1";
  late String _fen;

  // ignore: unnecessary_getters_setters
  String get fen => _fen;

  set fen(String value) => _fen = value;

  ValidMoves validMoves = IMap(const {});

  bool get isCheckmate => gameState.value!.isCheckmate;

  Side? get winner {
    return getResult?.winner;
  }

  Rxn<PlayerEntity> whitePlayer = Rxn();
  Rxn<PlayerEntity> blackPlayer = Rxn();

  bool canPop = false;
  NormalMove? promotionMove;
  NormalMove? premove;
  PlayerSide playerSide = PlayerSide.both;
  Future<void> _initPlayer() async {
    final response = await initChessGame(
      InitChessGameParams(site: 'Riyadh alkhaldy', event: 'play with computer'),
    );
    response.fold((l) {}, (chsGameEnty) {
      chessGameEntity = chsGameEnty;
      whitePlayer.value = chsGameEnty.whitePlayer;
      blackPlayer.value = chsGameEnty.blackPlayer;
    });
  }

  final PlaySoundUseCase plySound;
  final PlayMove playMoveUsecase;
  final InitChessGame initChessGame;
  ChessGameEntity? chessGameEntity;
  final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();
  final storage = Get.find<GetStorageControllerImp>();
  Rxn<GameState> gameState = Rxn<GameState>();
  // final RxBool isLoading = false.obs;
  final RxnString error = RxnString();

  // load existing game from repository (usecase loadGame not shown here)
  void setGameState(GameState state) {
    gameState.value = state;
  }

  FreeGameController(this.plySound, this.playMoveUsecase, this.initChessGame);

  @override
  void onInit() {
    super.onInit();
    _initPlayer().then((_) async {
      await plySound.executeDongSound();
    });
    gameState.value = GameState(initial: initail);
    fen = gameState.value!.position.fen;
    validMoves = makeLegalMoves(gameState.value!.position);
    _listenToGameStatus();
  }

  void _listenToGameStatus() {
    gameState.value!.gameStatus.listen((status) {
      if (gameState.value!.turn == Side.white) {
        statusText.value = "دور الأبيض";
      } else if (gameState.value!.turn == Side.black) {
        statusText.value = "دور الأسود";
      }
      if (gameState.value!.isCheck) {
        statusText.value += '(كش)';
      }
      if (status != GameStatus.ongoing) {
        statusText.value =
            "${gameStatusL10n(Get.context!, gameStatus: gameStatus, lastPosition: gameState.value!.position, winner: gameState.value!.result?.winner, isThreefoldRepetition: gameState.value!.isThreefoldRepetition())} ";
        Get.dialog(
          GameResultDialog(
            gameState: gameState.value!,
            gameStatus: status,
            reset: reset,
          ),
        );
      }
    });
  }

  // // النسخة المعدلة من getResult
  Outcome? get getResult {
    return gameState.value!.result;
  }

  RxString statusText = "free Play".obs;

  GameStatus get gameStatus => gameState.value!.status();

  /// Agreement draw: set result to draw.
  void setAgreementDraw() => {gameState.value!.setAgreementDraw(), update()};

  /// Resign: if side resigns, winner is the other side.
  void resign(Side side) => {
    gameState.value!.resign(side),
    plySound.executeResignSound(),
    update(),
  };

  ///reset
  void reset() {
    gameState.value = GameState(initial: initail);
    fen = gameState.value!.position.fen;
    validMoves = makeLegalMoves(gameState.value!.position);
    promotionMove = null;
    debugPrint('reset to $fen');
    plySound.executeDongSound();
    statusText.value = "free Play";

    update();
  }

  void tryPlayPremove() {
    if (premove != null) {
      Timer.run(() {
        onUserMoveAgainstAI(premove!, isPremove: true);
      });
    }
  }

  void onSetPremove(NormalMove? move) {
    debugPrint("onSetPremove $move");
    premove = move;
    update();
  }

  void onPromotionSelection(Role? role) {
    debugPrint('onPromotionSelection: $role');
    if (role == null) {
      onPromotionCancel();
    } else if (promotionMove != null) {
      debugPrint('promotionMove != null');
      onUserMoveAgainstAI(promotionMove!.withPromotion(role));
    }
  }

  void onPromotionCancel() {
    promotionMove = null;
    update();
  }

  void onUserMoveAgainstAI(
    NormalMove move, {
    bool? isDrop,
    bool? isPremove,
  }) async {
    if (isPromotionPawnMove(move)) {
      promotionMove = move;
      update();
    } else if (gameState.value!.position.isLegal(move)) {
      _applyMove(move);
      // validMoves = IMap(const {});
      promotionMove = null;
      debugPrint(
        "gameState.value!.position.fen: ${gameState.value!.position.fen}",
      );
      update();
    }
    tryPlayPremove();
  }

  // --- [دالة جديدة] لتطبيق النقلة وتحديث التاريخ ---
  void _applyMove(NormalMove move) async {
    final state = gameState.value!;
    // isLoading.value = true;
    final res = await playMoveUsecase(
      chessGameEntity: chessGameEntity!,
      state: state,
      move: move,
      comment: null,
      nags: [],
      // persist: true,
    );
    res.fold(
      (f) {
        error.value = f.toString();
      },
      (_) {
        // update observed gameState.value! (GameState mutated in-place)
        gameState.refresh();
        fen = gameState.value!.position.fen;
        validMoves = makeLegalMoves(gameState.value!.position);

        // decide which sound to play based on metadata
        final meta = gameState.value!.lastMoveMeta;
        if (meta != null) {
          // capture has priority (play capture instead of plain move)
          if (meta.wasCapture) {
            plySound.executeCaptureSound();
          } else {
            plySound.executeMoveSound();
          }
          if (meta.wasPromotion) {
            plySound.executePromoteSound();
          }
          if (meta.wasCheckmate) {
            plySound.executeCheckmateSound();
          } else if (meta.wasCheck) {
            plySound.executeCheckSound();
          }
        } else {
          // fallback
          plySound.executeMoveSound();
        }
        gameStatus; // to update statusText
      },
    );
    // isLoading.value = false;
  }

  bool isPromotionPawnMove(NormalMove move) {
    return move.promotion == null &&
        gameState.value!.position.board.roleAt(move.from) == Role.pawn &&
        ((move.to.rank == Rank.first &&
                gameState.value!.position.turn == Side.black) ||
            (move.to.rank == Rank.eighth &&
                gameState.value!.position.turn == Side.white));
  }

  // if can undo return true , if can redo return true
  RxBool get canUndo =>
      (!gameState.value!.isGameOverExtended && gameState.value!.canUndo).obs;
  RxBool get canRedo =>
      (!gameState.value!.isGameOverExtended && gameState.value!.canRedo).obs;

  void undoMove() {
    if (canUndo.value) {
      gameState.value!.undoMove();
      fen = gameState.value!.position.fen;
      validMoves = makeLegalMoves(gameState.value!.position);
      // play a feedback sound (optional)
      plySound.executeMoveSound();
      update();
    }
  }

  void redoMove() {
    if (canRedo.value) {
      gameState.value!.redoMove();
      fen = gameState.value!.position.fen;
      validMoves = makeLegalMoves(gameState.value!.position);
      plySound.executeMoveSound();
      update();
    }
  }

  /// expose PGN tokens for the UI
  List<MoveDataModel> get pgnTokens => gameState.value!.getMoveTokens;

  int get currentHalfmoveIndex => gameState.value!.currentHalfmoveIndex;

  /// jump to a halfmove index (0-based). This will rebuild the game state up to that halfmove.
  /// Implementation: get a copy of move objects from gameState.value!, construct a fresh GameState
  /// and replay moves up to `index` then replace controller.gameState.value! with rebuilt one.
  void jumpToHalfmove(int index) {
    final allMoves = gameState.value!.getMoveObjectsCopy();
    final newState = GameState(initial: initail);
    for (int i = 0; i <= index && i < allMoves.length; i++) {
      newState.play(allMoves[i]);
    }
    gameState.value = newState;
    fen = gameState.value!.position.fen;
    validMoves = makeLegalMoves(gameState.value!.position);
    update();
  }

  Map<Role, int> get whiteCaptured =>
      gameState.value!.getCapturedPieces(Side.white);
  Map<Role, int> get blackCaptured =>
      gameState.value!.getCapturedPieces(Side.black);
  String get whiteCapturedText =>
      gameState.value!.capturedPiecesAsString(Side.white);
  String get whiteCapturedIcons =>
      gameState.value!.capturedPiecesAsUnicode(Side.white);
  String get blackCapturedIcons =>
      gameState.value!.capturedPiecesAsUnicode(Side.black);

  // في controller أو widget بعد استدعاء setState/update
  List<Role> get whiteCapturedList =>
      gameState.value!.getCapturedPiecesList(Side.white); // قائمة الرول مكررة
  List<Role> get blackCapturedList =>
      gameState.value!.getCapturedPiecesList(Side.black);

  @override
  void dispose() {
    gameState.value!.dispose();
    super.dispose();
  }
}

Future<void> saveSnapshotOnClose(
  ChessGame? currentGame,
  ChessGameStorageService storage,
  GameState gameState,
  PlayerEntity? savedWhitePlayer,
  PlayerEntity? savedBlackPlayer,
) async {
  if (currentGame == null) return;
  if (currentGame.termination == GameTermination.ongoing) return;
  try {
    // update currentGame fields from current memory state
    currentGame.moves = gameState.getMoveTokens
        .map((move) => move.toCollection())
        .toList(); // may need conversion
    currentGame.movesCount = currentGame.moves.length;
    currentGame.fullPgn = storage.manualPgnFromSanListForTest(
      // NOTE: storage._manualPgn... is internal; if private, call a public wrapper or reconstruct here
      <String, String>{
        'Event': currentGame.event ?? 'Free Play',
        'Site': currentGame.site ?? 'Local',
        'Date': currentGame.date != null
            ? currentGame.date!.toIso8601String().split('T').first
            : DateTime.now().toIso8601String().split('T').first,
        'White':
            currentGame.whitePlayer.value?.name ??
            savedWhitePlayer?.name ??
            'White',
        'Black':
            currentGame.blackPlayer.value?.name ??
            savedBlackPlayer?.name ??
            'Black',
        'Result': currentGame.result ?? '*',
      },
      currentGame.moves,
      currentGame.result ?? '*',
    );

    await storage.saveGameSnapshot(currentGame);
    debugPrint('Saved game snapshot id=${currentGame.id}');
  } catch (e) {
    // If storage doesn't expose pgn builder, just call saveGameSnapshot without updating fullPgn
    try {
      await storage.saveGameSnapshot(currentGame);
    } catch (err) {
      debugPrint('Error saving snapshot fallback: $err');
    }
    debugPrint('Error preparing snapshot: $e');
  }
}

// ignore: unused_element
MoveDataModel? _buildMoveDataFromLastMove(GameState gameState) {
  // gameState should have last move tokens or last move object
  // get last move SAN / LAN and meta
  final tokens =
      gameState.getMoveTokens; // List<MoveDataModel> from dartchess? or similar
  if (tokens.isEmpty) return null;

  // get the last MoveDataModel token the GameState provides (this may differ in shape)
  // For safety we attempt to retrieve the last move object via gameState.currentHalfmoveIndex
  final halfmoveIndex = gameState.currentHalfmoveIndex;
  // try to get the last move object (GameState provides getMoveObjectsCopy())
  final allMoves = gameState.allMoves;
  if (allMoves.isEmpty ||
      halfmoveIndex < 0 ||
      halfmoveIndex >= allMoves.length) {
    // fallback: use tokens last
    final lastToken = tokens.isNotEmpty ? tokens.last : null;
    if (lastToken == null) return null;
    final md = MoveDataModel(
      moveNumber: lastToken.moveNumber,
      san: lastToken.san,
      comment: lastToken.comment,
      nags: lastToken.nags,
      fenAfter: lastToken.fenAfter,
      isWhiteMove: lastToken.isWhiteMove,
      halfmoveIndex: allMoves.length,
      wasCapture: lastToken.wasCapture,
      wasPromotion: lastToken.wasPromotion,
      wasCheck: lastToken.wasCheck,
      wasCheckmate: lastToken.wasCheckmate,
      variations: lastToken.variations,
      lan: lastToken.lan ?? '',
    );

    return md;
  } else {
    // convert NormalMove object at allMoves[halfmoveIndex] to MoveDataModel
    final normalMove = allMoves[halfmoveIndex];
    // get SAN token corresponding to this normalMove if possible
    final sanToken = tokens.length > halfmoveIndex
        ? tokens[halfmoveIndex]
        : null;

    final md = MoveDataModel(
      san: sanToken?.san ?? normalMove.toString(),
      lan: _normalMoveToLan(Move.parse(normalMove.san!) as NormalMove),
      fenAfter: gameState.position.fen,
      comment: sanToken?.comment,
      nags: sanToken?.nags ?? [],
      variations: sanToken?.variations ?? [],
      wasCapture: normalMove.wasCapture,
      wasCheck: gameState.isCheck,
      wasCheckmate: gameState.isCheckmate,
      wasPromotion: normalMove.wasPromotion,
      isWhiteMove: normalMove.isWhiteMove,
      halfmoveIndex: halfmoveIndex,
      moveNumber: (halfmoveIndex ~/ 2) + 1,
    );
    return md;
  }
}

String _normalMoveToLan(NormalMove move) {
  // convert from/to squares to lan like 'e2e4' and include promotion if any
  // String sq(int file, int rank) => '${"abcdefgh"[file]}${rank + 1}';
  final from = move.from;
  final to = move.to;
  final fromStr = '${"abcdefgh"[from.file]}${from.rank + 1}';
  final toStr = '${"abcdefgh"[to.file]}${to.rank + 1}';
  var lan = '$fromStr$toStr';
  if (move.promotion != null) {
    final promChar = move.promotion!.name.substring(0, 1).toLowerCase();
    lan = '$lan$promChar';
  }
  return lan;
}

/// Map GameStatus to result string and call storage.endGame / finishGame
// ignore: unused_element
Future<void> _finalizeGame(
  GameStatus status,
  GameState gameState,
  ChessGame? currentGame,
  ChessGameStorageService storage,
  PlayerEntity savedWhitePlayer,
  PlayerEntity savedBlackPlayer,
) async {
  if (currentGame == null) return;
  String resultText = '*';
  String termination = 'ongoing';

  // map statuses
  switch (status) {
    case GameStatus.checkmate:
      // winner is other side of turn? gameState.result?.winner preferred
      final winSide = gameState.result?.winner;
      if (winSide == Side.white) resultText = '1-0';
      if (winSide == Side.black) resultText = '0-1';
      termination = 'checkmate';
      break;
    case GameStatus.stalemate:
      resultText = '1/2-1/2';
      termination = 'stalemate';
      break;
    case GameStatus.draw:
      resultText = '1/2-1/2';
      termination = 'agreement';
      break;
    case GameStatus.timeout:
      final win = gameState.result?.winner;
      if (win == Side.white) {
        resultText = '1-0';
      } else if (win == Side.black) {
        resultText = '0-1';
      } else {
        // fallback: determine opposite of who timed out - but we don't have that here
        resultText = '*';
      }
      termination = 'timeout';
      break;
    case GameStatus.ongoing:
    default:
      resultText = '*';
      termination = 'ongoing';
  }

  // build headers
  final headers = <String, String>{
    'Event': currentGame.event ?? 'Free Play',
    'Site': currentGame.site ?? 'Local',
    'Date': currentGame.date != null
        ? currentGame.date!.toIso8601String().split('T').first
        : DateTime.now().toIso8601String().split('T').first,
    'White': currentGame.whitePlayer.value?.name ?? savedWhitePlayer.name,
    'Black': currentGame.blackPlayer.value?.name ?? savedBlackPlayer.name,
    'Result': resultText,
  };

  try {
    // harvest movesData from currentGame.moves (already stored as MoveDataModel)
    final movesData = currentGame.moves;

    // call storage.endGame (signature per earlier service: endGame(chessGame, result, movesData, termination, headers))
    await storage.endGame(
      currentGame,
      result: resultText,
      movesData: movesData,
      termination: termination,
      headers: headers,
    );

    // mark local game object as finished
    currentGame.result = resultText;
    currentGame.termination !=
        GameTermination.values.firstWhere(
          (e) => e.toString().split('.').last == termination,
          orElse: () => GameTermination.ongoing,
        );
    currentGame.date = DateTime.now();
  } catch (e) {
    debugPrint('Error finalizing game to DB: $e');
  }
}

// class FreeGameController extends GetxController {
//   GameState gameState = GameState();

//   Position get initail => Chess.fromSetup(Setup.parseFen(_initailLocalFen));
//   String get _initailLocalFen => Chess.initial.fen;
//   // String get _initailLocalFen => "8/P7/8/k7/8/8/8/K7 w - - 0 1";
//   late String _fen;

//   // ignore: unnecessary_getters_setters
//   String get fen => _fen;

//   set fen(String value) => _fen = value;

//   ValidMoves validMoves = IMap(const {});

//   bool get isCheckmate => gameState.isCheckmate;

//   Side? get winner {
//     return getResult!.winner;
//   }

//   final PlaySoundUseCase plySound;
//   final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();
//   final storage = Get.find<GetStorageControllerImp>();

//   Rx<PlayerEntity> whitePlayer = PlayerEntity(
//     id: 1,
//     uuid: 'White_Player',
//     name: 'White Player',
//     type: 'player',
//     createdAt: DateTime.now(),
//   ).obs;
//   Rx<PlayerEntity> blackPlayer = PlayerEntity(
//     id: 2,
//     uuid: 'Black Player',
//     name: 'Black Player',
//     type: 'player',
//     createdAt: DateTime.now(),
//   ).obs;
//   FreeGameController(this.plySound);
//   bool canPop = false;
//   NormalMove? promotionMove;
//   NormalMove? premove;
//   PlayerSide playerSide = PlayerSide.both;
//   Future<void> _initPlayer() async {
//     final wPlayer = await createPlayerIfNotExists(storage);
//     final bPlayer = await createPlayerIfNotExists(storage, 'ai_user_uuid');
//     whitePlayer.value = wPlayer!.toModel();
//     blackPlayer.value = bPlayer!.toModel();
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     _initPlayer().then((_) async {
//       await plySound.executeDongSound();
//     });
//     gameState = GameState(initial: initail);
//     fen = gameState.position.fen;
//     validMoves = makeLegalMoves(gameState.position);
//     _listenToGameStatus();
//   }

//   void _listenToGameStatus() {
//     gameState.gameStatus.listen((status) {
//       if (gameState.turn == Side.white) {
//         statusText.value = "دور الأبيض";
//       } else if (gameState.turn == Side.black) {
//         statusText.value = "دور الأسود";
//       }
//       if (gameState.isCheck) {
//         statusText.value += '(كش)';
//       }
//       if (status != GameStatus.ongoing) {
//         statusText.value =
//             "${gameStatusL10n(Get.context!, gameStatus: gameStatus, lastPosition: gameState.position, winner: gameState.result?.winner, isThreefoldRepetition: gameState.isThreefoldRepetition())} ";
//         Get.dialog(
//           GameResultDialog(
//             gameState: gameState,
//             gameStatus: status,
//             reset: reset,
//           ),
//         );
//       }
//     });
//   }

//   // // النسخة المعدلة من getResult
//   Outcome? get getResult {
//     return gameState.result;
//   }

//   RxString statusText = "free Play".obs;

//   GameStatus get gameStatus => gameState.status();

//   /// Agreement draw: set result to draw.
//   void setAgreementDraw() => {gameState.setAgreementDraw(), update()};

//   /// Resign: if side resigns, winner is the other side.
//   void resign(Side side) => {
//     gameState.resign(side),
//     plySound.executeResignSound(),
//     update(),
//   };

//   ///reset
//   void reset() {
//     gameState = GameState(initial: initail);
//     fen = gameState.position.fen;
//     validMoves = makeLegalMoves(gameState.position);
//     promotionMove = null;
//     debugPrint('reset to $fen');
//     plySound.executeDongSound();
//     statusText.value = "free Play";

//     update();
//   }

//   void tryPlayPremove() {
//     if (premove != null) {
//       Timer.run(() {
//         onUserMoveAgainstAI(premove!, isPremove: true);
//       });
//     }
//   }

//   void onSetPremove(NormalMove? move) {
//     debugPrint("onSetPremove $move");
//     premove = move;
//     update();
//   }

//   void onPromotionSelection(Role? role) {
//     debugPrint('onPromotionSelection: $role');
//     if (role == null) {
//       onPromotionCancel();
//     } else if (promotionMove != null) {
//       debugPrint('promotionMove != null');
//       onUserMoveAgainstAI(promotionMove!.withPromotion(role));
//     }
//   }

//   void onPromotionCancel() {
//     promotionMove = null;
//     update();
//   }

//   void onUserMoveAgainstAI(
//     NormalMove move, {
//     bool? isDrop,
//     bool? isPremove,
//   }) async {
//     if (isPromotionPawnMove(move)) {
//       promotionMove = move;
//       update();
//     } else if (gameState.position.isLegal(move)) {
//       _applyMove(move);
//       // validMoves = IMap(const {});
//       promotionMove = null;
//       debugPrint("gameState.position.fen: ${gameState.position.fen}");
//       update();
//     }
//     tryPlayPremove();
//   }

//   // --- [دالة جديدة] لتطبيق النقلة وتحديث التاريخ ---
//   void _applyMove(NormalMove move) {
//     gameState.play(move);
//     fen = gameState.position.fen;
//     validMoves = makeLegalMoves(gameState.position);

//     // decide which sound to play based on metadata
//     final meta = gameState.lastMoveMeta;
//     if (meta != null) {
//       // capture has priority (play capture instead of plain move)
//       if (meta.wasCapture) {
//         plySound.executeCaptureSound();
//       } else {
//         plySound.executeMoveSound();
//       }
//       if (meta.wasPromotion) {
//         plySound.executePromoteSound();
//       }
//       if (meta.wasCheckmate) {
//         plySound.executeCheckmateSound();
//       } else if (meta.wasCheck) {
//         plySound.executeCheckSound();
//       }
//     } else {
//       // fallback
//       plySound.executeMoveSound();
//     }
//     gameStatus; // to update statusText
//   }

//   bool isPromotionPawnMove(NormalMove move) {
//     return move.promotion == null &&
//         gameState.position.board.roleAt(move.from) == Role.pawn &&
//         ((move.to.rank == Rank.first &&
//                 gameState.position.turn == Side.black) ||
//             (move.to.rank == Rank.eighth &&
//                 gameState.position.turn == Side.white));
//   }

//   // if can undo return true , if can redo return true
//   RxBool get canUndo =>
//       (!gameState.isGameOverExtended && gameState.canUndo).obs;
//   RxBool get canRedo =>
//       (!gameState.isGameOverExtended && gameState.canRedo).obs;

//   void undoMove() {
//     if (canUndo.value) {
//       gameState.undoMove();
//       fen = gameState.position.fen;
//       validMoves = makeLegalMoves(gameState.position);
//       // play a feedback sound (optional)
//       plySound.executeMoveSound();
//       update();
//     }
//   }

//   void redoMove() {
//     if (canRedo.value) {
//       gameState.redoMove();
//       fen = gameState.position.fen;
//       validMoves = makeLegalMoves(gameState.position);
//       plySound.executeMoveSound();
//       update();
//     }
//   }

//   /// expose PGN tokens for the UI
//   List<MoveDataModel> get pgnTokens => gameState.getMoveTokens;

//   int get currentHalfmoveIndex => gameState.currentHalfmoveIndex;

//   /// jump to a halfmove index (0-based). This will rebuild the game state up to that halfmove.
//   /// Implementation: get a copy of move objects from gameState, construct a fresh GameState
//   /// and replay moves up to `index` then replace controller.gameState with rebuilt one.
//   void jumpToHalfmove(int index) {
//     final allMoves = gameState.getMoveObjectsCopy();
//     final newState = GameState(initial: initail);
//     for (int i = 0; i <= index && i < allMoves.length; i++) {
//       newState.play(allMoves[i]);
//     }
//     gameState = newState;
//     fen = gameState.position.fen;
//     validMoves = makeLegalMoves(gameState.position);
//     update();
//   }

//   Map<Role, int> get whiteCaptured => gameState.getCapturedPieces(Side.white);
//   Map<Role, int> get blackCaptured => gameState.getCapturedPieces(Side.black);
//   String get whiteCapturedText => gameState.capturedPiecesAsString(Side.white);
//   String get whiteCapturedIcons =>
//       gameState.capturedPiecesAsUnicode(Side.white);
//   String get blackCapturedIcons =>
//       gameState.capturedPiecesAsUnicode(Side.black);

//   // في controller أو widget بعد استدعاء setState/update
//   List<Role> get whiteCapturedList =>
//       gameState.getCapturedPiecesList(Side.white); // قائمة الرول مكررة
//   List<Role> get blackCapturedList =>
//       gameState.getCapturedPiecesList(Side.black);

//   @override
//   void dispose() {
//     gameState.dispose();
//     super.dispose();
//   }
// }
