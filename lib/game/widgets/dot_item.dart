import 'package:connect_four/animations/move_animation.dart';
import 'package:connect_four/animations/ripples_animation.dart';
import 'package:connect_four/common/arc_clip_plainter.dart';
import 'package:connect_four/settings/bloc/bloc.dart';
import 'package:connect_four/utils/constants.dart';
import 'package:connect_four/utils/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_manager/game_manager.dart';

class DotItem extends StatefulWidget {
  DotItem(
      {Key key,
      @required this.dot,
      @required this.currentTurn,
      this.lastMove,
      this.ratio = 2.0,
      this.onDotTap})
      : super(key: key);

  final Dot dot;
  final double ratio;
  final Player currentTurn;
  final ValueChanged<Dot> onDotTap;
  final LastMove lastMove;

  @override
  _DotItemState createState() => _DotItemState();
}

class _DotItemState extends State<DotItem> {
  final Duration rippleDuration = Duration(seconds: 1);
  final Duration scoreDuration = Duration(seconds: 5);

  AnimationType animationType;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (this.widget.dot.type == DotType.TOUCHABLE) {
      if (isLast) {
        executeAfterBuild();
        //return compositedTouchableDot();
      }

      return compositedTouchableDot();
    }

    return _buildMiddleDot();
  }

  Widget compositedTouchableDot() {
    return CompositedTransformTarget(
      link: this._layerLink,
      child: _buildTouchableDot(),
    );
  }

  Widget _buildTouchableDot() {
    Widget dotChild = this.widget.dot.hasMark ||
            this.widget.dot.status == DotStatus.DEACTIVATE ||
            this.widget.onDotTap == null
        ? Container(margin: EdgeInsets.zero, child: _buildText())
        //Container(child: _buildText())
        : dotInkWell;

    /*if (this.widget.dot.id == this.widget.lastMove.id) {
      return RipplesAnimation();
    }*/

    if (this.widget.dot.style.shape == DotShape.CIRCLE)
      return CircleAvatar(
        backgroundColor: Color(this.widget.dot.style.color),
        child: dotChild,
      );

    return Card(
        margin: EdgeInsets.zero,
        color: Color(this.widget.dot.style.color),
        shape: Utility.dotBorder(shape: this.widget.dot.style?.shape),
        child: dotChild);
  }

  Widget get dotInkWell => InkWell(
        child: Container(margin: EdgeInsets.zero, padding: EdgeInsets.zero, child: _buildText()),
        //child: Container(child: _buildText()),
        onTap: () {
          print('Dot (${this.widget.dot.row},${this.widget.dot.column}) TAP');
          this.widget.onDotTap(this.widget.dot);
          //_createOverlayEntry();
        },
      );

  Widget _buildMiddleDot() {
    return Card(
      color: Colors.transparent,
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: BeveledRectangleBorder(
        side: BorderSide(
          color: Colors.transparent,
          width: 0.0,
        ),
      ),
      child: Container(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        //color: Colors.brown,
        child: ClipPath(
          clipper: ArcClipPainter(type: this.widget.dot.type),
          child: Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            //color: Colors.red,
            color: dotColor,
          ),
        ),
      ),
    );
  }

  Widget _buildMiddleDot1(BuildContext context) {
    Widget middle1 = Card(
        margin: EdgeInsets.zero,
        //color: Theme.of(context).primaryColor,
        elevation: 0,
        color: Colors.transparent,
        shape: BeveledRectangleBorder(
          side: BorderSide(
            color: Colors.transparent,
            width: 0.0,
          ),
        ),
        child: this.widget.dot.type == DotType.VERTICAL
            ? _verticalCard()
            : _horizontalCard());

    Widget middle = ClipPath(
      clipper: ArcClipPainter(type: this.widget.dot.type),
      child: Container(
        color: Colors.white,
      ),
    );

    EdgeInsets edgeInsets = this.widget.dot.type == DotType.VERTICAL
        ? EdgeInsets.symmetric(horizontal: Constants.DOT_RADIUS, vertical: 0)
        : EdgeInsets.symmetric(horizontal: 0, vertical: Constants.DOT_RADIUS);

    return Card(
      color: Colors.deepPurple,
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: BeveledRectangleBorder(
        side: BorderSide(
          color: Colors.transparent,
          width: 0.0,
        ),
      ),
      child: Container(
        margin: edgeInsets,
        color: Colors.brown,
        child: middle,
      ),
    );
  }

  Widget _verticalCard() {
    return VerticalDivider(
      color: dotColor,
      width: 20,
      thickness: 20,
    );
  }

  Widget _horizontalCard() {
    return Divider(
      color: dotColor,
      height: 20,
      thickness: 20,
    );
  }

  bool get hasScored =>
      this.widget.lastMove != null &&
      this.widget.lastMove.squares.contains(this.widget.dot.id);

  bool get isLast => this.widget.dot.id == this.widget.lastMove?.id;

  Color get dotColor => this.widget.dot.hasStyle
      ? Color(this.widget.dot.style.color)
      : Colors.transparent;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void executeAfterBuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SettingsOption option = (BlocProvider.of<SettingsBloc>(context).state as LoadSuccess).options;
      if (option.lastMove)
        _createOverlayEntry();
    });
  }

  void _createOverlayEntry() {
    OverlayState overlayState = Overlay.of(context);

    RenderBox renderBox = context.findRenderObject();
    Size size = renderBox.size;

    double overlayWidth = size.width * this.widget.ratio;
    double overlayHeight = size.height * this.widget.ratio;

    double coordinateRatio = (this.widget.ratio - 1.0) / 2.0;
    double x = size.width * coordinateRatio;
    double y = size.height * coordinateRatio;
    Offset offset = Offset(-x, -y);

    this._overlayEntry?.remove();

    this._overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
              width: overlayWidth,
              height: overlayHeight,
              child: CompositedTransformFollower(
                link: this._layerLink,
                showWhenUnlinked: false,
                offset: offset,
                child: RipplesAnimation(
                    size: 50.0,
                    //color: Colors.red,
                    color: Color(this.widget.dot.style.color)
                ),
              ),
            ));

    overlayState.insert(this._overlayEntry);
  }

  void _removeOverlay() {
    this._overlayEntry?.remove();
    _overlayEntry = null;
  }

  /*
  @override
  Widget buildOld(BuildContext context) {
    switch (this.widget.dot.type) {
      case DotType.CENTER:
        if (this.hasScored) {
          animationType = AnimationType.EXPLOSION;
          executeAfterBuild();
        }
        return CompositedTransformTarget(
          link: this._layerLink,
          child: _buildMiddleDot(context),
        );
      case DotType.TOUCHABLE:
        if (this.isLast && this.widget.dot.hasMark) {
          animationType = AnimationType.RIPPLE;
          executeAfterBuild();
        }

        return CompositedTransformTarget(
          link: this._layerLink,
          child: _buildTouchableDot(),
        );
      default:
        return _buildMiddleDot(context);
    }
  }

  void executeAfterBuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("DotItem => executeAfterBuild");
      _createOverlayEntry();
      Duration duration = animationType == AnimationType.RIPPLE
          ? rippleDuration
          : scoreDuration;
      _addCountdownTimer(duration);
    });
  }

  void _createOverlayEntry() {
    OverlayState overlayState = Overlay.of(context);

    RenderBox renderBox = context.findRenderObject();
    Size size = renderBox.size;

    double overlayWidth = size.width * this.widget.ratio;
    double overlayHeight = size.height * this.widget.ratio;

    double coordinateRatio = (this.widget.ratio - 1.0) / 2.0;
    double x = size.width * coordinateRatio;
    double y = size.height * coordinateRatio;
    Offset offset = Offset(-x, -y);

    this._overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          width: overlayWidth,
          height: overlayHeight,
          child: CompositedTransformFollower(
            link: this._layerLink,
            showWhenUnlinked: false,
            offset: offset,
            child: animationType == AnimationType.RIPPLE
                ? RipplesAnimation(
                size: 50.0, color: Color(this.widget.dot.style.color))
                : ScoreAnimation(color: Color(this.widget.lastMove.color)),
          ),
        ));

    overlayState.insert(this._overlayEntry);
  }

  void _removeOverlay() {
    this._overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _addCountdownTimer(Duration duration) {
    Timer(duration, () {
      //print("Yeah, this line is printed after 3 second");
      _removeOverlay();
    });
  }
  */

  Widget _buildText() {
    return Center(
      child: Align(
        alignment: Alignment.center,
        child: Text(
            this.widget.dot.hasMark
                ? Enum.getValue(this.widget.dot.mark)
                : this.widget.dot.id,
            style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }

}
