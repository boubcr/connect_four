import 'package:connect_four/game/widgets/dot_item.dart';
import 'package:connect_four/utils/app_keys.dart';
import 'package:connect_four/common/shaped_card.dart';
import 'package:connect_four/common/template.dart';
import 'package:connect_four/game/widgets/min_board_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_manager/game_manager.dart';
import 'package:easy_localization/easy_localization.dart';

class GameRules extends StatefulWidget {
  const GameRules({Key key}) : super(key: key);

  @override
  _GameRulesState createState() => _GameRulesState();
}

class _GameRulesState extends State<GameRules> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Template(
        title: 'rules.title',
        child: Center(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          alignment: Alignment.center,
          height: 500,
          width: double.infinity,
          child: ShapedCard(
            //title: 'Goal',
            child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 15),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  _buildText('rules.paragraph1'),
                  SizedBox(height: 10.0),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        MinBoardScreen(height: 100, width: 100, isLeft: true),
                        MinBoardScreen(height: 100, width: 100)
                      ],
                    ),
                  ),
                  _buildText('rules.paragraph2'),
                  SizedBox(height: 10.0),
                  _buildText('rules.paragraph3'),
                  SizedBox(height: 10.0),
                  _buildText('rules.paragraph4'),
                  SizedBox(height: 10.0),
                  _buildText('rules.paragraph5')
                ]),
          ),
        ))).scaffold();
  }

  Widget _buildText(String text) {
    //FrostbiteBossFight
    return Text(text,
        style: TextStyle(fontSize: 17, fontFamily: 'Squirk'),
        textAlign: TextAlign.center).tr();
  }

  Widget _buildBoard() {
    Player pl1 = Player(
      id: 'pl1',
      mark: Mark.PX,
      color: Colors.blue.value,
    );

    Player pl2 = Player(
      id: 'pl2',
      mark: Mark.PY,
      color: Colors.red.value,
    );

    Board board = Board(
        status: DotStatus.DEACTIVATE,
        settings: BoardSettings(rows: 3, columns: 3, style: DotStyle()),
        player: pl1,
        opponent: pl2,
        moves: [
          Move(dot: Dot(row: 0, column: 0), madeBy: pl1.id),
          Move(dot: Dot(row: 0, column: 2), madeBy: pl1.id),
          Move(dot: Dot(row: 2, column: 0), madeBy: pl1.id),
          Move(dot: Dot(row: 2, column: 2), madeBy: pl1.id)
        ]);

    return GridView.count(
      key: AppKeys.boardGridKey,
      padding: const EdgeInsets.all(14.0),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      crossAxisCount: board.settings.gridColumns,
      children: board.dots.map((dot) => DotItem(dot: dot)).toList(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
