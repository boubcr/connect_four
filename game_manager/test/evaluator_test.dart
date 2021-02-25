import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_manager/ai/evaluator.dart';
import 'package:game_manager/game_manager.dart';
import 'package:game_manager/models/models.dart';
import 'package:game_manager/ai/evaluator.dart';

import 'test_utils.dart';

/// BP : Blue Player
/// BM : Best Move
void main() {
  BoardSettings settings1 = BoardSettings(rows: 3, columns: 3);
  BoardSettings settings2 = BoardSettings(rows: 4, columns: 4);

  group('Evaluation 01', () {
    Player bluePlayer = TestUtils.bluePlayer;
    Player redPlayer = TestUtils.redPlayer;

    test('Red player test 001', () {
      GameManager manager = GameManager(
          settings: settings1,
          player: bluePlayer,
          opponent: redPlayer,
          moves: [
            Move(dot: Dot(row: 0, column: 0), madeBy: bluePlayer.id),
            Move(dot: Dot(row: 0, column: 2), madeBy: bluePlayer.id),
            Move(dot: Dot(row: 2, column: 0), madeBy: redPlayer.id),
            Move(dot: Dot(row: 2, column: 2), madeBy: redPlayer.id)
          ]);

      manager.board.display(title: 'Initial board');
      double score = Evaluator.evaluate(manager.board, redPlayer);
      //expect(score, -3.0);
    });

    test('Red player test 002', () {
      GameManager manager = GameManager(
          settings: BoardSettings(rows: 4, columns: 4),
          player: bluePlayer,
          opponent: redPlayer,
          moves: [
            Move(dot: Dot(row: 0, column: 0), madeBy: redPlayer.id),
            Move(dot: Dot(row: 0, column: 2), madeBy: bluePlayer.id),
            Move(dot: Dot(row: 2, column: 0), madeBy: redPlayer.id),
            Move(dot: Dot(row: 2, column: 2), madeBy: redPlayer.id)
          ]);

      manager.board.display(title: 'Initial board');
      double score = Evaluator.evaluate(manager.board, bluePlayer);
      //expect(score, -3.0);
    });

    /*
    test('Evaluate played move', () {
      Move move = Move(dot: Dot(index: 20, row: 4, column: 0));
      bluePlayer.play(move);
    });
    */
  });
  /*
  double _getRedScore(
      Dimension dimension, List<Move> moves, Participant player) {
    List<Move> allMoves = List.from(moves);
    Board board = Board(dimension: dimension, moves: allMoves);
    //board.display();
    //return Evaluate(board).getScore(player);
    return 0;
  }

  group('Evaluation 01', () {
    List<Move> moves = [
      Move(dot: Dot(row: 2, column: 0), participant: TestUtils.redPlayer),
      Move(dot: Dot(row: 2, column: 2), participant: TestUtils.redPlayer),
      Move(dot: Dot(row: 2, column: 4), participant: TestUtils.redPlayer),
      Move(dot: Dot(row: 4, column: 0), participant: TestUtils.bluePlayer),
      Move(dot: Dot(row: 4, column: 2), participant: TestUtils.bluePlayer),
      Move(dot: Dot(row: 4, column: 4), participant: TestUtils.bluePlayer)
    ];

    test('Get Red player score on 3x3', () {
      Dimension dimension = Dimension(rows: 3, columns: 3);
      double score = _getRedScore(dimension, moves, TestUtils.redPlayer);
      expect(score, 4.0);
    });

    test('Get Blue player score on 3x3', () {
      Dimension dimension = Dimension(rows: 3, columns: 3);
      double score = _getRedScore(dimension, moves, TestUtils.bluePlayer);
      expect(score, -4.0);
    });

    test('Get Red player score on 4x4', () {
      Dimension dimension = Dimension(rows: 4, columns: 4);
      double score = _getRedScore(dimension, moves, TestUtils.redPlayer);
      expect(score, 0.0);
    });
  });

  group('Evaluation 02', () {
    List<Move> moves = [
      Move(dot: Dot(row: 0, column: 0), participant: TestUtils.redPlayer),
      Move(dot: Dot(row: 0, column: 2), participant: TestUtils.redPlayer),
      Move(dot: Dot(row: 2, column: 0), participant: TestUtils.redPlayer),
      Move(dot: Dot(row: 2, column: 4), participant: TestUtils.bluePlayer),
      Move(dot: Dot(row: 4, column: 2), participant: TestUtils.bluePlayer),
      Move(dot: Dot(row: 4, column: 4), participant: TestUtils.bluePlayer)
    ];

    test('Get Red player score on 3x3', () {
      Dimension dimension = Dimension(rows: 3, columns: 3);
      double score = _getRedScore(dimension, moves, TestUtils.redPlayer);
      expect(score, 0.0);
    });

    test('Get Blue player score on 3x3', () {
      Dimension dimension = Dimension(rows: 3, columns: 3);
      double score = _getRedScore(dimension, moves, TestUtils.bluePlayer);
      expect(score, 0.0);
    });

    test('Get Red player score on 4x4', () {
      Dimension dimension = Dimension(rows: 4, columns: 4);
      double score = _getRedScore(dimension, moves, TestUtils.redPlayer);
      expect(score, -4.0);
    });
  });
  */
  /*
  group('BP - BM - 3 horizontal dots for each', () {
    List<Move> moves = [
      Move(dot: Dot(row: 2, column: 0), participant: TestUtils.redPlayer),
      Move(dot: Dot(row: 2, column: 2), participant: TestUtils.redPlayer),
      Move(dot: Dot(row: 2, column: 4), participant: TestUtils.redPlayer),
      Move(dot: Dot(row: 4, column: 0), participant: TestUtils.bluePlayer),
      Move(dot: Dot(row: 4, column: 2), participant: TestUtils.bluePlayer),
      Move(dot: Dot(row: 4, column: 4), participant: TestUtils.bluePlayer)
    ];

    test('Best move should be 40 for 4x3 board', () {
      Dimension dimension = Dimension(rows: 4, columns: 3);
      Move bestMove = TestUtils.findAndPlay(
          dimension: dimension,
          moves: moves,
          currentTurn: TestUtils.bluePlayer);
      expect(bestMove.dot.id, '62');
    });
  });

  group('Best move for Blue Player with different board', () {
    List<Move> moves = [
      Move(dot: Dot(row: 0, column: 0), participant: TestUtils.redPlayer),
      Move(dot: Dot(row: 0, column: 2), participant: TestUtils.redPlayer),
      Move(dot: Dot(row: 0, column: 4), participant: TestUtils.redPlayer),
      Move(dot: Dot(row: 2, column: 0), participant: TestUtils.bluePlayer),
      Move(dot: Dot(row: 2, column: 2), participant: TestUtils.bluePlayer),
      Move(dot: Dot(row: 4, column: 2), participant: TestUtils.bluePlayer)
    ];

    test('Best move should be 40 for 3x3 board', () {
      Dimension dimension = Dimension(rows: 3, columns: 3);
      Move bestMove = TestUtils.findAndPlay(
          dimension: dimension,
          moves: moves,
          currentTurn: TestUtils.bluePlayer);
      expect(bestMove.dot.id, '40');
    });

    test('Best move should be 40 for 4x4 board', () {
      Dimension dimension = Dimension(rows: 4, columns: 4);
      Move bestMove = TestUtils.findAndPlay(
          dimension: dimension,
          moves: moves,
          currentTurn: TestUtils.bluePlayer);
      expect(bestMove.dot.id, '40');
    });
  });

  */
}
