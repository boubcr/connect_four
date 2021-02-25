import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:game_manager/utils/utils.dart';

/// TYPE OF DOT MARK: PX (Player 1), PY (Player 2), AI (AiPlayer)
enum Mark { NO, PX, PY, AI }
enum DotType { TOUCHABLE, CENTER, VERTICAL, HORIZONTAL }
enum DotShape { CIRCLE, SQUARE, RECTANGLE }
enum DotStatus { ACTIVE, DEACTIVATE }

class Dot extends Equatable {
  //final int index;
  final String id;
  final int row;
  final int column;
  final Mark mark;
  final DotStatus status;
  final DotType type;
  final DotStyle style;
  final GlobalKey dotKey;

  Dot(
      {//this.index,
      this.row,
      this.column,
      this.mark = Mark.NO,
      this.type = DotType.VERTICAL,
      this.style,
      DotStatus status,
      GlobalKey dotKey})
      : this.id = '$row$column',
        this.status = status ?? DotStatus.ACTIVE,
        this.dotKey = dotKey ?? LabeledGlobalKey('__dotCard$row${column}__');

  Dot copyWith({int color, Mark mark, DotStatus status}) {
    return Dot(
      //index: this.index,
      dotKey: this.dotKey,
      row: this.row,
      column: this.column,
      type: this.type,
      status: status ?? this.status,
      style: color == null ? this.style : this.style?.copyWith(color: color),
      mark: mark ?? this.mark,
    );
  }

  bool get hasMark => this.mark != null && this.mark != Mark.NO;
  bool get hasStyle => this.style != null;

  /// Only use the ID, ROW and COLUMN as the props => Help in finding the dot in the list by Index
  @override
  List<Object> get props => [id, row, column];

  @override
  String toString() {
    return 'Dot { '
        'id: $id, '
        //'index: $index, '
        'row: $row, '
        'column: $column, '
        'mark: $mark, '
        'type: $type, '
        'style: $style, '
        'dotKey: $dotKey }';
  }

  Map<String, Object> toJson() {
    return {
      //'index': index,
      'row': row,
      'column': column,
      'mark': Enum.getValue(mark),
      'style': style?.toJson()
    };
  }

  static Dot fromJson(Map<String, Object> json) {
    if (json == null) return Dot();

    return Dot(
        //index: json['index'] as int,
        row: json['row'] as int,
        column: json['id'] as int,
        mark: Enum.getEnum(Mark.values, json['mark'] as String),
        style: DotStyle.fromJson(json['style']));
  }
}

class DotStyle extends Equatable {
  final int color;
  final DotShape shape;

  DotStyle({this.color = 0xff000000, this.shape}); //black

  DotStyle copyWith({int color, DotShape shape}) {
    return DotStyle(color: color ?? this.color, shape: shape ?? this.shape);
  }

  @override
  List<Object> get props => [color, shape];

  @override
  String toString() {
    return 'DotStyle { shape: $shape, color: $color }';
  }

  Map<String, Object> toJson() {
    return {'color': color, 'style': Enum.getValue(shape)};
  }

  static DotStyle fromJson(Map<String, Object> json) {
    if (json == null) return DotStyle();

    return DotStyle(
        color: json['color'] as int,
        shape: Enum.getEnum(DotShape.values, json['shape'] as String));
  }
}
