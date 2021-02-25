import 'dart:math';
import 'package:game_manager/game_manager.dart';
import 'package:game_manager/ai/ai.dart';
import 'package:game_manager/models/models.dart';

/// Naive/Stupid strategy just finds a random empty dot and plays it
class NaiveStrategy extends Strategy {

  @override
  Future<BestScore> think(GameManager manager) async {
    List<Dot> availableDots = manager.board.availableDots;
    if (availableDots.isEmpty)
      return null;

    Dot randomDot = availableDots[Random().nextInt(availableDots.length)];
    return BestScore(move: Move(dot: randomDot));
  }
}