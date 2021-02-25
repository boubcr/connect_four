import 'package:game_manager/ai/ai.dart';
import 'package:game_manager/game_manager.dart';
import 'package:game_manager/models/models.dart';

/// Strategy based on the evaluation function
/// Find the best move in the current board
class EvaluationStrategy extends Strategy {
  @override
  Future<BestScore> think(GameManager manager) async {
    //BestScore score1 = normalThinking(manager);
    //print('Best move ${score1.bestMove.id}');

    BestScore score2 = optimalThinking(manager);
    print('Best move ${score2.move.id}');

    return score2;
  }

  BestScore optimalThinking(GameManager manager) {
    DateTime start = DateTime.now();
    //print('OptimalThinking start');
    List<Dot> availableDots = manager.board.availableDots;
    if (availableDots.isEmpty) return null;

    Move bestMove;
    double bestValue = double.negativeInfinity;
    availableDots.forEach((dot) {
      Move move = Move(dot: dot);
      GameManager newManager = manager.play(move);
      /// Get the opposite of the current board value (because players are switched in PLAY)
      double boardValue = - newManager.evaluate();
      if (boardValue > bestValue) {
        bestValue = boardValue;
        bestMove = move;
      }
    });

    //print('OptimalThinking end: ${Utils.getDuration(start)}');
    return BestScore(value: bestValue, move: bestMove);
  }

  BestScore normalThinking(GameManager manager) {
    DateTime start = DateTime.now();
    print('NormalThinking start');
    List<Dot> availableDots = manager.board.availableDots;
    if (availableDots.isEmpty) return null;

    Move bestMove;
    double bestValue = double.negativeInfinity;
    availableDots.forEach((dot) {
      Move move = Move(dot: dot);
      GameManager newManager = manager.play(move);
      /// Get the opposite of the current board value (because players are switched in PLAY)
      double boardValue = - newManager.evaluate();
      if (boardValue > bestValue) {
        bestValue = boardValue;
        bestMove = move;
      }
    });

    print('NormalThinking end: ${Utils.getDuration(start)}');
    return BestScore(value: bestValue, move: bestMove);
  }
}
