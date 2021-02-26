import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_manager/entities/entities.dart';
import 'package:game_manager/models/player.dart';
import 'package:game_manager/repositories/repositories.dart';

class FirebasePlayerRepository implements PlayerRepository {
  final collection = FirebaseFirestore.instance.collection('games');

  @override
  Future<void> addParticipant(Player dto) {
    // TODO: implement addParticipant
    throw UnimplementedError();
  }

  @override
  Future<void> deleteParticipant(Player dto) {
    // TODO: implement deleteParticipant
    throw UnimplementedError();
  }

  @override
  Stream<List<Player>> players(String gameId) {
    return _getCollection(gameId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Player.fromEntity(PlayerEntity.fromSnapshot(doc));
      }).toList();
    });
  }

  @override
  Future<void> saveParticipant(Player dto) {
    // TODO: implement saveParticipant
    throw UnimplementedError();
  }

  @override
  Future saveParticipants(List<Player> dtos) {
    // TODO: implement saveParticipants
    throw UnimplementedError();
  }

  @override
  Future<void> updateParticipant(Player dto) {
    // TODO: implement updateParticipant
    throw UnimplementedError();
  }

  @override
  Future<void> addPlayer(String gameId, Player player) {
    return _getCollection(gameId)
        .doc(player.id)
        .set(player.toEntity().toDocument())
        .then((doc) {
      print("Player ${player.id} Saved");
    }).catchError((error) {
      print("Failed to add game: $error");
    });
  }

  @override
  Future<void> deleteParticipants(String game) {
    return _getCollection(game).get().then((snap) {
      snap.docs.forEach((doc) async {
        String id = doc.id;
        await doc.reference.delete();
      });
    });
  }

  /*
  @override
  Stream<List<Participant>> participants(String gameId) {
    Stream<List<Participant>> stream =
        _getCollection(gameId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Participant.fromEntity(ParticipantEntity.fromSnapshot(doc));
      }).toList();
    });

    return stream;
  }

  @override
  Future<void> addParticipant(Participant dto) {
    return _getCollection(dto.gameId)
        .add(dto.toEntity().toDocument())
        .then((doc) {
      print("Participant ${doc.id} Added");
    }).catchError((error) => print("Failed to add game: $error"));
  }

  @override
  Future<void> updateParticipant(Participant update) {
    return _getCollection(update.gameId)
        .doc(update.id)
        .update(update.toEntity().toDocument())
        .then((doc) {
      print("Participant ${update.id} Updated");
    }).catchError((error) => print("Failed to update game: $error"));
  }

  @override
  Future<void> deleteParticipant(Participant dto) async {
    return _getCollection(dto.gameId)
        .doc(dto.id)
        .delete()
        .then((value) => print("Participant Deleted"))
        .catchError((error) => print("Failed to delete game: $error"));
  }

  @override
  Future<void> saveParticipant(Participant dto) {
    return _getCollection(dto.gameId).doc(dto.playerId).set(dto.toEntity().toDocument()).then((doc) {
      print("Participant ${dto.id} Saved");
    }).catchError((error) {
      print("Failed to add game: $error");
    });
  }

  // Persists to local disk and the web
  @override
  Future<void> saveParticipants(List<Participant> participants) {
    return Future.wait<void>(
        participants.map((dto) => saveParticipant(dto)).toList());
  }
  
   */
  CollectionReference _getCollection(String gameId) {
    return collection.doc(gameId).collection('players');
  }

}
