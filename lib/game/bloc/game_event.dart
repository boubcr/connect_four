import 'package:equatable/equatable.dart';
import 'package:game_manager/game_manager.dart';

abstract class GamesEvent extends Equatable {
  final String userId;
  const GamesEvent({String userId}) : this.userId = userId ?? null;

  @override
  List<Object> get props => [userId];
}

class InitGame extends GamesEvent {}

class GamesLoading extends GamesEvent {}

class GamesUpdated extends GamesEvent {
  final List<Game> games;

  const GamesUpdated(this.games);

  @override
  List<Object> get props => [games];

  @override
  String toString() => 'GamesUpdated { games: $games }';
}

class GameAdded extends GamesEvent {
  final BoardSettings dimension;
  final DotStyle dotStyle;
  final int opponentColor;
  final int playerColor;
  final int thinkTime;
  final GameLevel level;
  final GameMode mode;

  const GameAdded(
      {String userId,
      this.dimension,
      this.dotStyle,
      this.thinkTime,
      this.level,
      this.mode,
      this.opponentColor,
      this.playerColor})
      : super(userId: userId);

  @override
  List<Object> get props => [
        userId,
        dimension,
        level,
        mode,
        thinkTime,
        dotStyle,
        opponentColor,
        playerColor
      ];

  @override
  String toString() =>
      'GameAdded { '
          'userId: $userId, '
          'dimension: $dimension, '
          'mode: ${Enum.getValue(mode)}, '
          'level: ${Enum.getValue(level)}, '
          'thinkTime: $thinkTime, '
          'dotStyle: $dotStyle, '
          'opponentColor: $opponentColor, '
          'playerColor: $playerColor }';
}

class GameUpdated extends GamesEvent {
  final GameManager manager;

  const GameUpdated(this.manager);

  @override
  List<Object> get props => [manager];

  @override
  String toString() => 'GameUpdated { manager: $manager }';
}

class GameBoardChanged extends GamesEvent {
  final int rows;
  final int columns;
  final DotStyle dotStyle;
  final int color;

  const GameBoardChanged({this.rows, this.columns, this.color, this.dotStyle});

  @override
  List<Object> get props => [rows, columns, color, dotStyle];

  @override
  String toString() =>
      'GameBoardChanged {rows: $rows, columns: $columns, color: $color,  dotStyle: $dotStyle }';
}

class AddMove extends GamesEvent {
  final Dot dot;

  const AddMove(this.dot);

  @override
  List<Object> get props => [dot];

  @override
  String toString() => 'AddMove { dot: $dot }';
}

class MovesLoading extends GamesEvent {
  final LastMove lastMove;

  const MovesLoading({this.lastMove});

  @override
  List<Object> get props => [lastMove];

  @override
  String toString() => 'MovesLoading { lastMove: $lastMove }';
}

class MakeMove extends GamesEvent {}
