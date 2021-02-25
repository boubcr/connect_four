import 'package:flutter/material.dart';
import 'package:game_manager/game_manager.dart';

class ParticipantInfo extends StatelessWidget {
  const ParticipantInfo({Key key, this.participant, this.onRight})
      : super(key: key);

  final Player participant;
  final onRight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
      child: Column(
        crossAxisAlignment:
        onRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            participant.name,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            '${participant.score}',
            style: const TextStyle(fontSize: 10.0),
          ),
          /*const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          Text(
            '$viewCount views',
            style: const TextStyle(fontSize: 10.0),
          ),*/
        ],
      ),
    );
  }
}
