import 'package:chessground_game_app/core/global_feature/domain/entities/player_entity.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';

class PlayerGameInfoWidget extends StatelessWidget {
  final PlayerEntity? player;
  final bool isPlayerTurn;
  final List<Role> capturedPieces;
  final Side side;
  final bool isTop;

  const PlayerGameInfoWidget({
    super.key,
    required this.player,
    required this.isPlayerTurn,
    required this.capturedPieces,
    required this.side,
    this.isTop = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isTop ? Colors.grey[200] : Colors.grey[100],
        border: Border(
          bottom: isTop
              ? const BorderSide(color: Colors.grey)
              : BorderSide.none,
          top: !isTop ? const BorderSide(color: Colors.grey) : BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          // Player avatar
          CircleAvatar(
            backgroundColor: side == Side.white ? Colors.white : Colors.black,
            child: Text(
              side == Side.white ? 'W' : 'B',
              style: TextStyle(
                color: side == Side.white ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Player name and turn indicator
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      player?.name ?? 'Unknown',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isPlayerTurn
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    if (isPlayerTurn) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Turn',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  'Rating: ${player?.playerRating ?? 1200}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Captured pieces preview
          if (capturedPieces.isNotEmpty)
            Container(
              constraints: const BoxConstraints(maxWidth: 140),
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: -2,
                runSpacing: 0,
                children: capturedPieces.map((role) {
                  final pieceColor = side == Side.white
                      ? Side.black
                      : Side.white;
                  return Text(
                    _getPieceSymbol(role, pieceColor),
                    style: const TextStyle(fontSize: 22, height: 1),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  String _getPieceSymbol(Role role, Side color) {
    const whiteSymbols = {
      Role.pawn: '♙',
      Role.knight: '♘',
      Role.bishop: '♗',
      Role.rook: '♖',
      Role.queen: '♕',
      Role.king: '♔',
    };

    const blackSymbols = {
      Role.pawn: '♟',
      Role.knight: '♞',
      Role.bishop: '♝',
      Role.rook: '♜',
      Role.queen: '♛',
      Role.king: '♚',
    };

    final symbols = color == Side.white ? whiteSymbols : blackSymbols;
    return symbols[role] ?? '';
  }
}
