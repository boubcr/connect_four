import 'package:game_manager/ai/ai.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_manager/ai/board_state.dart';
import 'package:game_manager/game_manager.dart';
import 'package:game_manager/models/models.dart';
import 'package:game_manager/ai/evaluator.dart';

import 'test_utils.dart';

/// BP : Blue Player
/// BM : Best Move
void main() {
  DisplayBoard display = DisplayBoard(show: true, testing: true);
  BoardSettings settings1 = BoardSettings(rows: 3, columns: 3);
  BoardSettings settings2 = BoardSettings(rows: 4, columns: 4);

  group('Evaluation strategy 01', () {
    Player bluePlayer =
        TestUtils.bluePlayer.clone(strategy: EvaluationStrategy());
    Player redPlayer =
        TestUtils.redPlayer.clone(strategy: EvaluationStrategy());

    List<Move> moves = [];

    test('Get Red player score on 3x3', () {
      GameManager manager = GameManager(
          display: display,
          settings: BoardSettings(rows: 4, columns: 4),
          player: bluePlayer,
          opponent: redPlayer,
          current: redPlayer,
          moves: [
            Move(dot: Dot(row: 0, column: 0), madeBy: bluePlayer.id),
            Move(dot: Dot(row: 0, column: 2), madeBy: bluePlayer.id),
            Move(dot: Dot(row: 2, column: 0), madeBy: bluePlayer.id),
            Move(dot: Dot(row: 0, column: 4), madeBy: redPlayer.id),
            Move(dot: Dot(row: 0, column: 6), madeBy: redPlayer.id),
            Move(dot: Dot(row: 2, column: 4), madeBy: redPlayer.id)
          ]);

      manager.board.display(title: 'Initial board');

      manager.current.strategy.think(manager).then((bestScore) {
        print(bestScore);
        GameManager newManager = manager.play(bestScore.bestMove);
        newManager.board.display(title: 'Final board');
        //expect(score, -3.0);
      });
    });

    /*test('Get Blue player score on 3x3', () {
      manager.currentTurn = bluePlayer;
      manager.board.display(title: 'Initial board');

      BestScore bestScore = manager.current.strategy.think(manager);
      print(bestScore);

      GameManager newManager = manager.play(bestScore.bestMove);
      newManager.board.display(title: 'Final board');
      //expect(score, -3.0);
    });*/
  });
}
