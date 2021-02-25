import 'package:game_manager/entities/entities.dart';
import 'package:game_manager/models/models.dart';

/// Move
class Move {
  Move(
      {String id, this.dot, this.notation = 0, this.madeBy, this.index = 0, DateTime createdAt})
      : this.id = id ?? dot.id,
        this.createdAt = DateTime.now();

  final String id;
  final Dot dot;
  final String madeBy;
  final DateTime createdAt;
  final int notation;
  final int index; /// Play index in all moves

  //void incrementNotation() => this.notation++;

  Move copyWith(
      {String id, int notation, String madeBy, DateTime createdAt, Dot dot, int index}) {
    return Move(
        id: id ?? this.id,
        index: index ?? this.index,
        notation: notation ?? this.notation,
        madeBy: madeBy ?? this.madeBy,
        createdAt: createdAt ?? this.createdAt,
        dot: dot ?? this.dot);
  }

  @override
  String toString() {
    return 'Move { '
        'id: $id, '
        'index: $index, '
        'notation: $notation, '
        'madeBy: $madeBy, '
        'dot: $dot,'
        'createdAt: $createdAt }';
  }

  MoveEntity toEntity() {
    return MoveEntity(
        id: id,
        dot: dot,
        notation: notation,
        createdAt: createdAt,
        madeBy: madeBy);
  }

  static Move fromEntity(MoveEntity entity) {
    return Move(
      id: entity.id,
      madeBy: entity.madeBy,
      notation: entity.notation,
      dot: entity.dot,
      createdAt: entity.createdAt,
    );
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'dot': dot?.toJson(),
      'notation': notation,
      'madeBy': madeBy,
      'createdAt': createdAt
    };
  }

  static Move fromJson(Map<String, Object> json) {
    if (json == null) return Move();

    return Move(
      id: json['id'],
      dot: Dot.fromJson(json['dot']),
      notation: json['notation'] as int,
      //createdAt: json['createdAt'] as DateTime
    );
  }
}
