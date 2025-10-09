// // lib/models/pgn_model.dart

// import 'package:freezed_annotation/freezed_annotation.dart';

// import 'pgn_parser.dart';

// part 'pgn_model.freezed.dart';
// part 'pgn_model.g.dart';

// /// تمثيل جهة الحركة (side) في الشطرنج.
// @JsonEnum(alwaysCreate: true)
// enum Side { white, black }

// /// النموذج الأعلى للعبة PGN.
// @freezed
// class PgnGame with _$PgnGame {
//   /// يمثل لعبة واحدة من PGN
//   @JsonSerializable(explicitToJson: true)
//   factory PgnGame({
//     @Default(<String, String>{}) Map<String, String> headers,
//     @Default(<PgnNode>[]) List<PgnNode> nodes,
//     String? result,
//     @Default('') String raw,
//   }) = _PgnGame;

//   factory PgnGame.fromJson(Map<String, dynamic> json) =>
//       _$PgnGameFromJson(json);

//   /// Factory convenience: parses a PGN string into a PgnGame using the parser.
//   /// (يتطلب وجود lib/parsers/pgn_parser.dart)
//   factory PgnGame.fromPgn(String pgnText) => PgnParser.parseOne(pgnText);

//   /// Parses many games from a multi-PGN string.
//   static List<PgnGame> parseMany(String multiPgnText) =>
//       PgnParser.parseMany(multiPgnText);
// }

// /// عقدة في شجرة تمثيل نص الحركات (AST-like).
// @freezed
// class PgnNode with _$PgnNode {
//   /// تمثيل وسم Header (نادر الاستخدام داخل الـnodes لكنه موجود كتوافق مع المتطلبات).
//   const factory PgnNode.headerTag({
//     required String name,
//     required String value,
//   }) = HeaderTag;

//   /// رقم الحركة (مثال: `12.` أو `12...` يُخزن رقم 12 ويشير isBlack=true إن كانت `...`).
//   const factory PgnNode.moveNumber({
//     required int number,
//     @Default(false) bool isBlack,
//   }) = MoveNumberNode;

//   /// حركة فعلية مع كل البيانات المتعلقة بها.
//   const factory PgnNode.move({required PgnMove move}) = MoveNode;

//   /// تعليق نصي.
//   const factory PgnNode.comment({required String text}) = CommentNode;

//   /// بديل (Variation) يحتوي على قائمة عقد (قابلة للتعشيش).
// }
// //////
// ///
// ///

// enum _TokenType { lparen, rparen, comment, nag, moveNumber, san, result, eof }

// class _Token {
//   final _TokenType type;
//   final String text;

//   _Token(this.type, this.text);

//   @override
//   String toString() => '_Token($type, "$text")';
// }

// class PgnParser {
//   /// Parses many games from a multi-PGN string.
//   static List<PgnGame> parseMany(String multiPgnText) {
//     final normalized = multiPgnText.replaceAll('\r\n', '\n').trim();
//     if (normalized.isEmpty) return [];

//     final games = <PgnGame>[];
//     int offset = 0;
//     final lines = normalized.split('\n');
//     final totalLines = lines.length;

//     while (offset < totalLines) {
//       // Collect header block
//       final headerLines = <String>[];
//       while (offset < totalLines && lines[offset].trim().startsWith('[')) {
//         headerLines.add(lines[offset]);
//         offset++;
//       }

//       // Skip blank lines
//       while (offset < totalLines && lines[offset].trim().isEmpty) offset++;

//       // Collect movetext until we reach an empty line followed by a header or EOF
//       final moveLines = <String>[];
//       while (offset < totalLines && !lines[offset].trim().startsWith('[')) {
//         // stop if we reach two consecutive empty lines (safety)
//         moveLines.add(lines[offset]);
//         offset++;
//       }

//       final gameTextBuffer = <String>[];
//       if (headerLines.isNotEmpty) gameTextBuffer.addAll(headerLines);
//       if (moveLines.isNotEmpty) gameTextBuffer.addAll(['', ...moveLines]);

//       final gameText = gameTextBuffer.join('\n').trim();
//       if (gameText.isNotEmpty) {
//         games.add(parseOne(gameText));
//       }

//       // continue to next potential game
//     }

//     return games;
//   }

//   /// Parse a single PGN game string into a PgnGame. Throws FormatException on fatal errors.
//   static PgnGame parseOne(String pgnText) {
//     final raw = pgnText;

//     // Normalize newlines
//     final text = pgnText.replaceAll('\r\n', '\n');
//     final lines = text.split('\n');

//     // Parse headers
//     final headers = <String, String>{};
//     int idx = 0;
//     while (idx < lines.length) {
//       final line = lines[idx].trim();
//       if (line.isEmpty) {
//         idx++;
//         continue;
//       }
//       if (line.startsWith('[')) {
//         final match = RegExp(
//           r'^\s*\[([^\s]+)\s+"([\s\S]*?)"\]\s*\$',
//         ).firstMatch(line);
//         if (match != null) {
//           final name = match.group(1)!.trim();
//           final value = match.group(2)!.trim();
//           headers[name] = value;
//           idx++;
//           continue;
//         } else {
//           // not a header line -> stop header parsing
//           break;
//         }
//       } else {
//         break;
//       }
//     }

//     // The rest is move text
//     final moveTextLines = lines.sublist(idx);
//     final moveText = moveTextLines.join(' ').trim();

//     final tokens = _tokenizeMoveText(moveText);

//     int t = 0;
//     List<PgnNode> parseNodes([bool stopOnRparen = false]) {
//       final nodes = <PgnNode>[];
//       String? pendingCommentBefore;

//       Side nextSide = Side.white;
//       int? currentMoveNumber;

//       while (t < tokens.length) {
//         final token = tokens[t];

//         if (token.type == _TokenType.eof) break;

//         if (token.type == _TokenType.lparen) {
//           // Start variation
//           t++; // consume '('
//           final savedT = t;
//           final variationNodes = parseNodes(true);
//           // expect a closing )
//           if (t < tokens.length && tokens[t].type == _TokenType.rparen) {
//             t++; // consume ')'
//           }
//           nodes.add(PgnNode.variation(nodes: variationNodes));
//           continue;
//         }

//         if (token.type == _TokenType.rparen) {
//           if (stopOnRparen)
//             return nodes; // do not consume here - caller will consume
//           // stray rparen -> skip
//           t++;
//           continue;
//         }

//         if (token.type == _TokenType.comment) {
//           final commentText = token.text;
//           // peek next
//           final nextToken = (t + 1 < tokens.length) ? tokens[t + 1] : null;
//           if (nextToken != null && nextToken.type == _TokenType.san) {
//             // attach as pendingCommentBefore
//             pendingCommentBefore =
//                 (pendingCommentBefore == null)
//                     ? commentText
//                     : '$pendingCommentBefore\n$commentText';
//             t++;
//             continue;
//           } else {
//             // Attach to previous move as commentAfter if possible
//             if (nodes.isNotEmpty) {
//               final last = nodes.last;
//               final prevMove = last.maybeMap(
//                 move: (m) => m.move,
//                 orElse: () => null,
//               );
//               if (prevMove != null) {
//                 final updated = prevMove.copyWith(
//                   commentAfter:
//                       prevMove.commentAfter == null
//                           ? commentText
//                           : '${prevMove.commentAfter}\n$commentText',
//                 );
//                 nodes[nodes.length - 1] = PgnNode.move(move: updated);
//                 t++;
//                 continue;
//               }
//             }
//             // Standalone comment node
//             nodes.add(PgnNode.comment(text: commentText));
//             t++;
//             continue;
//           }
//         }

//         if (token.type == _TokenType.moveNumber) {
//           // token.text example: "12." or "12..."
//           final text = token.text;
//           final match = RegExp(r'^(\d+)(\.{1,3})\$').firstMatch(text);
//           if (match != null) {
//             final num = int.parse(match.group(1)!);
//             final dots = match.group(2)!;
//             final isBlack = dots.length >= 3;
//             currentMoveNumber = num;
//             nodes.add(PgnNode.moveNumber(number: num, isBlack: isBlack));
//             // set the next side according to whether dots indicated black
//             nextSide = isBlack ? Side.black : Side.white;
//           } else {
//             // fallback: try parse number only
//             final nnum = int.tryParse(text.replaceAll('.', ''));
//             if (nnum != null) {
//               currentMoveNumber = nnum;
//               nodes.add(PgnNode.moveNumber(number: nnum, isBlack: false));
//               nextSide = Side.white;
//             }
//           }
//           t++;
//           continue;
//         }

//         if (token.type == _TokenType.nag) {
//           // NAG appearing before a move -> attach to pendingCommentBefore? Usually NAG follows SAN.
//           // We'll attach it to next SAN move by creating a fake pending NAG list in nodes as metadata.
//           // For simplicity, turn this into a standalone comment node like "$n" so it's preserved.
//           nodes.add(PgnNode.comment(text: token.text));
//           t++;
//           continue;
//         }

//         if (token.type == _TokenType.result) {
//           // set result and stop parsing
//           nodes.add(PgnNode.comment(text: token.text));
//           t++;
//           continue;
//         }

//         if (token.type == _TokenType.san) {
//           // Create a move
//           final san = token.text;
//           final pm = PgnMove(
//             moveNumber: currentMoveNumber,
//             side: nextSide,
//             san: san,
//             nags: <int>[],
//             commentBefore: pendingCommentBefore,
//             commentAfter: null,
//             variations: <PgnNode>[],
//           );
//           pendingCommentBefore = null;
//           t++; // consume san

//           // Attach following NAGs, comments, or variations directly to this move
//           while (t < tokens.length) {
//             final look = tokens[t];
//             if (look.type == _TokenType.nag) {
//               final num = int.tryParse(look.text.replaceAll(r'\$', ''));
//               if (num != null) {
//                 pm.nags.add(num);
//               }
//               t++;
//               continue;
//             }
//             if (look.type == _TokenType.comment) {
//               final c = look.text;
//               pm.commentAfter =
//                   pm.commentAfter == null ? c : '${pm.commentAfter}\n$c';
//               t++;
//               continue;
//             }
//             if (look.type == _TokenType.lparen) {
//               // Parse variation attached to this move
//               t++; // consume '('
//               final inner = parseNodes(true);
//               // expect ')'
//               if (t < tokens.length && tokens[t].type == _TokenType.rparen) {
//                 t++; // consume ')'
//               }
//               pm.variations.add(PgnNode.variation(nodes: inner));
//               continue;
//             }
//             break;
//           }

//           // append the move node
//           nodes.add(PgnNode.move(move: pm));

//           // toggle side and adjust move number when we finished a black move
//           if (pm.side == Side.white) {
//             nextSide = Side.black;
//           } else {
//             nextSide = Side.white;
//             if (pm.moveNumber != null) {
//               currentMoveNumber = (pm.moveNumber! + 1);
//             }
//           }

//           continue;
//         }

//         // Safety fallback: skip token
//         t++;
//       }

//       return nodes;
//     }

//     // Start parsing nodes from token stream
//     t = 0;
//     final nodes = parseNodes(false);

//     // Extract result if exists in trailing comment nodes (e.g., a node.comment with text "1-0")
//     String? result;
//     if (nodes.isNotEmpty) {
//       final last = nodes.last;
//       last.maybeWhen(
//         comment: (text) {
//           final trimmed = text.trim();
//           if (trimmed == '1-0' ||
//               trimmed == '0-1' ||
//               trimmed == '1/2-1/2' ||
//               trimmed == '*') {
//             result = trimmed;
//           }
//         },
//         orElse: () {},
//       );
//     }

//     return PgnGame(headers: headers, nodes: nodes, result: result, raw: raw);
//   }
// }

// // Tokenizer implementation
// List<_Token> _tokenizeMoveText(String s) {
//   final tokens = <_Token>[];
//   int i = 0;
//   final len = s.length;

//   bool isWhitespace(String ch) => RegExp(r'\s').hasMatch(ch);

//   while (i < len) {
//     final ch = s[i];
//     if (isWhitespace(ch)) {
//       i++;
//       continue;
//     }

//     if (ch == '{') {
//       final end = s.indexOf('}', i + 1);
//       final content =
//           (end == -1)
//               ? s.substring(i + 1).trim()
//               : s.substring(i + 1, end).trim();
//       tokens.add(_Token(_TokenType.comment, content));
//       if (end == -1) {
//         i = len;
//       } else {
//         i = end + 1;
//       }
//       continue;
//     }

//     if (ch == ';') {
//       // rest of line comment
//       final nl = s.indexOf('\n', i + 1);
//       final content =
//           (nl == -1)
//               ? s.substring(i + 1).trim()
//               : s.substring(i + 1, nl).trim();
//       tokens.add(_Token(_TokenType.comment, content));
//       if (nl == -1) {
//         i = len;
//       } else {
//         i = nl + 1;
//       }
//       continue;
//     }

//     if (ch == '(') {
//       tokens.add(_Token(_TokenType.lparen, '('));
//       i++;
//       continue;
//     }
//     if (ch == ')') {
//       tokens.add(_Token(_TokenType.rparen, ')'));
//       i++;
//       continue;
//     }

//     if (ch == r'$') {
//       // NAG
//       int j = i + 1;
//       while (j < len && RegExp(r'\d').hasMatch(s[j])) j++;
//       final txt = s.substring(i, j);
//       tokens.add(_Token(_TokenType.nag, txt));
//       i = j;
//       continue;
//     }

//     // read a word (until whitespace or parentheses or braces or semicolon)
//     int j = i;
//     while (j < len && !RegExp(r'[\s\(\)\{\};]').hasMatch(s[j])) j++;
//     final word = s.substring(i, j);

//     // Classify word
//     final resultRegex = RegExp(r'^(1-0|0-1|1/2-1/2|\*)\$');
//     final moveNumberRegex = RegExp(r'^(\d+)(\.{1,3})\$');

//     if (resultRegex.hasMatch(word)) {
//       tokens.add(_Token(_TokenType.result, word));
//     } else if (moveNumberRegex.hasMatch(word)) {
//       tokens.add(_Token(_TokenType.moveNumber, word));
//     } else {
//       // treat everything else as SAN (moves like e4, Nf3, O-O, etc.)
//       tokens.add(_Token(_TokenType.san, word));
//     }

//     i = j;
//   }

//   tokens.add(_Token(_TokenType.eof, ''));
//   return tokens;
// }

// /// تحويل نموذج PGN إلى نص PGN صالح للنسخ / العرض.
// String toPgn(PgnGame game) {
//   final sb = StringBuffer();

//   // headers
//   game.headers.forEach((k, v) {
//     sb.writeln('[\$k "\$v"]'.replaceAll(r'\$k', k).replaceAll(r'\$v', v));
//   });
//   if (game.headers.isNotEmpty) sb.writeln();

//   // nodes -> movetext
//   String serializeNodes(List<PgnNode> nodes) {
//     final buf = StringBuffer();
//     for (final node in nodes) {
//       node.map(
//         headerTag: (h) => buf.write('[${h.name} "${h.value}"] '),
//         moveNumber:
//             (mn) =>
//                 buf.write(mn.isBlack ? '${mn.number}... ' : '${mn.number}. '),
//         move: (mnode) {
//           final m = mnode.move;
//           if (m.commentBefore != null) buf.write('{${m.commentBefore}} ');
//           buf.write(m.san);
//           for (final nag in m.nags)
//             buf.write(' \$\$$nag'.replaceAll(r'\$\$', r'\$'));
//           if (m.commentAfter != null) buf.write(' {${m.commentAfter}}');
//           for (final v in m.variations) {
//             buf.write(' (');
//             buf.write(serializeNodes(v.nodes));
//             buf.write(')');
//           }
//           buf.write(' ');
//         },
//         comment: (c) => buf.write('{${c.text}} '),
//         variation: (v) {
//           buf.write('(');
//           buf.write(serializeNodes(v.nodes));
//           buf.write(') ');
//         },
//       );
//     }
//     return buf.toString().trim();
//   }

//   final movetext = serializeNodes(game.nodes);
//   sb.write(movetext);

//   if (game.result != null && game.result!.isNotEmpty) {
//     if (movetext.isNotEmpty) sb.write(' ');
//     sb.write(game.result);
//   }

//   return sb.toString().trim();
// }

// /// Pretty formatting: add line breaks every `movesPerLine` full-moves (white+black)
// String prettyPgn(PgnGame game, {int movesPerLine = 6}) {
//   final nodes = game.nodes;
//   final buffer = StringBuffer();

//   // We'll use serialize but insert line breaks for readability.
//   int fullMoveCount = 0;
//   for (int i = 0; i < nodes.length; i++) {
//     final node = nodes[i];
//     if (node is MoveNumberNode) {
//       buffer.write(node.isBlack ? '${node.number}... ' : '${node.number}. ');
//     } else if (node is MoveNode) {
//       final m = node.move;
//       if (m.commentBefore != null) buffer.write('{${m.commentBefore}} ');
//       buffer.write('${m.san}');
//       for (final nag in m.nags) buffer.write(' \$$nag');
//       if (m.commentAfter != null) buffer.write(' {${m.commentAfter}}');
//       for (final v in m.variations) {
//         buffer.write(' (');
//         buffer.write(toPgn(PgnGame(headers: {}, nodes: v.nodes, raw: '')));
//         buffer.write(')');
//       }
//       buffer.write(' ');

//       if (m.side == Side.black) {
//         fullMoveCount++;
//         if (fullMoveCount % movesPerLine == 0) buffer.write('\n');
//       }
//     } else if (node is CommentNode) {
//       buffer.write('{${node.text}} ');
//     } else if (node is VariationNode) {
//       buffer.write('(');
//       buffer.write(toPgn(PgnGame(headers: {}, nodes: node.nodes, raw: '')));
//       buffer.write(') ');
//     }
//   }

//   if (game.result != null && game.result!.isNotEmpty) {
//     buffer.write(game.result);
//   }

//   return buffer.toString().trim();
// }

// /// Returns a flat list of SAN moves from the mainline (ignores variations by default).
// List<String> toFlatSanList(PgnGame game, {bool includeVariations = false}) {
//   final list = <String>[];

//   void walk(List<PgnNode> nodes) {
//     for (final node in nodes) {
//       node.map(
//         headerTag: (_) => null,
//         moveNumber: (_) => null,
//         move: (mnode) => list.add(mnode.move.san),
//         comment: (_) => null,
//         variation: (v) {
//           if (includeVariations) walk(v.nodes);
//         },
//       );
//     }
//   }

//   walk(game.nodes);
//   return list;
// }

// /// Fast clipboard helper
// String toRawForClipboard(PgnGame game) =>
//     (game.raw.trim().isNotEmpty) ? game.raw : toPgn(game);

// /// Simple adapter: build a PgnGame from a list of SAN strings (mainline only)
// PgnGame fromSanList(List<String> sanMoves, {Map<String, String>? headers}) {
//   final nodes = <PgnNode>[];
//   int moveNumber = 1;
//   for (int i = 0; i < sanMoves.length; i++) {
//     if (i % 2 == 0) {
//       // white move -> add moveNumber then move
//       nodes.add(PgnNode.moveNumber(number: moveNumber, isBlack: false));
//       nodes.add(
//         PgnNode.move(
//           move: PgnMove(
//             moveNumber: moveNumber,
//             side: Side.white,
//             san: sanMoves[i],
//           ),
//         ),
//       );
//     } else {
//       nodes.add(
//         PgnNode.move(
//           move: PgnMove(
//             moveNumber: moveNumber,
//             side: Side.black,
//             san: sanMoves[i],
//           ),
//         ),
//       );
//       moveNumber++;
//     }
//   }

//   return PgnGame(headers: headers ?? {}, nodes: nodes, raw: '');
// }
