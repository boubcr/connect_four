import 'dart:async';
import 'package:game_manager/models/models.dart';

abstract class PlayerRepository {

  Stream<List<Player>> players(String gameId);

  Future<void> addPlayer(String gameId, Player player);

  Future<void> saveParticipant(Player dto);

  Future<void> addParticipant(Player dto);

  Future<void> updateParticipant(Player dto);

  Future<void> deleteParticipant(Player dto);

  Future<void> deleteParticipants(String game);

  Future saveParticipants(List<Player> dtos);
}