import 'package:equatable/equatable.dart';
import 'package:game_manager/game_manager.dart';

abstract class PlayersState extends Equatable {
  const PlayersState();

  @override
  List<Object> get props => [];
}

class PlayersLoadInProgress extends PlayersState {}

class PlayersLoadSuccess extends PlayersState {
  final List<Player> participants;

  const PlayersLoadSuccess(
      {List<Player> participants, Player selected})
      : this.participants = participants ?? null;

  @override
  List<Object> get props => [participants];

  @override
  String toString() => 'PlayersLoadSuccess { participants: $participants}';
}

class PlayersLoadFailure extends PlayersState {}
