import 'package:game_manager/models/models.dart';

class BestScore {
  BestScore({this.value, this.move});
  final double value;
  final Move move;

  BestScore maxScore(BestScore score) {
    if (score.value > value) {
      return score;
    }
    return this;
  }

  BestScore minScore(BestScore score) {
    if (score.value < value) {
      return score;
    }
    return this;
  }

  @override
  String toString() {
    return 'Best { '
        'value: $value, '
        'move: ${move?.id} }';
  }
}