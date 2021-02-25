import 'dart:collection';

import 'package:game_manager/ai/board_state.dart';
import 'package:game_manager/game_manager.dart';
import 'package:game_manager/models/board_settings.dart';
import 'package:game_manager/models/models.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import "package:collection/collection.dart";

class Board extends Equatable {
  final BoardSettings settings;
  final List<Dot> dots;
  final Player player;
  final Player opponent;
  final List<Move> moves;
  final DotStatus status;
  final Map<String, Square> squares = {};
  final DisplayBoard displayBoard;
  final BoardState savedState;

  /// Evaluate the board when a move is made, the board current state
  final double state;

  Board({
    @required BoardSettings settings,
    List<Dot> dots,
    List<Move> moves,
    BoardState savedState,
    double state,
    this.player,
    this.opponent,
    this.status,
    this.displayBoard,
  })  : this.settings = settings ?? BoardSettings(rows: 1, columns: 1),
        this.dots = dots ?? [],
        this.state = state,
        this.moves = moves ?? [],
        this.savedState = savedState,
        super() {
    DateTime start = DateTime.now();
    List<Dot> newDots = List.generate(settings.gridRows, (row) {
      return List.generate(settings.gridColumns, (column) {
        Dot newDot;
        if (row % 2 != 0) {
          newDot = column % 2 == 0
              ? Dot(
                  row: row,
                  column: column,
                  type: DotType.VERTICAL,
                  style: DotStyle(color: 0))
              : Dot(row: row, column: column, type: DotType.CENTER);
        } else {
          newDot = column % 2 == 0
              ? Dot(
                  row: row,
                  column: column,
                  type: DotType.TOUCHABLE,
                  status: status,
                  style: settings.style)
              : Dot(
                  row: row,
                  column: column,
                  type: DotType.HORIZONTAL,
                  style: DotStyle(color: 0));
        }

        if (newDot.type == DotType.TOUCHABLE) {
          newDot = _updatedDot(newDot);
        }

        _addToSquares(newDot);

        return newDot;
      });
    }).expand((i) => i).toList();
    //print('DURATION => board: ${Utils.getDuration(start)}');

    updateBoardState();
    //print('savedState: ${savedState.states.length}');

    this.dots.clear();
    this.dots.addAll(newDots);

    _updateMiddleDots();
    //print('DURATION => middle dots: ${Utils.getDuration(start)}');

    /*
    /// Initialize evaluator map if board is empty
    if (this.moves.isEmpty) {
      EvaluationMap(squares: this.squares);
    }

    print('EvaluationMap 1 : len(${EvaluationMap.squareValues.length})');
    //print('EvaluationMap 1 : ${EvaluationMap.squareValues}');
    this.squares.values.forEach((square) {
      if (!EvaluationMap.containsKey(square.mapKey)) {
        EvaluationMap.add(square.mapKey, square.squareValueFor(player));
      }
    });

    print('EvaluationMap 2 : len(${EvaluationMap.squareValues.length})');
    //print('EvaluationMap 2 : ${EvaluationMap.squareValues}');
    print('DURATION => total board: ${Utils.getDuration(start)}');
    */
  }

  /// Update board state MAP
  /// Add new square states only from PX perspective
  void updateBoardState() {
    DateTime start = DateTime.now();
    //print('BoardState 1 : len(${savedState.states.length})');
    if (this.savedState == null) return;

    this.squares.values.forEach((square) {
      if (!savedState.containsKey(square.mapKey)) {
        savedState.add(square.mapKey, square.pxEvaluation());
      }
    });
    //print('BoardState 2 : len(${savedState.states.length})');
    //print('BOARD STATE DURATION => ${Utils.getDuration(start)}');
  }

  @override
  List<Object> get props =>
      [settings, dots, player, opponent, moves, savedState];

  @override
  String toString() {
    return 'Board { settings: $settings, dots: $dots, player: $player, opponent: $opponent, savedState: $savedState }';
  }

  Dot _updatedDot(Dot dot) {
    Move move =
        this.moves.firstWhere((move) => move.id == dot.id, orElse: () => null);
    if (move != null) {
      Player movePlayer =
          move.madeBy == this.player.id ? this.player : this.opponent;
      return dot.copyWith(color: movePlayer.color, mark: movePlayer.mark);
    }

    return dot;
  }

  void _addToSquares(Dot dot) {
    SquareKeys keys = SquareKeys(dot, settings);
    _addToSquare(keys.leftKey, dot);
    _addToSquare(keys.topLeftKey, dot);
    _addToSquare(keys.topKey, dot);
    _addToSquare(keys.topRightKey, dot);
    _addToSquare(keys.rightKey, dot);
    _addToSquare(keys.bottomRightKey, dot);
    _addToSquare(keys.bottomKey, dot);
    _addToSquare(keys.bottomLeftKey, dot);
  }

  void _addToSquare(String key, Dot dot) {
    if (key == null) return;

    if (!this.squares.containsKey(key)) this.squares[key] = Square(key: key);

    if (dot.type == DotType.TOUCHABLE) {
      this.squares[key].touchableDots.add(dot);
      //this.squares[key].squareValue =
    } else {
      this.squares[key].middleDots.add(dot);
    }
  }

  void _updateMiddleDots() {
    /// For each square, If touchableDots have same marks,
    /// then update middleDots by the same mark color
    squares.keys.forEach((key) {
      Square square = squares[key];
      if (square.touchableDots.every((dot) => dot.mark == player.mark)) {
        _updateSquareMiddleDots(square, player.color);
      } else if (square.touchableDots
          .every((dot) => dot.mark == opponent.mark)) {
        _updateSquareMiddleDots(square, opponent.color);
      }
    });
  }

  void _updateSquareMiddleDots(Square square, int color) {
    square.middleDots.forEach((dot) {
      int index = this.dots.indexOf(dot);
      this.dots[index] = dot.copyWith(color: color);
    });
  }

  /*
  Board clone() {
    return Board(
        settings: settings,
        player: player.clone(),
        opponent: opponent.clone(),
        dots: List.from(dots));
  }*/

  ///All available dots
  List<Dot> get availableDots => dots
      .where((dot) => !dot.hasMark && dot.type == DotType.TOUCHABLE)
      .toList();

  List<Dot> get touchableDots =>
      dots.where((dot) => dot.type == DotType.TOUCHABLE).toList();

  /// Check if the board is Full
  bool isBoardFull() {
    if (this.moves.isEmpty) return false;
    return !this.squares.values.any((square) => square.isWinnable());
  }

  /// Print's the current state's board in a nice pretty way
  void display({String title, bool show}) {
    if (show == null)
      if (!displayBoard.show) return;

    String boardTitle = '\nBOARD :: ';
    if (title != null)
      boardTitle += title;
    else
      boardTitle += '${settings.rows} x ${settings.columns}';

    if (!displayBoard.testing) return;

    String line = '';
    int index = 0;
    dots.forEach((dot) {
      /// AI has blue color and player has red color
      String dotId = dot.id.length == 2 ? '${dot.id}-' : '${dot.id}';
      switch (dot.mark) {
        case Mark.PX:
          line += _blueBg(dotId);
          break;
        case Mark.PY:
          line += _redBg(dotId);
          break;
        default:
          if (dot.type == DotType.TOUCHABLE)
            line += _whiteBg(dotId);
          else
            line += _blackBg(dotId);
          break;
      }

      if (index == settings.gridColumns - 1) {
        index = 0;
        line += _end + "\n";
      } else {
        index++;
      }
    });

    print(boardTitle);
    print(line);
    print('\n');
  }

  String get _end => '\u001b[0m';
  String _blackBg(String value) => '\u001b[40m $value ';
  String _blueBg(String value) => '\u001b[104m $value ';
  String _redBg(String value) => '\u001b[101m $value ';
  String _whiteBg(String value) => '\u001b[107m $value ';
}
