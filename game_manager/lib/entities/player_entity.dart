import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_manager/game_manager.dart';
import 'package:game_manager/models/models.dart';

class PlayerEntity extends Equatable {
  final String id;
  final String name;
  final String avatar;
  final int score;
  final int color;
  final Mark mark;
  final StrategyType strategyType;
  final List<Move> moves;

  PlayerEntity(
      {this.id,
      this.name,
      this.avatar,
      this.score,
      this.color,
      this.mark,
      this.strategyType,
      this.moves});

  @override
  List<Object> get props =>
      [id, name, avatar, score, score, color, mark, strategyType, moves];

  @override
  String toString() {
    return 'Player { '
        'id: $id, '
        'name: $name, '
        'avatar: $avatar, '
        'score: $score, '
        'color: $color, '
        'mark: $mark,'
        'strategyType: $strategyType,'
        'moves: $moves }';
  }

  static PlayerEntity fromSnapshot(DocumentSnapshot snap) {
    final map = snap.data();
    return PlayerEntity(
      id: map['id'],
      name: map['name'],
      avatar: map['avatar'],
      score: map['score'],
      color: map['color'],
      mark: Enum.getEnum(Mark.values, map['mark']),
      strategyType: Enum.getEnum(StrategyType.values, map['strategyType']),
      moves: (map['moves'] as List).map((e) => Move.fromJson(e)).toList(),
    );
  }

  Map<String, Object> toDocument() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'score': score,
      'color': color,
      'mark': Enum.getValue(mark),
      'strategyType': Enum.getValue(strategyType),
      'moves': moves.map((e) => e.toJson()).toList()
    };
  }
}
