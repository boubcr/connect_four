import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connect_four/players/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:game_manager/game_manager.dart';
import 'package:connect_four/game/game.dart';

class PlayersBloc extends Bloc<PlayersEvent, PlayersState> {
  List<Player> participants = [];
  //ParticipantsBloc() : super(ParticipantsLoadInProgress());
  //Participant selectedParticipant;

  StreamSubscription _pptsRepoSubscription;

  final PlayerRepository repository;
  final GamesBloc gamesBloc;
  StreamSubscription _gamesSubscription;

  PlayersBloc({@required this.gamesBloc, @required this.repository})
      : super(PlayersLoadInProgress()) {
    _gamesSubscription = gamesBloc.listen((state) {
      print('PlayerBloc => Game listener');
      if (state is GameAddSuccess) {
        print('Game listener => A new game is added!!');
        print('Game listener => Add participants!!');
        //add(ParticipantsUpdated(state.game.participants));
        add(AddPlayers(game: state.game));
      }
    });
  }

  @override
  Stream<PlayersState> mapEventToState(PlayersEvent event) async* {
    /*if (event is AddPlayers) {
      yield* _mapPlayersAddedToState(event);
    } else if (event is PlayersLoading) {
      yield* _mapPlayersLoadedToState();
    } else if (event is PlayerAdded) {
      yield* _mapPlayerAddedToState(event);
    } else if (event is PlayerUpdated) {
      yield* _mapPlayerUpdatedToState(event);
    } else if (event is PlayerDeleted) {
      yield* _mapPlayerDeletedToState(event);
    } else if (event is PlayerSelected) {
      yield* _mapPlayerSelectedToState(event);
    } else if (event is PlayersUpdated) {
      yield* _mapPlayersUpdateToState(event);
    } else if (event is PlayerSwitch) {
      yield* _mapPlayerSwitchToState(event);
    }*/
  }

  /*
  Stream<PlayersState> _mapPlayersAddedToState(
      AddPlayers event) async* {
    print('Players => adding');
    /*
    Participant first = Participant(
        gameId: event.game.id,
        playerId: event.game.userId,
        currentTurn: true,
        color: Color(event.game.playerColor),
        playerInfo: PlayerInfo(name: 'Player 1', avatar: 'link_to_avatar'));
    Participant second = Participant(
        gameId: event.game.id,
        playerId: 'opponent_id',
        currentTurn: false,
        color: Color(event.game.opponentColor),
        playerInfo: PlayerInfo(
            name: 'Opponent',
            avatar: 'link_to_avatar',
            type: PlayerType.COMPUTER));

    List<Participant> participants = [first, second];
    yield ParticipantsLoadSuccess(participants: participants);
    _saveParticipants(participants);
    */
  }

  Stream<PlayersState> _mapPlayersLoadedToState() async* {
    print('Participants => loading');
    if (state is ParticipantsLoadSuccess) {
      List<Participant> participants =
          (state as ParticipantsLoadSuccess).participants;
      /*yield ParticipantsLoadSuccess(participants: participants);
      if ((state as ParticipantsLoadSuccess).currentTurn().player.type ==
          PlayerType.COMPUTER) {
        print('computer turn');
      }*/
    }
  }

  Stream<ParticipantsState> _mapParticipantsUpdateToState(
      ParticipantsUpdated event) async* {
    print('Participants => updated');
    yield ParticipantsLoadSuccess(participants: event.participants);
  }

  Stream<ParticipantsState> _mapParticipantUpdatedToState(
      ParticipantUpdated event) async* {
    print('Participant => updating');
    if (state is ParticipantsLoadSuccess) {
      final List<Participant> updatedParticipants =
          (state as ParticipantsLoadSuccess).participants.map((participant) {
        return participant.id == event.participant.id
            ? event.participant
            : participant;
      }).toList();

      yield ParticipantsLoadSuccess(participants: updatedParticipants);
      //TODO update participant
    }
  }

  Stream<ParticipantsState> _mapParticipantSelectedToState(
      ParticipantSelected event) async* {
    print('Participant => select');
    List<Participant> participants = [];
    if (state is ParticipantsLoadSuccess) {
      participants = (state as ParticipantsLoadSuccess)
          .participants
          .map((e) => e.id == event.id
              ? e.copyWith(currentTurn: true)
              : e.copyWith(currentTurn: false))
          .toList();
      yield ParticipantsLoadSuccess(participants: participants);
      //_saveParticipants(participants);
      //TODO add repo call
    }
  }

  Stream<ParticipantsState> _mapParticipantAddedToState(
      ParticipantAdded event) async* {
    print('Participant => adding');
    if (state is ParticipantsLoadSuccess) {
      final List<Participant> updatedParticipants =
          List.from((state as ParticipantsLoadSuccess).participants)
            ..add(event.participant);
      yield ParticipantsLoadSuccess(participants: updatedParticipants);
      //_saveParticipants(updatedParticipants);
      _saveParticipant(updatedParticipants[0]);
    }
  }

  Stream<ParticipantsState> _mapParticipantDeletedToState(
      ParticipantDeleted event) async* {
    print('Participant => deleting');
    if (state is ParticipantsLoadSuccess) {
      final updatedParticipants = (state as ParticipantsLoadSuccess)
          .participants
          .where((participant) => participant.id != event.participant.id)
          .toList();
      yield ParticipantsLoadSuccess(participants: updatedParticipants);
    }
  }

  Stream<ParticipantsState> _mapParticipantSwitchToState(
      ParticipantSwitch event) async* {
    print('Participant => select');
    List<Participant> participants = [];
    if (state is ParticipantsLoadSuccess) {
      participants = (state as ParticipantsLoadSuccess).participants.map((e) {
        Move move = event.move;
        // Edit the current player
        if (e.id == move.participant.id) {
          return e.copyWith(currentTurn: false, score: e.score + move.notation);
        }

        // Edit the opponent: his turn to play
        return e.copyWith(currentTurn: true);
      }).toList();
      yield ParticipantsLoadSuccess(participants: participants);
      _saveParticipants(participants);
    }
  }

  Future<void> _saveParticipants(List<Participant> participants) {
    return repository.saveParticipants(participants);
  }

  Future _saveParticipant(Participant dto) {
    return repository.addParticipant(dto);
  }

  @override
  Future<void> close() {
    _pptsRepoSubscription?.cancel();
    _gamesSubscription.cancel();
    //movesSubscription.cancel();
    return super.close();
  }
  */
}
