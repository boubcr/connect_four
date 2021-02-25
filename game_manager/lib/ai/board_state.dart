import 'package:game_manager/game_manager.dart';

/// First initialized in GameManager if board is empty
/// Then used in Board creation for adding new states
class BoardState {
  //final double playerValue;
  //final double opponentValue;
  final Map<String, double> states;
  //final Map<String, Square> squares;
  BoardState({Map<String, double> states}) : this.states = states ?? {};

  void init() {
    this.states.clear();
  }

  /*
  void addSquares(Map<String, Square> newSquares) {
    squares.values.forEach((square) {
      this.states.putIfAbsent(square.mapKey, () => 0.0);
    });
  }*/

  void add(String mapKey, double value) {
    this.states.putIfAbsent(mapKey, () => value);
  }

  bool containsKey(String mapKey) => this.states.containsKey(mapKey);

  double valueOf(String mapKey) {
    if (this.states.containsKey(mapKey)) return this.states[mapKey];

    return double.nan;
  }

  @override
  String toString() {
    return 'BoardState { '
        'states: $states }';
  }

  /*
  static EvaluationMap _instance;
  static Map<String, double> _map = {};

  EvaluationMap._internal(Map<String, Square> squares) {
    print('EvaluationMap constructor');
    squares.values.forEach((square) {
      _map.putIfAbsent(square.mapKey, () => 0.0);
    });
    _instance = this;
  }

  factory EvaluationMap({Map<String, Square> squares}) => _instance ?? EvaluationMap._internal(squares);

  static Map<String, double> get squareValues => _map;
  */
}
