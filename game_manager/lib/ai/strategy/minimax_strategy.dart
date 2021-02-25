import 'dart:math';
import 'package:game_manager/ai/ai.dart';
import 'package:game_manager/game_manager.dart';
import 'package:game_manager/logger.dart';
import 'package:game_manager/models/models.dart';
import 'package:logging/logging.dart';

/// Implement the MiniMax strategy
/// MiniMax with depth=1 is the Evaluation strategy
class MiniMaxStrategy extends Strategy {
  static final _log = Logger('MiniMaxStrategy');

  //static final double FACTOR = 3;

  final depth;
  final showBoard;
  Player player;
  MiniMaxStrategy({this.depth = 1, this.showBoard = false}) : super();

  @override
  Future<BestScore> think(GameManager manager) async {
    player = manager.current;
    _log.info('Thinking start: Player ${player.name}');
    DateTime start = DateTime.now();
    BestScore bestScore = miniMax(depth, manager, true);
    _log.info('Thinking end: ${Utils.getDuration(start)}');
    _log.info('Thinking result: $bestScore');
    return bestScore;
  }

  /*
  BestScore miniMaxRoot(int depth, GameManager manager, bool isMaximisingPlayer) {
    DateTime start = DateTime.now();
    print('depth => $depth');
    List<Dot> availableDots = manager.board.availableDots;
    double bestValue = double.negativeInfinity;
    Move bestMoveFound;

    availableDots.forEach((dot) {
      Move newMove = Move(dot: dot);
      GameManager newManager = manager.play(newMove);
      double value = miniMax(depth - 1, newManager, !isMaximisingPlayer);
      if (value >= bestValue) {
        bestValue = value;
        bestMoveFound = newMove;
      }
    });

    print('==> MiniMax depth:$depth, ${Utils.getDuration(start)}, BestMove: ${bestMoveFound.id}');
    return BestScore(bestMove: bestMoveFound, bestValue: bestValue);
  }*/

  BestScore miniMax(int depth, GameManager manager, bool isMaximisingPlayer) {
    List<Dot> availableDots = manager.board.availableDots;
    if (depth == 0 || availableDots.length == 0) {
      Move move = manager.lastPlayedMove;
      double value = manager.normalEvaluation(player);
      BestScore bestScore = BestScore(value: value, move: move);
      //print('Played moves ${manager.moveIds}');
      //print('MiniMax Evaluation $bestScore');
      return bestScore;
    }

    if (isMaximisingPlayer) {
      BestScore bestScore = BestScore(move: null, value: double.negativeInfinity);
      availableDots.forEach((dot) {
        Move newMove = Move(dot: dot);
        GameManager newManager = manager.play(newMove);
        BestScore score = miniMax(depth - 1, newManager, !isMaximisingPlayer);
        bestScore = bestScore.maxScore(score);
      });

      //print('Maximizer ${manager.current.id} $bestScore');
      return bestScore;
    } else {
      BestScore bestScore = BestScore(move: null, value: double.infinity);
      availableDots.forEach((dot) {
        Move newMove = Move(dot: dot);
        GameManager newManager = manager.play(newMove);
        BestScore score = miniMax(depth - 1, newManager, !isMaximisingPlayer);
        bestScore = bestScore.minScore(score);
      });

      //print('Minimizer ${manager.current.id} $bestScore');
      return bestScore;
    }
  }

}
