import 'package:connect_four/players/bloc/bloc.dart';
import 'package:connect_four/players/participants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_manager/game_manager.dart';

class PlayerCard extends StatelessWidget {
  const PlayerCard(
      {Key key,
      this.thumbnail,
      this.participant,
      this.onRight = false,
      this.isPlaying = false})
      : super(key: key);

  final bool onRight;
  final Widget thumbnail;
  final Player participant;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<Widget> widgets = [_buildAvatarCard(context), _buildScoreCard()];

    return Card(
      //color: theme.canvasColor,
      //color: Colors.white,
      //color: Theme.of(context).primaryColor,
      color: Colors.transparent,
      elevation: 0,
      child: InkWell(
        //onTap: () {},
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: onRight ? widgets.reversed.toList() : widgets,
            )),
      ),
    );
  }

  Widget _buildAvatarCard(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
        child: Container(
            width: 50,
            height: 50,
            child: Icon(Icons.account_box,
                size: 50, color: Color(participant.color))),
        color: Colors.white,
        //color: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(
              color:
                  isPlaying ? Color(participant.color) : theme.highlightColor,
              width: 2.0,
            )));
  }

  Widget _buildScoreCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
            child: Container(width: 15, height: 15),
            color: Color(participant.color),
            shape: CircleBorder(
                side: BorderSide(
              color: Colors.white,
              width: 1.0,
            ))),
        SizedBox(width: 5.0),
        Text('${participant.score.value}', style: TextStyle(fontSize: 18))
      ],
    );
  }

  @override
  Widget buildBis(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          print('On participant ${participant.id} tap');
          BlocProvider.of<PlayersBloc>(context)
              .add(PlayerSelected(participant.id));
        },
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: _widgets(onRight),
            )),
      ),
    );
  }

  List<Widget> _widgets(bool onRight) {
    List<Widget> widgets = <Widget>[
      Expanded(
        flex: 1,
        child: _buildThumbnail(),
      ),
      Expanded(
        flex: 3,
        child: ParticipantInfo(participant: participant, onRight: onRight),
      ),
    ];

    return onRight ? widgets.reversed.toList() : widgets;
  }

  Widget _buildThumbnail() {
    return Container(
      //color: Colors.teal,
      margin: EdgeInsets.zero,
      width: 48,
      height: 48,
      padding: EdgeInsets.symmetric(vertical: 4.0),
      alignment: Alignment.center,
      child: CircleAvatar(
        child: Icon(Icons.person),
        backgroundColor: Color(participant.color),
      ),
    );
  }
}
