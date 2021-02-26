library game_manager;

export 'ai/ai.dart';
export 'models/models.dart';
export 'utils/utils.dart';
export 'app_initializer.dart';
export 'repositories/repositories.dart';
export 'utils/ad_manager.dart';
export 'validators.dart';

import 'package:game_manager/ai/board_state.dart';
import 'package:game_manager/models/models.dart';
import 'package:game_manager/utils/utils.dart';
import "package:collection/collection.dart";

enum GameStatus { NO_WINNER_YET, WINNER, LOSER, DRAW }

class DisplayBoard {
  const DisplayBoard({this.show = false, this.testing = false});
  final bool show;
  final bool testing;
}

class Evaluation {
  const Evaluation({this.playerValue, this.opponentValue});
  final double playerValue;
  final double opponentValue;
}

class GameManager {
  final String gameKey;
  final BoardSettings settings;
  final Player player;
  final Player opponent;
  final List<Move> moves;
  final LastMove lastMove;
  final int thinkTime;
  final int level;
  final BoardState savedState;
  final DisplayBoard display;
  final Evaluation evaluation;

  Board board;
  Player current;

  GameManager(
      {String gameKey,
      List<Move> moves,
      BoardState savedState,
      DisplayBoard display,
      Evaluation evaluation,
      this.settings,
      this.player,
      this.opponent,
      this.lastMove,
      this.thinkTime,
      this.level,
      this.current})
      : this.gameKey = gameKey ?? Uuid().generateV4(),
        this.moves = moves ?? [],
        this.evaluation = evaluation,
        this.display = display ?? DisplayBoard(),
        this.savedState = savedState ?? BoardState() {
    //print('GameManager => Current ${current.name}, status: ${current.isAi ? DotStatus.DEACTIVATE : DotStatus.ACTIVE}');
    //print('CURRENT PLAYER: ${current.mark}');

    this.board = Board(
      status: current.isAi ? DotStatus.DEACTIVATE : DotStatus.ACTIVE,
      moves: moves,
      settings: settings,
      player: player,
      opponent: opponent,
      savedState: this.savedState,
      displayBoard: this.display,
    );

    _updatePlayersMoves();
  }

  ScoreAnimationValue scoreAnimationPosition(Dot dot) {
    List<Square> squares = SquareKeys.squaresOf(dot)
        .where((key) => board.squares.containsKey(key))
        .map((key) => board.squares[key])
        .where((square) =>
            square.touchableDots
                .where((d) =>
                    d.id != dot.id && d.hasMark && d.mark == current.mark)
                .length ==
            3)
        .toList();

    List<Dot> centers =
        squares.map((square) => getDot(Utils.dotId(square.key))).toList();
    Dot centerPosition;
    if (centers.length > 2) {
      centerPosition = dot;
    } else if (centers.length == 2) {
      if (centers.first.row == centers.last.row)
        centerPosition =
            getDot('${centers.first.row}${centers.first.column + 1}');
      else if (centers.first.column == centers.last.column)
        centerPosition =
            getDot('${centers.first.row + 1}${centers.first.column}');
      else
        centerPosition = dot;
    } else if (centers.length == 1) {
      centerPosition = getDot(Utils.dotId(squares.first.key));
    }

    return ScoreAnimationValue(dot: centerPosition, value: centers.length);
  }

  Dot getDot(String id) => board.dots.firstWhere((dot) => dot.id == id);

  GameStatus gameStatus() {
    if (this.board.isBoardFull()) {
      int diff = player.score.value - opponent.score.value;
      if (diff == 0)
        return GameStatus.DRAW;
      else if (diff < 0)
        return GameStatus.LOSER;
      else
        return GameStatus.WINNER;
    }

    return GameStatus.NO_WINNER_YET;
  }

  void _updatePlayersMoves() {
    if (moves == null || moves.isEmpty) return;

    var map = groupBy(moves, (Move move) => move.madeBy);
    if (map.containsKey(player.id)) {
      int score = map[player.id].fold(0, (sum, move) => sum + move.notation);
      player.score.update(score);
    }

    if (map.containsKey(opponent.id)) {
      int score2 = map[opponent.id].fold(0, (sum, move) => sum + move.notation);
      opponent.score.update(score2);
    }
  }

  GameManager copyWith(
      {List<Move> moves,
      LastMove lastMove,
      Evaluation evaluation,
      bool switchTurn = false,
      bool enabled = false,
      bool status}) {
    return GameManager(
        gameKey: this.gameKey,
        settings: this.settings,
        player: this.player,
        opponent: this.opponent,
        thinkTime: this.thinkTime,
        level: this.level,
        savedState: this.savedState,
        display: this.display,
        evaluation: evaluation ?? this.evaluation,
        moves: moves ?? this.moves,
        lastMove: lastMove ?? this.lastMove,
        current: switchTurn ? otherPlayer(this.current) : this.current);
  }

  GameManager play(Move move) {
    DateTime start = DateTime.now();
    if (move == null) {
      print('Trying to play a null move');
      return this;
    }

    List<Move> updatedMoves = List.from(moves);
    //int notation = moveNotation(move);

    String madeBy = Enum.getValue(this.current.id);
    Move upMove = move.copyWith(madeBy: madeBy, index: moves.length + 1);
    updatedMoves.add(upMove);

    //Update board with new moves and switch players
    GameManager manager = copyWith(switchTurn: true, moves: updatedMoves);

    manager.board
        .display(title: 'Move ${move.id} played by ${this.current.name}');

    //print('GameManager Play duration: ${Utils.getDuration(start)}');
    return manager;
  }

  Move get lastPlayedMove => this.moves.fold(moves.first, (last, move) => last.index > move.index ? last : move);
  List<String> get moveIds =>
      this.moves.map((e) => '${e.madeBy}-${e.id}').toList();
  bool get isLastMoveFromPX => this.current.mark == this.opponent.mark;
  bool get isPlayerTurn => this.current.mark == this.player.mark;
  bool get isOpponentTurn => this.current.mark == this.opponent.mark;
  Player get lastPlayer => otherPlayer(this.current);

  int get playerNumberOfMoves =>
      moves.where((move) => move.madeBy == player.id).length;

  set currentTurn(Player player) {
    current = player;
  }

  Player otherPlayer(Player p) {
    return p.id == player.id ? opponent : player;
  }

  @override
  String toString() {
    return 'GameManager { '
        'gameKey: $gameKey, '
        'settings: $settings, '
        'thinkTime: $thinkTime, '
        'level: $level, '
        'evaluation: $evaluation, '
        'board: $board, '
        'player: $player, '
        'opponent: $opponent, '
        'current: $current, '
        'moves: $moves }';
  }

  /// Evaluate the board
  //double get evaluateBoard => Evaluator.evaluate(board, this.current);

  double evaluate() {
    //double pxOptimal = pxEvaluation();
    /// If last move is made by PY then take the opposite value of PX
    //double optimal = isLastMoveFromPX ? pxOptimal : -pxOptimal;
    //print('= BOARD STATE $optimal FROM LAST MOVE');

    //double normal = normalEvaluationOld();
    //print('= BOARD STATE $normal');
    //return normal;
    double pxOptimal = normalEvaluation(current);
    print('= BOARD STATE $pxOptimal');
    return pxOptimal;
  }

  double normalEvaluation(Player pl) {
    DateTime start = DateTime.now();
    double score = board.squares.values
        .map((square) => square.squareValueFor(pl))
        .fold(0.0, (previousValue, value) => previousValue + value);
    //print('Evaluation duration: ${Utils.getDuration(start)}');
    return score;
  }

  double pxEvaluation() {
    DateTime start = DateTime.now();
    double score = board.squares.values.map((square) {
      /// PX square states are already stored in map
      double value = board.savedState.valueOf(square.mapKey);
      //print('Square key: ${square.key}, mapKey: ${square.mapKey}, value: $value');
      return value;
    }).fold(0.0, (previousValue, value) => previousValue + value);

    print(
        'PX Optimal Evaluation => score: $score, ${Utils.getDuration(start)}');
    return score;
  }

  double normalEvaluationOld() {
    DateTime start = DateTime.now();
    double score = board.squares.values
        .map((square) => square.squareValueFor(current))
        .fold(0.0, (previousValue, value) => previousValue + value);
    //print('Evaluation duration: ${Utils.getDuration(start)}');
    return score;
  }

  double optimalEvaluationOld() {
    DateTime start = DateTime.now();
    double score = board.squares.values.map((square) {
      /// Square states are already stored in map
      double value = board.savedState.valueOf(square.mapKey);
      if (current.mark == opponent.mark) value = -value;

      //print('Square key: ${square.key}, mapKey: ${square.mapKey}, value: $value');
      return value;
    }).fold(0.0, (previousValue, value) => previousValue + value);

    print('Optimal Evaluation: ${Utils.getDuration(start)}');
    return score;
  }
}
