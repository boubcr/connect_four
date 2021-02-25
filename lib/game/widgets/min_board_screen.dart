import 'package:connect_four/game/widgets/dot_item.dart';
import 'package:flutter/material.dart';
import 'package:game_manager/game_manager.dart';

class MinBoardScreen extends StatelessWidget {
  final double height;
  final double width;
  final bool isLeft;
  final bool isWelcome;

  Board board;

  MinBoardScreen({Key key, this.height, this.width, this.isLeft = false, this.isWelcome = false})
      : super(key: key) {

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

    BoardSettings settings = BoardSettings(rows: 3, columns: 3, style: DotStyle());
    List<Move> moves = isLeft ? leftMoves(pl1) : rightMoves(pl2);

    if (isWelcome) {
      settings = BoardSettings(rows: 4, columns: 4, style: DotStyle(shape: DotShape.CIRCLE));
      moves = welcomeMoves(pl1, pl2);
    }

    board = Board(
        status: DotStatus.DEACTIVATE,
        settings: settings,
        player: pl1,
        opponent: pl2,
        moves: moves);
  }

  List<Move> welcomeMoves(Player pl1, Player pl2) => [
    Move(dot: Dot(row: 0, column: 0), madeBy: pl2.id),
    Move(dot: Dot(row: 0, column: 2), madeBy: pl2.id),
    Move(dot: Dot(row: 2, column: 0), madeBy: pl2.id),
    Move(dot: Dot(row: 2, column: 2), madeBy: pl1.id),
    Move(dot: Dot(row: 2, column: 4), madeBy: pl1.id),
    Move(dot: Dot(row: 4, column: 2), madeBy: pl1.id),
    Move(dot: Dot(row: 4, column: 4), madeBy: pl1.id)
  ];

  List<Move> leftMoves(Player pl1) => [
    Move(dot: Dot(row: 0, column: 0), madeBy: pl1.id),
    Move(dot: Dot(row: 0, column: 2), madeBy: pl1.id),
    Move(dot: Dot(row: 2, column: 0), madeBy: pl1.id),
    Move(dot: Dot(row: 2, column: 2), madeBy: pl1.id),
    Move(dot: Dot(row: 0, column: 4), madeBy: pl1.id)
  ];

  List<Move> rightMoves(Player pl2) => [
    Move(dot: Dot(row: 0, column: 2), madeBy: pl2.id),
    Move(dot: Dot(row: 0, column: 4), madeBy: pl2.id),
    Move(dot: Dot(row: 2, column: 2), madeBy: pl2.id),
    Move(dot: Dot(row: 2, column: 4), madeBy: pl2.id),
    Move(dot: Dot(row: 4, column: 2), madeBy: pl2.id),
    Move(dot: Dot(row: 4, column: 4), madeBy: pl2.id)
  ];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      height: height ?? double.infinity,
      width: width ?? double.infinity,
      child: Card(
        color: theme.primaryColor,
        elevation: 20 ,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color:theme.secondaryHeaderColor,
              width: 3.0,
            )),
        child: GridView.count(
          padding: const EdgeInsets.all(14.0),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          crossAxisCount: board.settings.gridColumns,
          children: board.dots.map((dot) => DotItem(dot: dot)).toList(),
        )
      ),
    );
  }
}
