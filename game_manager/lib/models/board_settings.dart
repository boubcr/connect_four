import 'package:equatable/equatable.dart';
import 'package:game_manager/models/models.dart';

class BoardSettings extends Equatable {
  final int rows;
  final int columns;
  final int backgroundColor;
  final DotStyle style;
  final int gridRows;
  final int gridColumns;

  BoardSettings(
      {this.rows = 1,
      this.columns = 1,
      this.backgroundColor = 0xff888888,
      this.style})
      : this.gridRows = rows * 2 - 1,
        this.gridColumns = columns * 2 - 1;

  BoardSettings copyWith(
      {int rows, int columns, int backgroundColor, DotStyle style}) {
    return BoardSettings(
        rows: rows ?? this.rows,
        columns: columns ?? this.columns,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        style: style ?? this.style);
  }

  @override
  List<Object> get props => [rows, columns, backgroundColor, style];

  @override
  String toString() {
    return 'Settings { '
        'rows: $rows, '
        'columns: $columns, '
        'style: $style, '
        'gridRows: $gridRows, '
        'gridColumns: $gridColumns, '
        'backgroundColor: $backgroundColor }';
  }

  Map<String, Object> toJson() {
    return {
      'rows': rows,
      'columns': columns,
      'backgroundColor': backgroundColor,
      'style': style.toJson()
    };
  }

  static BoardSettings fromJson(Map<String, Object> json) {
    if (json == null) return BoardSettings();

    return BoardSettings(
        rows: json['rows'] as int,
        columns: json['columns'] as int,
        backgroundColor: json['backgroundColor'] as int,
        style: DotStyle.fromJson(json['style']));
  }
}
