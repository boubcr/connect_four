import 'package:flutter/material.dart';
import 'package:game_manager/ai/strategy/evaluation_strategy.dart';
import 'package:game_manager/ai/strategy/naive_strategy.dart';
import 'package:game_manager/game_manager.dart';
import 'package:game_manager/models/models.dart';

class TestUtils {
  static Player get pxBlue => Player(
        id: Enum.getValue(Mark.PX),
        name: 'PX-Blue',
        mark: Mark.PX,
        strategy: NaiveStrategy(), // EvaluationStrategy(),
        color: Colors.blue.value,
      );

  static Player get pyRed => Player(
        id: Enum.getValue(Mark.PY),
        name: 'PY-Red',
        mark: Mark.PY,
        strategy: EvaluationStrategy(),
        color: Colors.red.value,
      );

  static simulateGame(
      {BoardSettings settings,
      int nbTurn,
      Player redPlayer,
      Player bluePlayer,
      Player starter}) {

    GameManager manager = GameManager(
        settings: settings,
        player: bluePlayer,
        opponent: redPlayer,
        current: starter);

    Iterable.generate(nbTurn * 2).forEach((element) {
      manager = playBestMove(manager);
    });
  }

  static Future<void> playing({GameManager manager, int turn}) async {
    print('turn: $turn');
    if (turn == 0) {
      manager.board.display(title: 'Final board', show: true);
      return;
    }

    GameManager firstPlayerMove = await TestUtils.findAndPlayBestMove(manager);
    GameManager secondPlayerMove = await TestUtils.findAndPlayBestMove(firstPlayerMove);
    await playing(manager: secondPlayerMove, turn: turn - 1);
  }

  static Future<GameManager> findAndPlayBestMove(GameManager manager) async {
    //print('>> Player ${manager.current.mark} start playing');
    //manager.board.display(title: 'Initial board', show: true);
    BestScore bestScore = await manager.current.strategy.think(manager);
    GameManager newManager = manager.play(bestScore.move);
    //newManager.board.display(title: 'Final board', show: true);
    //print('>> Player ${manager.current.mark} end playing');
    return newManager;
  }

  static GameManager playBestMove(GameManager manager) {
    //BestScore bestScore = manager.current.strategy.think(manager);
    //return manager.play(bestScore.bestMove, display: true);
    return null;
  }
}
