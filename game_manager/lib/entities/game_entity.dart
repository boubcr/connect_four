import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_manager/game_manager.dart';

class GameEntity extends Equatable {
  final String id;
  final String userId;
  final DateTime startTime;
  final DateTime endTime;
  final int maxPlayers;
  final int moveTimeLimit;
  final BoardSettings settings;
  final String status;

  GameEntity(
      {this.id,
      this.userId,
      this.endTime,
      this.maxPlayers = 2,
      this.moveTimeLimit = 0,
      this.settings,
      this.status,
      DateTime startTime})
      : this.startTime = startTime ?? DateTime.now();

  @override
  List<Object> get props => [
        id,
        userId,
        startTime,
        endTime,
        maxPlayers,
        moveTimeLimit,
    settings,
        status
      ];

  @override
  String toString() {
    return 'GameEntity { '
        'startTime: $startTime, '
        'endTime: $endTime, '
        'maxPlayers: $maxPlayers, '
        'moveTimeLimit: $moveTimeLimit, '
        'dimension: $settings, '
        'status: $status, '
        'userId: $userId, '
        'id: $id }';
  }

  static GameEntity fromSnapshot(DocumentSnapshot snap) {
    final map = snap.data();
    return GameEntity(
        id: snap.id,
        userId: map['userId'],
        startTime: map['startTime']?.toDate(),
        endTime: map['endTime']?.toDate(),
        maxPlayers: map['maxPlayers'],
        moveTimeLimit: map['moveTimeLimit'],
        settings: BoardSettings.fromJson(map['settings']),
        status: map['status']);
  }

  Map<String, Object> toDocument() {
    return {
      'userId': userId,
      'startTime': startTime,
      'endTime': endTime,
      'maxPlayers': maxPlayers,
      'moveTimeLimit': moveTimeLimit,
      'settings': settings?.toJson(),
      'status': status
    };
  }
}
