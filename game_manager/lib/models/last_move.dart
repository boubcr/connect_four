import 'package:equatable/equatable.dart';

class LastMove extends Equatable {
  final String id;
  final int notation;
  final int color;
  final List<String> squares;
  LastMove({this.id, this.notation = 0, this.color, List<String> squares})
      : this.squares = squares ?? [];

  LastMove copyWith({String id, int notation, int color, List<String> squares}) =>
      LastMove(
          id: id ?? this.id,
          color: color ?? this.color,
          notation: notation ?? this.notation,
          squares: squares ?? this.squares);

  void addSquares(String id) {
    this.squares.add(id);
  }

  @override
  List<Object> get props => [id, notation, color, squares];

  @override
  String toString() {
    return 'Dot { id: $id, notation: $notation, color: $color, squares: $squares }';
  }
}
