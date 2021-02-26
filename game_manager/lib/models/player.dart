import 'package:equatable/equatable.dart';
import 'package:game_manager/ai/ai.dart';
import 'package:game_manager/ai/strategy/strategy.dart';
import 'package:game_manager/ai/strategy/naive_strategy.dart';
import 'package:game_manager/models/models.dart';
import 'package:game_manager/entities/entities.dart';
import 'package:game_manager/utils/utils.dart';

class Score {
  int value;
  bool increased;
  Score({this.value = 0, this.increased = false});

  void update(int notation) {
    this.increased = notation != this.value;
    this.value = notation;
  }

  @override
  String toString() {
    return 'Player { '
        'value: $value, '
        'increased: $increased, }';
  }
}

class Player extends Equatable {
  final String id;
  final String name;
  final String avatar;
  final Score score;
  final Mark mark;
  final int color;
  final List<Move> moves;
  final Strategy strategy;

  Player(
      {String id,
      Score score,
      this.name,
      this.avatar,
      this.mark,
      this.color,
      this.strategy,
      List<Move> moves})
      : this.id = id,
        this.score = score ?? Score(),
        this.moves = moves ?? [];

  void play(Move move) {
    /// Add move to player move list
    print('Player $name is playing move ${move.id}');
    this.moves.add(move);
  }

  Player copyWith(
      {String name, String avatar, Strategy strategy}) {
    return Player(
        id: this.id,
        score: this.score,
        mark: this.mark,
        color: this.color,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
        strategy: strategy ?? this.strategy,
        moves: List.from(this.moves));
  }

  bool isCurrent(String id) => this.id == id;
  //bool get isAi => Enum.getEnum(PlayerType.values, this.id) != null;
  bool get isAi => this.strategy != null;

  @override
  List<Object> get props =>
      [id, name, avatar, score, mark, color, moves, strategy];

  @override
  String toString() {
    return 'Player { '
        'id: $id, '
        'name: $name, '
        'score: $score, '
        'mark: ${Enum.getValue(mark)}, '
        'color: $color, '
        'avatar: $avatar, '
        'moves: $moves, '
        'strategy: ${Enum.getValue(strategy)} }';
  }

  PlayerEntity toEntity() {
    StrategyType strategyType;
    if (strategy is NaiveStrategy)
      strategyType = StrategyType.NAIVE;
    else if (strategy is MiniMaxStrategy)
      strategyType = StrategyType.MINI_MAX;

    return PlayerEntity(
        id: id,
        name: name,
        score: score.value,
        mark: mark,
        color: color,
        strategyType: strategyType,
        moves: moves,
        avatar: avatar);
  }

  static Player fromEntity(PlayerEntity entity) {
    Strategy strategy;
    switch (entity.strategyType) {
      case StrategyType.NAIVE:
        strategy = NaiveStrategy();
        break;
      case StrategyType.MINI_MAX:
        strategy = MiniMaxStrategy();
        break;
      default:
        break;
    }

    return Player(
      id: entity.id,
      name: entity.name,
      score: Score(value: entity.score),
      mark: entity.mark,
      color: entity.color,
      strategy: strategy,
    );
  }
}
