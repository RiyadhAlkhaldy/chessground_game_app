// lib/engine/tt.dart
import 'package:dartchess/dartchess.dart';

enum Bound { exact, lower, upper }

class TTEntry {
  final BigInt key;
  final int depth;
  final int score; // بالسنـتي بون
  final Bound bound;
  final Move? best;
  final int age;
  TTEntry(this.key, this.depth, this.score, this.bound, this.best, this.age);
}

class TranspositionTable {
  final int size; // buckets
  final List<TTEntry?> table;
  int age = 0;
  TranspositionTable([this.size = 1 << 20])
    : table = List.filled(1 << 20, null);

  void newSearch() => age++;

  TTEntry? probe(BigInt key) {
    final idx = (key.toUnsigned(64).toInt()) & (size - 1);
    final e = table[idx];
    return (e != null && e.key == key) ? e : null;
  }

  void store(BigInt key, int depth, int score, Bound b, Move? best) {
    final idx = (key.toUnsigned(64).toInt()) & (size - 1);
    final cur = table[idx];
    if (cur == null || depth >= cur.depth || cur.age != age) {
      table[idx] = TTEntry(key, depth, score, b, best, age);
    }
  }
}
