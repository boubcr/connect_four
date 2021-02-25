import 'package:game_manager/ai/board_state.dart';
import 'package:game_manager/game_manager.dart';
import 'package:game_manager/models/models.dart';
import 'package:game_manager/utils/utils.dart';

class Evaluator {
  static const double FOUR_FACTOR = 500001.0; // 10.0
  static const double THREE_FACTOR = 5000.0; // 5.0
  static const double TWO_FACTOR = 500.0; // 2.0
  static const double ONE_FACTOR = 1.0; // 2.0

  static double evaluate(Board board, Player player) {
    DateTime start = DateTime.now();
    //print('= BOARD EVALUATION START - Player: ${player.name}');
    double score = board.squares.values.map((square) {
      //print('square key: ${square.key}');
      //print('square value: ${square.squareValueFor(player)}');
      return square.squareValueFor(player);
    }).fold(0.0, (previousValue, value) => previousValue + value);

    //print("= BOARD EVALUATION END   : SCORE = $score \n\n");
    //print('Evaluation duration: ${Utils.getDuration(start)}');
    return score;
  }

  /*static double optimalEvaluate(GameManager manager) {
    DateTime start = DateTime.now();
    //print('= BOARD EVALUATION START - Player: ${player.name}');
    double score = board.squares.values.map((square) {
      //print('square key: ${square.key}');
      //print('square value: ${square.squareValueFor(player)}');
      if (board.savedState.containsKey(square.mapKey))
        return board.savedState.valueOf(square.mapKey);

      return square.squareValue(mark);
    }).fold(0.0, (previousValue, value) => previousValue + value);

    //print("= BOARD EVALUATION END   : SCORE = $score \n\n");
    //print('Evaluation duration: ${Utils.getDuration(start)}');
    return score;
  }*/

  /// Always evaluate the board for AiPlayer
  static double evaluateOld(Board board, Player player) {
    print('= BOARD EVALUATION START - Player: ${player.name}');
    Map<String, Square> squares = board.squares;

    Counter playerCounter = Counter();
    Counter otherCounter = Counter();

    /// Count the number of dots in each square in the board
    /// Consider only valid squares and Count only marked dots, ignore unmark dots
    squares.keys
        .where((key) => squares.containsKey(key))
        .map((key) => squares[key])
        .forEach((square) {
      SquareState squareState = square.touchableDots
          .where((dot) => dot.mark != null)
          .fold(SquareState(), (SquareState state, dot) {
        if (dot.mark == player.mark)
          state.incrementPlayer();
        else
          state.incrementOther();
        return state;
      });

      playerCounter.add(squareState.player);
      otherCounter.add(squareState.other);
    });

    print('Player: $playerCounter');
    print('Other: $otherCounter');

    /// Calculate the score base on the number of dots of 4, 3 and 2
    double playerScore = _calculateValue(playerCounter);
    print('Player Score: $playerScore');
    double otherScore = _calculateValue(otherCounter);
    print('Other Score: $otherScore');
    double score = playerScore - otherScore;

    print("= BOARD EVALUATION END   : SCORE = $score \n\n");
    return score;
  }

  static double _calculateValue(Counter counter) {
    return counter.nbFours * FOUR_FACTOR +
        counter.nbThrees * THREE_FACTOR +
        counter.nbTwos * TWO_FACTOR +
        counter.nbOnes * ONE_FACTOR;
  }
}

class SquareState2 {
  Map<Mark, Counter> plMap = {};
  Map<Mark, Counter> oppMap = {};

  SquareState2() {
    plMap.putIfAbsent(Mark.PX, () => Counter());
    oppMap.putIfAbsent(Mark.PY, () => Counter());
  }

  @override
  String toString() {
    return 'SquareState { '
        'plMap: $plMap, '
        'oppMap: $oppMap }';
  }
}


class Counter {
  int nbFours;
  int nbThrees;
  int nbTwos;
  int nbOnes;
  Counter({this.nbFours = 0, this.nbThrees = 0, this.nbTwos = 0, this.nbOnes = 0});

  void add(int value) {
    switch (value) {
      case 1:
        incrementOnes();
        break;
      case 2:
        incrementTwos();
        break;
      case 3:
        incrementThrees();
        break;
      case 4:
        incrementFours();
        break;
      default:
        break;
    }
  }

  void incrementFours() => this.nbFours++;
  void incrementThrees() => this.nbThrees++;
  void incrementTwos() => this.nbTwos++;
  void incrementOnes() => this.nbOnes++;

  @override
  String toString() {
    return 'DotCounter { '
        'nbFours: $nbFours, '
        'nbThrees: $nbThrees, '
        'nbTwos: $nbTwos, '
        'nbOnes: $nbOnes }';
  }
}