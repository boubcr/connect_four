import 'package:equatable/equatable.dart';
import 'package:game_manager/game_manager.dart';

abstract class GamesState extends Equatable {
  const GamesState();

  @override
  List<Object> get props => [];
}

class GamesLoadInProgress extends GamesState {}

class GamesLoadSuccess extends GamesState {
  final List<Game> games;

  const GamesLoadSuccess(this.games);

  @override
  List<Object> get props => [games];

  @override
  String toString() => 'GamesLoadSuccess { games: $games }';
}

class GamesLoadFailure extends GamesState {}

class GameAddSuccess extends GamesState {
  final Game game;

  const GameAddSuccess(this.game);

  @override
  List<Object> get props => [game];

  @override
  String toString() => 'GameAddSuccess { game: $game }';
}

class GameLoadedSuccess extends GamesState {
  final GameManager manager;

  const GameLoadedSuccess(this.manager);

  @override
  List<Object> get props => [manager];

  @override
  String toString() => 'GameLoadedSuccess { manager: $manager }';
}

class GameLoadedFailure extends GamesState {}

class DimensionUpdateSuccess extends GamesState {
  final BoardSettings dimension;

  const DimensionUpdateSuccess(this.dimension);

  @override
  List<Object> get props => [dimension];

  @override
  String toString() => 'DimensionUpdateSuccess { dimension: $dimension }';
}

class GameBoardUpdatedSuccess extends GamesState {
  final BoardSettings dimension;
  final int color;
  final DotStyle dotStyle;

  const GameBoardUpdatedSuccess({this.dimension, this.color, this.dotStyle});

  @override
  List<Object> get props => [dimension, color, dotStyle];

  @override
  String toString() => 'GameBoardUpdatedSuccess { dimension: $dimension, color: $color, dotStyle: $dotStyle }';
}