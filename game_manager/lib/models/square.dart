import 'package:flutter/material.dart';
import 'package:game_manager/models/board_settings.dart';
import 'package:game_manager/models/models.dart';
import 'package:game_manager/utils/utils.dart';

class Square {
  Square({@required String key, List<Dot> touchableDots, List<Dot> middleDots})
      : this.key = key,
        this.touchableDots = touchableDots ?? [],
        this.middleDots = middleDots ?? [];

  final String key;
  final List<Dot> touchableDots;
  final List<Dot> middleDots;

  /// Evaluate square for player PX
  /// Will get the opposite of this value for opponent PY
  //double evaluateForPlayer() {
  double pxEvaluation() {
    double value = 0.0;
    if (this.touchableDots.length < 4) return value;

    List<Dot> markedDots =
        this.touchableDots.where((dot) => dot.hasMark).toList();

    if (markedDots.every((dot) => dot.mark == Mark.PX))
      value = _getFactor(markedDots.length);
    else if (markedDots.every((dot) => dot.mark == Mark.PY))
      value = -_getFactor(markedDots.length);

    return value;
  }

  double squareValueFor(Player player) {
    double value = 0.0;
    if (this.touchableDots.length < 4) return value;

    List<Dot> markedDots =
        this.touchableDots.where((dot) => dot.hasMark).toList();

    if (markedDots.every((dot) => dot.mark == player.mark))
      value = _getFactor(markedDots.length);
    else if (markedDots.every((dot) => dot.mark != player.mark))
      value = -_getFactor(markedDots.length);

    //print('Square $key for ${Enum.getValue(player.mark)} ${player.name}, value: $value');

    return value;
  }

  //TODO check touchableDots ordering: this key goes from left to right
  String get mapKey =>
      '$key:${touchableDots.map((e) => '${e.id}${Enum.getValue(e.mark)}').fold('', (acc, curr) => '$acc$curr')}';

  bool get isFull => this.touchableDots.every((dot) => dot.hasMark);

  bool isWinnable() {
    if (this.isFull) return false;
    List<Mark> marks = this.touchableDots.map((e) => e.mark).toSet().toList();
    return marks.length == 2;
  }

  double _getFactor(int count) {
    switch (count) {
      case 1:
        return 5.0;
      case 2:
        return 501.0;
      case 3:
        return 50001.0;
      case 4:
        return 5000001.0;
      default:
        return 0.0;
    }
  }
}

class ScoreAnimationValue {
  ScoreAnimationValue({this.dot, this.value});
  final Dot dot;
  final int value;
}

/// From a point of a dot, where are the centers of the squares
class SquareCenters {
  SquareCenters(
      {this.topLeftKey,
      this.topRightKey,
      this.bottomLeftKey,
      this.bottomRightKey});
  final String topLeftKey;
  final String topRightKey;
  final String bottomLeftKey;
  final String bottomRightKey;
}

class SquareState {
  /// Current participant dots number
  int player;

  /// Other participant dots number
  int other;

  SquareState({this.player = 0, this.other = 0});

  void incrementPlayer() => this.player++;
  void incrementOther() => this.other++;

  @override
  String toString() {
    return 'SquareState { '
        'player: $player, '
        'other: $other }';
  }
}

/// Get square keys
class SquareKeys {
  final Dot dot;
  final BoardSettings settings;

  String topLeftKey;
  String topRightKey;
  String bottomLeftKey;
  String bottomRightKey;
  String topKey;
  String bottomKey;
  String leftKey;
  String rightKey;

  SquareKeys(this.dot, this.settings) {
    switch (dot.type) {
      case DotType.TOUCHABLE:
        topLeftKey = _createKey(dot.row - 1, dot.column - 1);
        topRightKey = _createKey(dot.row - 1, dot.column + 1);
        bottomLeftKey = _createKey(dot.row + 1, dot.column - 1);
        bottomRightKey = _createKey(dot.row + 1, dot.column + 1);
        break;
      case DotType.HORIZONTAL:
        topKey = _createKey(dot.row - 1, dot.column);
        bottomKey = _createKey(dot.row + 1, dot.column);
        break;
      case DotType.VERTICAL:
        if (dot.column % 2 == 0) {
          leftKey = _createKey(dot.row, dot.column - 1);
          rightKey = _createKey(dot.row, dot.column + 1);
        }
        break;
      default:
        break;
    }
  }

  static List<String> squaresOf(Dot d) {
    return [
      Utils.dotKey(d.row - 1, d.column - 1), // topLeftKey
      Utils.dotKey(d.row - 1, d.column + 1), // topRightKey
      Utils.dotKey(d.row + 1, d.column - 1), // bottomLeftKey
      Utils.dotKey(d.row + 1, d.column + 1), // bottomRightKey
    ];
  }

  /*
  static SquareCenters squaresOf(Dot d) {
    return SquareCenters(
      topLeftKey: Utils.dotKey(d.row - 1, d.column - 1),
      topRightKey: Utils.dotKey(d.row - 1, d.column + 1),
      bottomLeftKey: Utils.dotKey(d.row + 1, d.column - 1),
      bottomRightKey: Utils.dotKey(d.row + 1, d.column + 1),
    );
  }*/

  int countPerfectSquare(Map<String, Square> squares) {
    int count = _isSquare(squares, topLeftKey);
    count += _isSquare(squares, topRightKey);
    count += _isSquare(squares, bottomLeftKey);
    count += _isSquare(squares, bottomRightKey);
    count += _isSquare(squares, topKey);
    count += _isSquare(squares, bottomKey);
    count += _isSquare(squares, leftKey);
    count += _isSquare(squares, rightKey);
    return count;
  }

  String _createKey(row, column) {
    if (row < 0 ||
        column < 0 ||
        row >= settings.gridRows ||
        column >= settings.gridColumns) return null;

    return Utils.dotKey(row, column);
  }

  int _isSquare(Map<String, Square> squares, String key) {
    if (squares.containsKey(key)) {
      Square square = squares[key];
      List<Dot> dots = square.touchableDots
          .where((d) => d.id != dot.id && d.mark == dot.mark)
          .toList();
      if (dots.length == 3) return 1;
    }
    return 0;
  }
}
