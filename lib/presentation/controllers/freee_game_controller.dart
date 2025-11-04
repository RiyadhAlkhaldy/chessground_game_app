import 'dart:async';

import 'package:chessground/chessground.dart';
import 'package:chessground_game_app/domain/collections/player.dart'
    as col_player;
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/dialog/game_result_dialog.dart';
import '../../core/utils/dialog/game_status.dart';
import '../../core/utils/dialog/status_l10n.dart';
import '../../data/game_state/game_state.dart';
import '../../data/usecases/play_sound_usecase.dart';
import '../../domain/collections/chess_game.dart';
import '../../domain/models/player_model.dart';
import '../../domain/services/chess_game_storage_service.dart';
import 'chess_board_settings_controller.dart';
import 'get_storage_controller.dart';

class FreeGameController extends GetxController {
  GameState gameState = GameState();

  Position get initail => Chess.fromSetup(Setup.parseFen(_initailLocalFen));
  String get _initailLocalFen => Chess.initial.fen;
  late String _fen;

  String get fen => _fen;
  set fen(String value) => _fen = value;

  ValidMoves validMoves = IMap(const {});

  bool get isCheckmate => gameState.isCheckmate;

  Side? get winner {
    return getResult?.winner;
  }

  final PlaySoundUseCase plySound;
  final ctrlBoardSettings = Get.find<ChessBoardSettingsController>();
  final storageGet = Get.find<GetStorageControllerImp>();

  Rx<PlayerModel> whitePlayer = PlayerModel(
    id: 1,
    uuid: 'White_Player',
    name: 'White Player',
    type: 'player',
    createdAt: DateTime.now(),
  ).obs;
  Rx<PlayerModel> blackPlayer = PlayerModel(
    id: 2,
    uuid: 'Black_Player',
    name: 'Black Player',
    type: 'player',
    createdAt: DateTime.now(),
  ).obs;

  // ===== storage & game record fields =====
  final ChessGameStorageService storage = ChessGameStorageService();
  ChessGame? currentGame; // يمثل سجل اللعبة في Isar
  col_player.Player? savedWhitePlayer;
  col_player.Player? savedBlackPlayer;

  FreeGameController(this.plySound);

  bool canPop = false;
  NormalMove? promotionMove;
  NormalMove? premove;
  PlayerSide playerSide = PlayerSide.both;

  Future<void> _initPlayer() async {
    // convert PlayerModel -> col_player.Player and persist using storage
    // Use supplied storage methods to create or get players
    // if createPlayerIfNotExists exists elsewhere you can reuse it; here we use storage directly

    // White player
    final whiteModel = whitePlayer.value;
    final whiteCollectionPlayer = col_player.Player(
      uuid: whiteModel.uuid,
      name: whiteModel.name,
      type: whiteModel.type,
      playerRating: whiteModel.playerRating ?? 1200,
    );
    savedWhitePlayer = await storage.createOrGetPlayerByUuid(
      whiteCollectionPlayer.uuid,
      name: whiteCollectionPlayer.name,
      rating: whiteCollectionPlayer.playerRating,
      type: whiteCollectionPlayer.type,
    );

    // Black player (for free play we create another local human)
    final blackModel = blackPlayer.value;
    final blackCollectionPlayer = col_player.Player(
      uuid: blackModel.uuid,
      name: blackModel.name,
      type: blackModel.type,
      playerRating: blackModel.playerRating ?? 1200,
    );
    savedBlackPlayer = await storage.createOrGetPlayerByUuid(
      blackCollectionPlayer.uuid,
      name: blackCollectionPlayer.name,
      rating: blackCollectionPlayer.playerRating,
      type: blackCollectionPlayer.type,
    );

    // Attempt to resume unfinished game for this owner (owner = savedWhitePlayer.uuid)
    await _resumeOrCreateGame(ownerUuid: savedWhitePlayer!.uuid);
  }

  @override
  void onInit() {
    super.onInit();
    // init storage DB - ensure it is initialized somewhere in app start; but call here if needed
    ChessGameStorageService.init(); // safe to call repeatedly (it guards against double init)
    _initPlayer().then((_) async {
      await plySound.executeDongSound();
    });

    gameState = GameState(initial: initail);
    fen = gameState.position.fen;
    validMoves = makeLegalMoves(gameState.position);
    _listenToGameStatus();
  }

  void _listenToGameStatus() {
    gameState.gameStatus.listen((status) async {
      if (gameState.turn == Side.white) {
        statusText.value = "دور الأبيض";
      } else if (gameState.turn == Side.black) {
        statusText.value = "دور الأسود";
      }
      if (gameState.isCheck) {
        statusText.value += '(كش)';
      }
      if (status != GameStatus.ongoing) {
        // قبل عرض النتيجة: خزّن النتيجة النهائية في DB
        await _finalizeGame(
          status,
          gameState,
          currentGame,
          storage,
          whitePlayer.value,
          blackPlayer.value,
        );
        statusText.value =
            "${gameStatusL10n(Get.context!, gameStatus: gameStatus, lastPosition: gameState.position, winner: gameState.result?.winner, isThreefoldRepetition: gameState.isThreefoldRepetition())} ";
        Get.dialog(
          GameResultDialog(
            gameState: gameState,
            gameStatus: status,
            reset: reset,
          ),
        );
      }
    });
  }

  Outcome? get getResult {
    return gameState.result;
  }

  RxString statusText = "free Play".obs;

  GameStatus get gameStatus => gameState.status();

  /// Agreement draw
  void setAgreementDraw() {
    gameState.setAgreementDraw();
    update();
  }

  /// Resign
  void resign(Side side) {
    gameState.resign(side);
    plySound.executeResignSound();
    update();
  }

  /// reset
  void reset() {
    gameState = GameState(initial: initail);
    fen = gameState.position.fen;
    validMoves = makeLegalMoves(gameState.position);
    promotionMove = null;
    debugPrint('reset to $fen');
    plySound.executeDongSound();
    statusText.value = "free Play";

    // when resetting we also start a new DB game record
    if (savedWhitePlayer != null && savedBlackPlayer != null) {
      _resumeOrCreateGame(ownerUuid: savedWhitePlayer!.uuid);
    }

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
      return;
    } else if (gameState.position.isLegal(move)) {
      _applyMove(move);
      promotionMove = null;
      debugPrint("gameState.position.fen: ${gameState.position.fen}");
      update();
    }
    tryPlayPremove();
  }

  /// تطبيق النقلة وتحديث state و حفظ الحركة في DB
  void _applyMove(NormalMove move) {
    // play move in GameState
    gameState.play(move);

    // update fen & moves in UI
    fen = gameState.position.fen;
    validMoves = makeLegalMoves(gameState.position);

    // play sounds based on meta
    final meta = gameState.lastMoveMeta;
    if (meta != null) {
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
      plySound.executeMoveSound();
    }

    // BUILD MoveData from last applied move and store to DB
    try {
      final moveData = _buildMoveDataFromLastMove(gameState);
      if (moveData != null && currentGame != null) {
        // addMoveToGame is async — call but do not block UI (still await to handle failures optionally)
        storage.addMoveToGame(currentGame!.id, moveData).catchError((e) {
          debugPrint('Error saving move to DB: $e');
        });
      }
    } catch (e) {
      debugPrint('Error building/saving move data: $e');
    }

    // update status text (gameState.gameStatus stream will handle finalization)
    gameStatus;
  }

  bool isPromotionPawnMove(NormalMove move) {
    return move.promotion == null &&
        gameState.position.board.roleAt(move.from) == Role.pawn &&
        ((move.to.rank == Rank.first &&
                gameState.position.turn == Side.black) ||
            (move.to.rank == Rank.eighth &&
                gameState.position.turn == Side.white));
  }

  RxBool get canUndo =>
      (!gameState.isGameOverExtended && gameState.canUndo).obs;
  RxBool get canRedo =>
      (!gameState.isGameOverExtended && gameState.canRedo).obs;

  void undoMove() {
    if (canUndo.value) {
      gameState.undoMove();
      fen = gameState.position.fen;
      validMoves = makeLegalMoves(gameState.position);
      plySound.executeMoveSound();
      update();
    }
  }

  void redoMove() {
    if (canRedo.value) {
      gameState.redoMove();
      fen = gameState.position.fen;
      validMoves = makeLegalMoves(gameState.position);
      plySound.executeMoveSound();
      update();
    }
  }

  List<MoveData> get pgnTokens => gameState.getMoveTokens;
  int get currentHalfmoveIndex => gameState.currentHalfmoveIndex;

  void jumpToHalfmove(int index) {
    final allMoves = gameState.getMoveObjectsCopy();
    final newState = GameState(initial: initail);
    for (int i = 0; i <= index && i < allMoves.length; i++) {
      newState.play(allMoves[i]);
    }
    gameState = newState;
    fen = gameState.position.fen;
    validMoves = makeLegalMoves(gameState.position);
    update();
  }

  Map<Role, int> get whiteCaptured => gameState.getCapturedPieces(Side.white);
  Map<Role, int> get blackCaptured => gameState.getCapturedPieces(Side.black);
  String get whiteCapturedText => gameState.capturedPiecesAsString(Side.white);
  String get whiteCapturedIcons =>
      gameState.capturedPiecesAsUnicode(Side.white);
  String get blackCapturedIcons =>
      gameState.capturedPiecesAsUnicode(Side.black);

  List<Role> get whiteCapturedList =>
      gameState.getCapturedPiecesList(Side.white);
  List<Role> get blackCapturedList =>
      gameState.getCapturedPiecesList(Side.black);

  /// محاولة استئناف لعبة غير مكتملة أو إنشاء لعبة جديدة
  Future<void> _resumeOrCreateGame({required String ownerUuid}) async {
    try {
      // get all games for owner and find first unfinished (result == null or '*' or "")
      final games = await storage.getGamesByPlayer(ownerUuid);
      ChessGame? unfinished;
      for (final g in games) {
        if (g.result == null ||
            g.result == '*' ||
            (g.moves.isNotEmpty && g.termination != GameTermination.ongoing)) {
          unfinished = g;
          break;
        }
      }

      if (unfinished != null) {
        currentGame = unfinished;
        // load players (ensure loaded)
        await currentGame!.whitePlayer.load();
        await currentGame!.blackPlayer.load();
        debugPrint(
          'Resumed game id=${currentGame!.id} with ${currentGame!.movesCount} moves',
        );
      } else {
        // create new game record
        final chessGame = ChessGame();
        final headers = <String, String>{
          'Event': 'Free Play',
          'Site': 'Local',
          'Date': DateTime.now().toIso8601String().split('T').first,
          'White': savedWhitePlayer?.name ?? 'White',
          'Black': savedBlackPlayer?.name ?? 'Black',
          'Result': '*',
        };

        final created = await storage.startNewGame(
          chessGame: chessGame,
          startFEN: initail.fen,
          white: savedWhitePlayer!,
          black: savedBlackPlayer!,
          headers: headers,
          event: 'Free Play',
          site: 'Local',
          round: '1',
          date: DateTime.now(),
        );

        currentGame = created;
        debugPrint('Created new game id=${currentGame!.id}');
      }
    } catch (e) {
      debugPrint('Error resuming/creating game: $e');
    }
  }

  /// save snapshot on close
  @override
  void onClose() {
    super.onClose();
    saveSnapshotOnClose(
      currentGame,
      storage,
      gameState,
      whitePlayer.value,
      blackPlayer.value,
    ).catchError((e) {
      debugPrint('Error saving snapshot on close: $e');
    });
    try {
      gameState.dispose();
    } catch (_) {}
  }
}

Future<void> saveSnapshotOnClose(
  ChessGame? currentGame,
  ChessGameStorageService storage,
  GameState gameState,
  PlayerModel? savedWhitePlayer,
  PlayerModel? savedBlackPlayer,
) async {
  if (currentGame == null) return;
  if (currentGame.termination == GameTermination.ongoing) return;
  try {
    // update currentGame fields from current memory state
    currentGame.moves = gameState.getMoveTokens; // may need conversion
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

MoveData? _buildMoveDataFromLastMove(GameState gameState) {
  // gameState should have last move tokens or last move object
  // get last move SAN / LAN and meta
  final tokens =
      gameState.getMoveTokens; // List<MoveData> from dartchess? or similar
  if (tokens.isEmpty) return null;

  // get the last MoveData token the GameState provides (this may differ in shape)
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
    final md = MoveData()
      ..san = lastToken.san
      ..lan =
          lastToken.lan ??
          '' // lan may be null
      ..fenAfter = gameState.position.fen
      ..comment = lastToken.comment
      ..nags = lastToken.nags
      ..variations = lastToken.variations
      ..wasCapture = lastToken.wasCapture ?? false
      ..wasCheck = lastToken.wasCheck ?? false
      ..wasCheckmate = lastToken.wasCheckmate ?? false
      ..wasPromotion = lastToken.wasPromotion ?? false
      ..isWhiteMove = lastToken.isWhiteMove
      ..halfmoveIndex = halfmoveIndex
      ..moveNumber = lastToken.moveNumber;
    return md;
  } else {
    // convert NormalMove object at allMoves[halfmoveIndex] to MoveData
    final normalMove = allMoves[halfmoveIndex];
    // get SAN token corresponding to this normalMove if possible
    final sanToken = tokens.length > halfmoveIndex
        ? tokens[halfmoveIndex]
        : null;

    final md = MoveData()
      ..san = sanToken?.san ?? normalMove.toString()
      ..lan = _normalMoveToLan(Move.parse(normalMove.san!) as NormalMove)
      ..fenAfter = gameState.position.fen
      ..comment = sanToken?.comment
      ..nags = sanToken?.nags
      ..variations = sanToken?.variations
      ..wasCapture = normalMove.wasCapture
      ..wasCheck = gameState.position.isCheck
      ..wasCheckmate = gameState.isCheckmate
      ..wasPromotion = normalMove.wasPromotion
      ..isWhiteMove = normalMove.isWhiteMove
      ..halfmoveIndex = halfmoveIndex
      ..moveNumber = (halfmoveIndex ~/ 2) + 1;
    return md;
  }
}

String _normalMoveToLan(NormalMove move) {
  // convert from/to squares to lan like 'e2e4' and include promotion if any
  String sq(int file, int rank) => '${"abcdefgh"[file]}${rank + 1}';
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
Future<void> _finalizeGame(
  GameStatus status,
  GameState gameState,
  ChessGame? currentGame,
  ChessGameStorageService storage,
  PlayerModel savedWhitePlayer,
  PlayerModel savedBlackPlayer,
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
      if (win == Side.white)
        resultText = '1-0';
      else if (win == Side.black)
        resultText = '0-1';
      else {
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
    'White':
        currentGame.whitePlayer.value?.name ?? savedWhitePlayer.name ?? 'White',
    'Black':
        currentGame.blackPlayer.value?.name ?? savedBlackPlayer.name ?? 'Black',
    'Result': resultText,
  };

  try {
    // harvest movesData from currentGame.moves (already stored as MoveData)
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

//   Rx<PlayerModel> whitePlayer = PlayerModel(
//     id: 1,
//     uuid: 'White_Player',
//     name: 'White Player',
//     type: 'player',
//     createdAt: DateTime.now(),
//   ).obs;
//   Rx<PlayerModel> blackPlayer = PlayerModel(
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
//   List<MoveData> get pgnTokens => gameState.getMoveTokens;

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
