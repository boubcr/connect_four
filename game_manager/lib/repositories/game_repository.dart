import 'dart:async';

import 'package:game_manager/game_manager.dart';
import 'package:game_manager/models/models.dart';

abstract class GameRepository {

  final PlayerRepository playerRepository;
  GameRepository({this.playerRepository});

  Stream<List<Game>> games();

  Future<void> createGame(GameManager manager);

  Stream<List<Game>> userGames(String userId);

  Future<void> addNewGame(Game game);

  Future<void> saveGame(Game game);

  Future<void> deleteGame(Game game);

  Future<void> deleteUserGames(String email);

  Future<void> updateGame(Game game);
}