import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_manager/entities/entities.dart';
import 'package:game_manager/models/models.dart';
import 'package:game_manager/repositories/repositories.dart';

class FirebaseMoveRepository implements MoveRepository {
  final collection = FirebaseFirestore.instance.collection('games');

  @override
  Stream<List<Move>> gameMoves(String gameId) {
    return _getCollection(gameId).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Move.fromEntity(MoveEntity.fromSnapshot(doc)))
          .toList();
    });
    /*return FirebaseFirestore.instance
        .collectionGroup('moves')
        .where('gameId', isEqualTo: gameId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Move.fromEntity(MoveEntity.fromSnapshot(doc)))
          .toList();
    });*/
  }

  @override
  Future<void> addMove(String gameId, Move dto) {
    return _getCollection(gameId)
        .doc(dto.id)
        .set(dto.toEntity().toDocument())
        .then((doc) {
      print("Move ${dto.id} Saved");
    }).catchError((error) {
      print("Failed to add game: $error");
    });
  }

  @override
  Future<void> deleteMove(Move dto) {
    // TODO: implement deleteMove
    throw UnimplementedError();
  }

  @override
  Stream<List<Move>> moves(String gameId, String participantId) {
    // TODO: implement moves
    throw UnimplementedError();
  }

  @override
  Future<void> updateMove(Move dto) {
    // TODO: implement updateMove
    throw UnimplementedError();
  }

  /*
  @override
  Stream<List<Move>> gameMoves(String gameId) {
    return FirebaseFirestore.instance
        .collectionGroup('moves')
        .where('gameId', isEqualTo: gameId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Move.fromEntity(MoveEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Stream<List<Move>> moves(String gameId, String participantId) {
    Stream<List<Move>> stream = FirebaseFirestore.instance
        .collectionGroup('moves')
        .where('gameId', isEqualTo: gameId)
        //.where('participantId', isEqualTo: participantId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Move.fromEntity(MoveEntity.fromSnapshot(doc)))
          .toList();
    });

    Stream<List<Move>> stream1 =
        _getCollection(gameId, participantId).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Move.fromEntity(MoveEntity.fromSnapshot(doc)))
          .toList();
    });

    return stream;
  }

  @override
  Future<void> addMove(Move dto) {
    return _getCollection(dto.gameId, dto.participant.id)
        .add(dto.toEntity().toDocument())
        .then((doc) {
      print("Move ${doc.id} Added");
    }).catchError((error) => print("Failed to add move: $error"));
  }

  @override
  Future<void> deleteMove(Move dto) async {
    return _getCollection(dto.gameId, dto.participant.id)
        .doc(dto.id)
        .delete()
        .then((value) => print("Move Deleted"))
        .catchError((error) => print("Failed to delete game: $error"));
  }

  @override
  Future<void> updateMove(Move dto) {
    return _getCollection(dto.gameId, dto.participant.id)
        .doc(dto.id)
        .update(dto.toEntity().toDocument())
        .then((value) => print("Move Updated"))
        .catchError((error) => print("Failed to update move: $error"));
  }

  CollectionReference _getCollection(String gameId, String participantId) {
    return collection
        .doc(gameId)
        .collection('participants')
        .doc(participantId)
        .collection('moves');
  }

   */

  CollectionReference _getCollection(String gameId) {
    return collection.doc(gameId).collection('moves');
  }
}
