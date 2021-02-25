import 'package:game_manager/ai/ai.dart';
import 'package:game_manager/game_manager.dart';

enum StrategyType {
  NAIVE,
  MINI_MAX,
  EVALUATION
}

/// Strategies for participants
abstract class Strategy {
  const Strategy();

  //Think up a place to move
  //Move generator
  Future<BestScore> think(GameManager manager);
}