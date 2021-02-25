import 'dart:math';
import 'package:game_manager/ai/ai.dart';
import 'package:game_manager/game_manager.dart';
import 'package:game_manager/models/models.dart';
import 'package:logging/logging.dart';

/// Implement the AlphaBetaPruningStrategy strategy
class AlphaBetaPruningStrategy extends Strategy {
  static final _log = Logger('AlphaBetaPruningStrategy');

  final depth;
  final showBoard;
  Player player;
  AlphaBetaPruningStrategy({this.depth = 1, this.showBoard = false}) : super();

  @override
  Future<BestScore> think(GameManager manager) async {
    DateTime start = DateTime.now();
    player = manager.current;
    _log.info('Thinking start: Player ${player.name}');
    double alpha = double.negativeInfinity;
    double beta = double.infinity;
    BestScore bestScore = alphaBetaPruning(depth, manager, alpha, beta, true);
    _log.info('Thinking end: ${Utils.getDuration(start)}');
    _log.info('Thinking result: $bestScore');
    return bestScore;
  }

  BestScore alphaBetaPruning(int depth, GameManager manager, double alpha, double beta, bool isMaximisingPlayer) {
    List<Dot> availableDots = manager.board.availableDots;

    if (depth == 0 || availableDots.length == 0) {
      Move move = manager.lastPlayedMove;
      double value = manager.normalEvaluation(player);
      BestScore bestScore = BestScore(value: value, move: move);
      print('Played moves ${manager.moveIds}');
      print('AlphaBeta Evaluation ${player.id} $bestScore');
      return bestScore;
    }

    if (isMaximisingPlayer) {
      BestScore bestScore = BestScore(move: null, value: double.negativeInfinity);
      for (Dot dot in availableDots) {
        Move newMove = Move(dot: dot);
        GameManager newManager = manager.play(newMove);
        BestScore score = alphaBetaPruning(depth - 1, newManager, alpha, beta, !isMaximisingPlayer);
        bestScore = bestScore.maxScore(score);
        alpha = max(alpha, bestScore.value);
        if (beta <= alpha) {
          print('Maximizer ${manager.current.id}, alpha:$alpha, $bestScore');
          return bestScore;
        }
      }

      print('Maximizer ${manager.current.id} $bestScore');
      return bestScore;
    } else {
      BestScore bestScore = BestScore(move: null, value: double.infinity);

      for (Dot dot in availableDots) {
        Move newMove = Move(dot: dot);
        GameManager newManager = manager.play(newMove);
        BestScore score = alphaBetaPruning(depth - 1, newManager, alpha, beta, !isMaximisingPlayer);
        bestScore = bestScore.minScore(score);
        beta = min(beta, bestScore.value);
        if (beta <= alpha) {
          print('Minimizer ${manager.current.id}, beta:$beta, $bestScore');
          return bestScore;
        }
      }

      print('Minimizer ${manager.current.id} $bestScore');
      return bestScore;
    }
  }

/*
  BestScore miniMaxRoot(int depth, GameManager manager, bool isMaximisingPlayer) {
    DateTime start = DateTime.now();
    print('depth => $depth');
    List<Dot> availableDots = manager.board.availableDots;
    double bestValue = double.negativeInfinity;
    Move bestMoveFound;

    double alpha = double.negativeInfinity;
    double beta = double.infinity;

    availableDots.forEach((dot) {
      Move newMove = Move(dot: dot);
      GameManager newManager = manager.play(newMove);
      double value = miniMax(depth - 1, newManager, alpha, beta, !isMaximisingPlayer);
      if (value >= bestValue) {
        bestValue = value;
        bestMoveFound = newMove;
      }
    });

    print('==> ABP-MiniMaxRoot ${Utils.getDuration(start)}, BestMove: ${bestMoveFound.id}');
    return BestScore(move: bestMoveFound, value: bestValue);
  }

  double miniMax2(int depth, GameManager manager, double alpha, double beta, bool isMaximisingPlayer) {
    if (depth == 0) {
      double value = manager.normalEvaluation(player);
      print('ABP-MiniMax Evaluation $value for moves ${manager.moveIds}');
      return value;
    }

    List<Dot> availableDots = manager.board.availableDots;
    if (isMaximisingPlayer) {
      /// Maximizer = player is playing
      double bestValue = double.negativeInfinity;
      availableDots.forEach((dot) {
        Move newMove = Move(dot: dot);
        GameManager newManager = manager.play(newMove);
        bestValue = max(bestValue, miniMax(depth - 1, newManager, alpha, beta, !isMaximisingPlayer));
        alpha = max(alpha, bestValue);
        if (beta <= alpha) {
          return bestValue;
        }
      });
      return bestValue;
    } else {
      /// Minimizer = opponent is playing
      double bestValue = double.infinity;
      availableDots.forEach((dot) {
        Move newMove = Move(dot: dot);
        GameManager newManager = manager.play(newMove);
        bestValue = min(bestValue, miniMax(depth - 1, newManager, alpha, beta, !isMaximisingPlayer));
        beta = min(beta, bestValue);
        if (beta <= alpha) {
          return bestValue;
        }
      });
      return bestValue;
    }
  }

   */
}
