import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_manager/models/models.dart';

class MoveEntity extends Equatable {
  MoveEntity(
      {this.id,
        this.notation,
        this.dot,
        this.madeBy,
        this.createdAt});

  final String id;
  final int notation;
  final Dot dot;
  final String madeBy;
  final DateTime createdAt;

  @override
  List<Object> get props => [id, dot, madeBy, notation, createdAt];

  @override
  String toString() {
    return 'Move { '
        'id: $id, '
        'madeBy: $madeBy, '
        'dot: $dot, '
        'notation: $notation, '
        'createdAt: $createdAt }';
  }

  static MoveEntity fromSnapshot(DocumentSnapshot snap) {
    final map = snap.data();
    return MoveEntity(
        id: snap.id,
        madeBy: map['madeBy'],
        dot: Dot.fromJson(map['dot']),
        notation: map['notation'],
        //createdAt: map['createdAt']
    );
  }

  Map<String, Object> toDocument() {
    return {
      'id': id,
      'madeBy': madeBy,
      'notation': notation,
      'dot': dot.toJson(),
      'createdAt': createdAt
    };
  }
}
