import 'package:game_manager/ai/ai.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_manager/ai/strategy/alpha_beta_pruning_strategy.dart';
import 'package:game_manager/game_manager.dart';
import 'package:game_manager/logger.dart';
import 'package:game_manager/models/models.dart';

import 'test_utils.dart';

/// PX : Blue Player
/// PY : Best Move
void main() {
  initRootLogger();
  DisplayBoard display = DisplayBoard(show: true, testing: true);

  group('AlphaBetaPruningStrategy 01', () {
    test('Alpha Beta Pruning 001', () {
      Player pxMin = TestUtils.pxBlue.copyWith(strategy: AlphaBetaPruningStrategy(depth: 2));
      Player pyRnd = TestUtils.pyRed.copyWith(strategy: AlphaBetaPruningStrategy(depth: 2));
      GameManager manager = GameManager(
          display: display,
          settings: BoardSettings(rows: 5, columns: 5),
          player: pxMin,
          opponent: pyRnd,
          current: pyRnd,
          moves: [
            Move(dot: Dot(row: 2, column: 2), madeBy: pyRnd.id),
            Move(dot: Dot(row: 4, column: 2), madeBy: pyRnd.id),
            Move(dot: Dot(row: 6, column: 2), madeBy: pyRnd.id),
            Move(dot: Dot(row: 4, column: 4), madeBy: pxMin.id),
            Move(dot: Dot(row: 6, column: 4), madeBy: pxMin.id),
            Move(dot: Dot(row: 6, column: 6), madeBy: pxMin.id)
          ]);

      print('Current player testing: ${manager.current.mark}');
      manager.board.display(title: 'Initial board', show: true);
      manager.current.strategy.think(manager).then((bestScore) {
        print(bestScore);
        GameManager newManager = manager.play(bestScore.move);
        newManager.board.display(title: 'Final board', show: true);
        //expect(score, -3.0);
      });
    });

    test('ABPruning vs ABPruning 001', () async {
      Player pxMin = TestUtils.pxBlue.copyWith(strategy: AlphaBetaPruningStrategy(depth: 2));
      //Player pxMin = TestUtils.pxBlue.copyWith(strategy: NaiveStrategy());
      Player pyRnd = TestUtils.pyRed.copyWith(strategy: AlphaBetaPruningStrategy(depth: 2));

      GameManager manager = GameManager(
          display: display,
          settings: BoardSettings(rows: 5, columns: 5),
          player: pxMin,
          opponent: pyRnd,
          current: pyRnd,
          moves: [
            Move(dot: Dot(row: 2, column: 2), madeBy: pxMin.id),
            Move(dot: Dot(row: 4, column: 2), madeBy: pxMin.id),
            Move(dot: Dot(row: 6, column: 2), madeBy: pxMin.id),
            Move(dot: Dot(row: 4, column: 4), madeBy: pyRnd.id),
            Move(dot: Dot(row: 6, column: 4), madeBy: pyRnd.id),
            Move(dot: Dot(row: 6, column: 6), madeBy: pyRnd.id)
          ]);

      manager.board.display(title: 'Initial board', show: true);
      await TestUtils.playing(manager: manager, turn: 5);
    });

    test('MiniMax vs ABPruning', () async {
      Player minMax = TestUtils.pxBlue.copyWith(strategy: MiniMaxStrategy(depth: 1));
      Player alphaBeta = TestUtils.pyRed.copyWith(strategy: AlphaBetaPruningStrategy(depth: 1));

      GameManager manager = GameManager(
          display: display,
          settings: BoardSettings(rows: 4, columns: 3),
          player: minMax,
          opponent: alphaBeta,
          current: alphaBeta,
          moves: [
            /*Move(dot: Dot(row: 2, column: 2), madeBy: minMax.id),
            Move(dot: Dot(row: 4, column: 2), madeBy: minMax.id),
            Move(dot: Dot(row: 6, column: 2), madeBy: minMax.id),
            Move(dot: Dot(row: 4, column: 4), madeBy: alphaBeta.id),
            Move(dot: Dot(row: 6, column: 4), madeBy: alphaBeta.id),
            Move(dot: Dot(row: 6, column: 6), madeBy: alphaBeta.id)*/
          ]);

      manager.board.display(title: 'Initial board', show: true);
      await TestUtils.playing(manager: manager, turn: 6);
    });

  });
}
