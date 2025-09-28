import 'package:isar/isar.dart';

part 'todo.g.dart';

@Collection()
class Todo {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  String? content;

  @enumerated
  Status status = Status.pending;

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  Todo copyWith({String? content, Status? status}) {
    return Todo()
      ..content = content ?? this.content
      ..status = status ?? this.status
      ..updatedAt = DateTime.now();
  }

  @override
  String toString() =>
      "Todo{id:$id, content:$content, status:$status, createdAt:$createdAt, updatedAt:$updatedAt }";
}

enum Status { completed, pending, inProgress }
