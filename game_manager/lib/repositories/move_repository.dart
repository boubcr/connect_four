import 'dart:async';

import 'package:game_manager/models/models.dart';

abstract class MoveRepository {

  Stream<List<Move>> gameMoves(String gameId);

  Stream<List<Move>> moves(String gameId, String participantId);

  Future<void> addMove(String gameId, Move dto);

  Future<void> deleteMove(Move dto);

  Future<void> updateMove(Move dto);
}