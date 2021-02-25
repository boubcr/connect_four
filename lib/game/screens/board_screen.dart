import 'package:connect_four/game/widgets/dot_item.dart';
import 'package:connect_four/utils/app_keys.dart';
import 'package:connect_four/common/custom_audio_player.dart';
import 'package:connect_four/game/widgets/widgets.dart';
import 'package:connect_four/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:game_manager/game_manager.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class BoardScreen extends StatefulWidget {
  final GameManager manager;
  final ValueChanged<Dot> onDotTap;
  final LayerLink layerLink;
  const BoardScreen({Key key, @required this.manager, @required this.onDotTap, this.layerLink})
      : super(key: key);

  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {

  @override
  Widget build(BuildContext context) {
    executeAfterBuild();
    return _buildBoardScreen();
  }

  void executeAfterBuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (this.widget.manager.moves.isEmpty) {
        CustomAudioPlayer.playPlayingBGM();
      }
    });
  }

  Widget _buildBoardScreen() {
    Board board = this.widget.manager.board;
    BoardSettings dimension = this.widget.manager.settings;

    return CompositedTransformTarget(
      link: this.widget.layerLink,
      child: AnimationLimiter(
        child: GridView.count(
          key: AppKeys.boardGridKey,
          padding: const EdgeInsets.all(14.0),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          crossAxisCount: dimension.gridColumns,
          children: board.dots
              .asMap()
              .entries
              .map((entry) => _buildGridItemScale(
                  index: entry.key,
                  dot: entry.value,
                  columnCount: dimension.gridColumns))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildGridItemScale({int index, int columnCount, Dot dot}) {
    Player currentTurn = this.widget.manager.current;
    LastMove lastMove;
    if (this.widget.manager.gameStatus() == GameStatus.NO_WINNER_YET)
      lastMove = this.widget.manager.lastMove;

    return AnimationConfiguration.staggeredGrid(
      position: index,
      duration: const Duration(milliseconds: 500),
      columnCount: columnCount,
      child: ScaleAnimation(
        child: FadeInAnimation(
          child: DotItem(
              key: dot.dotKey,
              dot: dot,
              onDotTap: this.widget.onDotTap,
              lastMove: lastMove,
              currentTurn: currentTurn),
        ),
      ),
    );
  }

  Widget _buildGridItemHorizontal({int index, int columnCount, Dot dot}) {
    Player currentTurn = this.widget.manager.current;
    //Move lastMove = this.widget.manager.lastMove;

    return AnimationConfiguration.staggeredGrid(
      position: index,
      duration: const Duration(milliseconds: 500),
      columnCount: columnCount,
      child: SlideAnimation(
        horizontalOffset: 50.0,
        child: FadeInAnimation(
          child: DotItem(
              dot: dot,
              //onDotTap: this.widget.onDotTap,
              //isLast: dot.id == lastMove?.id,
              //lastSquare: board.lastSquare,
              currentTurn: currentTurn),
        ),
      ),
    );
  }

  Widget _buildGridItemVertical({int index, int columnCount, Dot dot}) {
    Player currentTurn = this.widget.manager.current;
    //Move lastMove = this.widget.manager.lastMove;

    return AnimationConfiguration.staggeredGrid(
      position: index,
      duration: const Duration(milliseconds: 500),
      columnCount: columnCount,
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: DotItem(
              dot: dot,
              //onDotTap: this.widget.onDotTap,
              //isLast: dot.id == lastMove?.id,
              //lastSquare: board.lastSquare,
              currentTurn: currentTurn),
        ),
      ),
    );
  }

  Widget _buildGridItemOld() {
    Board board = this.widget.manager.board;
    BoardSettings dimension = this.widget.manager.settings;
    Player currentTurn = this.widget.manager.current;
    //Move lastMove = this.widget.manager.lastMove;

    return GridView.count(
      padding: const EdgeInsets.all(14.0),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      crossAxisCount: dimension.gridColumns,
      children: board.dots
          .map((dot) => DotItem(
              dot: dot,
              //onDotTap: this.widget.onDotTap,
              //isLast: dot.id == lastMove?.id,
              //lastSquare: board.lastSquare,
              currentTurn: currentTurn))
          .toList(),
    );
  }
}
