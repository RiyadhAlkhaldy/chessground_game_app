// // (توضيح بالعربية): هذه واجهة مجردة (عقد) تحدد وظائف الذكاء الاصطناعي.
// // This abstract class defines the contract for our AI data source.
// // The domain layer only knows about this interface, not the concrete implementation.
// abstract class AIRepository {
//   /// Finds the best move for a given FEN string at a specific skill level.
//   /// Skill level should be an integer (e.g., 1-10) that the implementation
//   /// will translate into engine parameters like depth or thinking time.
//   /// Returns the best move in UCI format (e.g., "e2e4").
//   Future<String> findBestMove(String fen, int skillLevel);
// }
