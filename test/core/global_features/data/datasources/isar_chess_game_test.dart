import 'package:chessground_game_app/core/game_termination_enum.dart';
import 'package:chessground_game_app/core/global_feature/data/collections/chess_game.dart';
import 'package:chessground_game_app/core/global_feature/data/collections/player.dart';
import 'package:chessground_game_app/core/global_feature/data/datasources/chess_game_local_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

void main() {
  late Isar isar;
  late ChessGameLocalDataSourceImpl
  dataService; // The service/repository under test

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    isar = await Isar.open([ChessGameSchema, PlayerSchema], directory: '');
  });

  setUp(() async {
    // Clear data before each test
    await isar.writeTxn(() async {
      await isar.clear();
    });
    dataService = ChessGameLocalDataSourceImpl(
      isar: isar,
    ); // Initialize your service
  });

  tearDownAll(() async {
    await isar.close();
  });

  test('should save and retrieve a record from Isar', () async {
    // Arrange
    final newRecord = ChessGame()
      ..event = 'Test Name'
      ..site = 'Test Site'
      ..date = DateTime.now()
      ..round = '1'
      ..whitePlayer.value = Player(
        uuid: '',
        name: '',
        type: '',
        playerRating: 0,
      )
      ..blackPlayer.value = Player(
        uuid: '',
        name: '',
        type: '',
        playerRating: 0,
      )
      ..result = '1-0'
      ..termination = GameTermination.ongoing
      ..eco = 'A00'
      ..whiteElo = 1500
      ..blackElo = 1450
      ..timeControl = '10+0'
      ..movesCount = 0
      ..moves = []
      ..uuid = 'test-uuid'
      ..date = DateTime.now();

    // Act
    await dataService.saveGame(
      newRecord.toModel(),
    ); // Assuming a method in your service

    // Assert
    final retrievedRecord = await isar.chessGames.where().findFirst();
    expect(retrievedRecord?.event, 'Test Name');
  });
}
