import 'package:game_manager/ai/ai.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_manager/game_manager.dart';
import 'package:game_manager/logger.dart';
import 'package:game_manager/models/models.dart';

import 'test_utils.dart';

/// PX : Blue Player
/// PY : Best Move
void main() {
  initRootLogger();
  DisplayBoard display = DisplayBoard(show: true, testing: true);

  Player pxMin = TestUtils.pxBlue.clone(strategy: MiniMaxStrategy(depth: 1));
  Player pyMin = TestUtils.pyRed.clone(strategy: MiniMaxStrategy(depth: 3));

  group('MiniMax strategy 01', () {
    test('MiniMax vs MiniMax', () {
      GameManager manager = GameManager(
          display: display,
          settings: BoardSettings(rows: 4, columns: 3),
          player: pxMin,
          opponent: pyMin,
          current: pxMin,
          moves: [
            Move(dot: Dot(row: 0, column: 0), madeBy: pxMin.id),
            Move(dot: Dot(row: 0, column: 2), madeBy: pxMin.id),
            Move(dot: Dot(row: 2, column: 0), madeBy: pxMin.id),
            Move(dot: Dot(row: 4, column: 4), madeBy: pyMin.id),
            Move(dot: Dot(row: 6, column: 2), madeBy: pyMin.id),
            Move(dot: Dot(row: 6, column: 4), madeBy: pyMin.id)

          ]);

      print('Current player testing: ${manager.current.mark}');
      manager.board.display(title: 'Initial board');
      manager.current.strategy.think(manager).then((bestScore) {
        print(bestScore);
        GameManager newManager = manager.play(bestScore.move);
        newManager.board.display(title: 'Final board');
        //expect(score, -3.0);
      });

      /*TestUtils.simulateGame(
          settings: BoardSettings(rows: 4, columns: 3),
          nbTurn: 4,
          bluePlayer: bluePl,
          redPlayer: redPl,
          starter: redPl);*/
    });

    /*
    test('MiniMax vs MiniMax 002', () {
      GameManager manager = GameManager(
          display: display,
          settings: BoardSettings(rows: 4, columns: 3),
          player: pxMin,
          opponent: pyRnd,
          current: pyRnd,
          moves: [
            Move(dot: Dot(row: 0, column: 0), madeBy: pxMin.id),
            Move(dot: Dot(row: 0, column: 2), madeBy: pxMin.id),
            Move(dot: Dot(row: 2, column: 0), madeBy: pxMin.id),
            Move(dot: Dot(row: 4, column: 0), madeBy: pyRnd.id),
            Move(dot: Dot(row: 4, column: 2), madeBy: pyRnd.id),
          ]);

      print('Current player testing: ${manager.current.mark}');
      manager.board.display(title: 'Initial board');
      manager.current.strategy.think(manager).then((bestScore) {
        print(bestScore);
        GameManager newManager = manager.play(bestScore.bestMove);
        newManager.board.display(title: 'Final board');
        //expect(score, -3.0);
      });

      /*TestUtils.simulateGame(
          settings: BoardSettings(rows: 4, columns: 3),
          nbTurn: 4,
          bluePlayer: bluePl,
          redPlayer: redPl,
          starter: redPl);*/
    });
    */
    /*
    test('Evaluation vs MinMax', () {
      Player bluePl = bluePlayer.clone(strategy: EvaluationStrategy());
      Player redPl = redPlayer.clone(strategy: MiniMaxStrategy(depth: 2));

      TestUtils.simulateGame(
          settings: BoardSettings(rows: 4, columns: 3),
          nbTurn: 6,
          bluePlayer: bluePl,
          redPlayer: redPl,
          starter: redPl);
    });

    test('Naive vs MinMax', () {
      Player bluePl = bluePlayer.clone(strategy: NaiveStrategy());
      Player redPl = redPlayer.clone(strategy: MiniMaxStrategy(depth: 2));

      TestUtils.simulateGame(
          settings: BoardSettings(rows: 4, columns: 3),
          nbTurn: 4,
          bluePlayer: bluePl,
          redPlayer: redPl,
          starter: redPl);
    });*/
  });

  /*
  group('MiniMax strategy 02', () {
    List<Move> moves = [
      Move(dot: Dot(index: 0, row: 0, column: 0), madeBy: bluePlayer.id),
      Move(dot: Dot(index: 2, row: 0, column: 2), madeBy: bluePlayer.id),
      Move(dot: Dot(index: 10, row: 2, column: 0), madeBy: redPlayer.id),
      Move(dot: Dot(index: 12, row: 2, column: 2), madeBy: redPlayer.id)
    ];

    GameManager manager = GameManager(
        settings: settings1,
        moves: moves,
        player: bluePlayer,
        opponent: redPlayer);

    test('Get Red player best move', () {
      manager.currentTurn = redPlayer;
      manager.board.display(title: 'Initial board');

      BestScore bestScore = manager.current.strategy.think(manager);
      print(bestScore);

      GameManager newManager = manager.play(bestScore.bestMove);
      newManager.board.display(title: 'Final board');
      //expect(score, -3.0);
    });

    test('Get Blue player best move', () {
      manager.currentTurn = bluePlayer;
      manager.board.display(title: 'Initial board');

      BestScore bestScore = manager.current.strategy.think(manager);
      print(bestScore);
      manager.play(bestScore.bestMove);
      manager.board.display(title: 'Final board');
      //expect(score, -3.0);
    });
  });
  */
}
