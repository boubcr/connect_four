import 'package:equatable/equatable.dart';
import 'package:game_manager/game_manager.dart';

abstract class PlayersEvent extends Equatable {
  const PlayersEvent();

  @override
  List<Object> get props => [];
}

class PlayersLoading extends PlayersEvent {}

class PlayerAdded extends PlayersEvent {
  final Player participant;

  const PlayerAdded(this.participant);

  @override
  List<Object> get props => [participant];

  @override
  String toString() => 'PlayerAdded { participant: $participant }';
}

class PlayerUpdated extends PlayersEvent {
  final Player participant;

  const PlayerUpdated(this.participant);

  @override
  List<Object> get props => [participant];

  @override
  String toString() => 'PlayerUpdated { participant: $participant }';
}

class PlayerDeleted extends PlayersEvent {
  final Player participant;

  const PlayerDeleted(this.participant);

  @override
  List<Object> get props => [participant];

  @override
  String toString() => 'PlayerDeleted { participant: $participant }';
}

class PlayerSelected extends PlayersEvent {
  final String id;

  const PlayerSelected(this.id);

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'PlayerSelected { id: $id }';
}

////////////////////////////////////////////////////////////////////////////////
class AddPlayers extends PlayersEvent {
  final Game game;

  const AddPlayers({List<Player> participants, Game game})
      : this.game = game ?? null;

  @override
  List<Object> get props => [game];

  @override
  String toString() => 'AddPlayers { game: $game }';
}

class PlayersUpdated extends PlayersEvent {
  final List<Player> participants;

  const PlayersUpdated(this.participants);

  @override
  List<Object> get props => [participants];

  @override
  String toString() => 'PlayersUpdated { participants: $participants }';
}

class PlayerSwitch extends PlayersEvent {
  final Move move;

  const PlayerSwitch(this.move);

  @override
  List<Object> get props => [move];

  @override
  String toString() => 'PlayerSwitch { move: $move }';
}