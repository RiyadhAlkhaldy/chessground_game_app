import 'package:chessground_game_app/data/collections/todo.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class TodoService {
  static late final Isar db;
  static Future<void> setup() async {
    final appDir = await getApplicationDocumentsDirectory();
    db = await Isar.open([TodoSchema], directory: appDir.path);
  }

  static Future<void> adds() async {
    Todo todo;
    for (int i = 0; i < 5; i++) {
      await Future.delayed(Duration(seconds: 3));
      debugPrint("i+i======== add");
      todo = Todo()..content = "i+i========";

      await db.writeTxn(() async => await db.todos.put(todo));
    }
  }

  static void gets() async {
    db.todos.buildQuery<Todo>().watch().listen(
      (event) => event.map((element) => debugPrint(element.toString())),
    );
  }
}
