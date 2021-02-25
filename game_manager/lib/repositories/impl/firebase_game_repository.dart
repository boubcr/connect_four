import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_manager/entities/entities.dart';
import 'package:game_manager/game_manager.dart';
import 'package:game_manager/models/game.dart';
import 'package:game_manager/repositories/repositories.dart';
import 'package:game_manager/utils/mapper.dart';

class FirebaseGameRepository implements GameRepository {
  final gameCollection = FirebaseFirestore.instance.collection('games');

  final PlayerRepository playerRepository;
  FirebaseGameRepository({this.playerRepository}) : super();

  @override
  Future<void> addNewGame(Game game) {
    // TODO: implement addNewGame
    throw UnimplementedError();
  }

  @override
  Future<void> deleteGame(Game game) {
    // TODO: implement deleteGame
    throw UnimplementedError();
  }

  @override
  Stream<List<Game>> games() {
    // TODO: implement games
    throw UnimplementedError();
  }

  @override
  Future<void> saveGame(Game game) {
    // TODO: implement saveGame
    throw UnimplementedError();
  }

  @override
  Future<void> updateGame(Game game) {
    // TODO: implement updateGame
    throw UnimplementedError();
  }

  @override
  Stream<List<Game>> userGames(String userId) {
    // TODO: implement userGames
    throw UnimplementedError();
  }

  @override
  Future<void> createGame(GameManager manager) {
    GameEntity game = Mapper.toGameEntity(manager);
    return gameCollection.doc(game.id).set(game.toDocument()).then((doc) {
      print("Game ${game.id} Added");
      playerRepository.addPlayer(game.id, manager.player);
      playerRepository.addPlayer(game.id, manager.opponent);
    }).catchError((error) {
      print("Failed to add game: $error");
    });
  }

  /*
  @override
  Stream<List<Game>> userGames(String userId) {
    return gameCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Game.fromEntity(GameEntity.fromSnapshot(doc));
      }).toList();
    });
  }

  @override
  Stream<List<Game>> games() {
    return gameCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Game.fromEntity(GameEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> saveGame(Game game) {
    return gameCollection.doc(game.id).set(game.toEntity().toDocument()).then((doc) {
      print("Game ${game.id} Added");
    }).catchError((error) {
      print("Failed to add game: $error");
    });
  }

  @override
  Future<void> addNewGame(Game game) {
    return gameCollection.add(game.toEntity().toDocument()).then((doc) {
      print("Game ${doc.id} Added");
    }).catchError((error) {
      print("Failed to add game: $error");
    });
  }

  @override
  Future<void> updateGame(Game update) {
    return gameCollection
        .doc(update.id)
        .update(update.toEntity().toDocument())
        .then((value) => print("Game Updated"))
        .catchError((error) => print("Failed to update game: $error"));
  }

  @override
  Future<void> deleteGame(Game game) async {
    return gameCollection
        .doc(game.id)
        .delete()
        .then((value) => print("Game Deleted"))
        .catchError((error) => print("Failed to delete game: $error"));
  }
  */

}
