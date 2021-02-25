import 'package:connect_four/utils/app_keys.dart';
import 'package:connect_four/players/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:game_manager/game_manager.dart';

class DisplayPlayers extends StatelessWidget {
  final GameManager game;
  DisplayPlayers({Key key, @required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildContents(context);
  }

  Widget _buildContents(BuildContext context) {
    Player first = game.player;
    Player second = game.opponent;

    return Container(
      //height: 100,
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                //decoration: const BoxDecoration(color: Colors.white),
                child: PlayerCard(
                    key: AppKeys.playerCard,
                    participant: first,
                    isPlaying: first.id == game.current.id),
              ),
              flex: 1,
            ),
            Expanded(
              child: _buildTurnIndicator(context, game.current),
              flex: 2,
            ),
            Expanded(
              child: Container(
                //decoration: const BoxDecoration(color: Colors.white),
                child: PlayerCard(
                    key: AppKeys.opponentCard,
                    onRight: true,
                    participant: second,
                    isPlaying: second.id == game.current.id),
              ),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTurnIndicator(BuildContext context, Player current) {
    final theme = Theme.of(context);
    return Container(
      //decoration: const BoxDecoration(color: Colors.blue),
      height: 35,
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: theme.primaryColorLight,
          borderRadius: BorderRadius.circular(10),
          /*boxShadow: [
            BoxShadow(
                color: theme.primaryColorDark,
                offset: Offset(0, 0),
                blurRadius: 20),
          ]*/),
      child: Center(
          child: Text('${current.name}',
              style: TextStyle(fontSize: 18))),
    );
  }

  /*
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParticipantsBloc, ParticipantsState>(
      builder: (context, state) {
        if (state is ParticipantsLoadSuccess) {
          Participant first = state.participants.first;
          Participant second = state.participants.last;

          return Container(
            height: 60,
            width: double.maxFinite,
            decoration: BoxDecoration(
                color: Colors.tealAccent,
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(20.0))),
            child: Padding(
              //padding: EdgeInsets.all(20.0),
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ParticipantCard(first),
                  Text('vs'),
                  ParticipantCard(second),
                ],
              ),
            ),
          );
        }
        return Container(
          child: Text('loading'),
        );
      },
    );
  }*/
}
