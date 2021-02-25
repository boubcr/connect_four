import 'dart:async';
import 'dart:collection';
import 'package:bloc/bloc.dart';
import 'package:connect_four/auth/auth.dart';
import 'package:connect_four/game/bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_manager/ai/strategy/alpha_beta_pruning_strategy.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:game_manager/game_manager.dart';

Future<BestScore> findBestMove(GameManager manager) async {
  return await manager.current.strategy.think(manager);
}

class GamesBloc extends Bloc<GamesEvent, GamesState> {
  static final _log = Logger('GamesBloc');

  MoveRepository moveRepository;
  StreamSubscription _movesSubscription;

  GameRepository _gamesRepository;
  StreamSubscription _gamesSubscription;
  Game currentGame;

  GamesBloc(
      {@required GameRepository gamesRepository,
      @required this.moveRepository,
      @required AuthBloc authBloc})
      : super(GamesLoadInProgress()) {
    _gamesRepository = gamesRepository;
  }

  @override
  Stream<GamesState> mapEventToState(GamesEvent event) async* {
    if (event is GameAdded) {
      yield* _mapGameAddedToState(event);
    } else if (event is GamesLoading) {
      yield* _mapGamesLoadedToState();
    } else if (event is GamesUpdated) {
      yield* _mapGamesUpdatedToState(event);
    } else if (event is GameUpdated) {
      yield* _mapGameUpdatedToState(event);
    } else if (event is GameBoardChanged) {
      yield* _mapGameBoardChangeToState(event);
    } else if (event is AddMove) {
      yield* _mapAddMoveToState(event);
    } else if (event is MovesLoading) {
      yield* _mapMoveLoadingState(event);
    } else if (event is MakeMove) {
      yield* _mapMakeMoveToState(event);
    }
  }

  Stream<GamesState> _mapMakeMoveToState(MakeMove event) async* {
    if (state is GameLoadedSuccess) {
      GameManager manager = (state as GameLoadedSuccess).manager;
      //TODO Freeze the screen for human when AI is playing
      if (!manager.current.isAi)
        return;

      /*BestScore bestScore = await manager.current.strategy.think(manager);
      if (bestScore != null) {
        add(AddMove(bestScore.bestMove.dot));
      }*/
      //TODO make think asynch => with time parameter instead of depth
      /*manager.current.strategy.think(manager).then((bestScore) {
        if (bestScore != null) {
          add(AddMove(bestScore.bestMove.dot));
        }
      });*/

      BestScore bestScore = await compute(findBestMove, manager);
      _log.info('Found $bestScore');
      if (bestScore != null) add(AddMove(bestScore.move.dot));

      yield GameLoadedSuccess(manager);
    }
  }

  Stream<GamesState> _mapMoveLoadingState(MovesLoading event) async* {
    if (state is GameLoadedSuccess) {
      GameManager manager = (state as GameLoadedSuccess).manager;
      _movesSubscription?.cancel();
      _movesSubscription = moveRepository.gameMoves(manager.gameKey).listen(
        (data) {
          _log.info('${data.length} moves loaded');
          if (data.any((move) => move.id == event.lastMove.id)) {
            GameManager newManager = manager.copyWith(
                switchTurn: true, moves: data, lastMove: event.lastMove);
            add(GameUpdated(newManager));
          }
        },
      );/*..onDone(() {       // Cascade
        print('Loaded moves: ${allMoves.length}');
        GameManager newManager = manager.copyWith(
            switchTurn: true, moves: allMoves, lastMove: event.lastMove);
        add(GameUpdated(newManager));
      })..onError((error) { // Cascade
        print('Error listening to moves repository');
      });*/
    }
  }

  Stream<GamesState> _mapGameUpdatedToState(GameUpdated event) async* {
    yield GameLoadedSuccess(event.manager);
  }

  Stream<GamesState> _mapGameAddedToState(GameAdded event) async* {
    //TODO Add player info from Auth user
    Player player = Player(
        id: 'player1@gmail.com',
        name: 'Human',
        color: event.playerColor,
        mark: Mark.PX);

    Player opponent = Player(color: event.opponentColor, mark: Mark.PY);

    switch (event.mode) {
      case GameMode.ONE_PLAYER:
        switch (event.level) {
          case GameLevel.EASY:
            opponent = opponent.copyWith(
                name: 'Alpha Beta D1', strategy: AlphaBetaPruningStrategy(depth: 1));
            break;
          case GameLevel.MEDIUM:
            opponent = opponent.copyWith(
                name: 'MiniMax D3', strategy: MiniMaxStrategy(depth: 3));
            break;
          case GameLevel.HARD:
            opponent = opponent.copyWith(
                name: 'MiniMax D6', strategy: MiniMaxStrategy(depth: 6));
            break;
          default:
            break;
        }
        break;
      case GameMode.TWO_PLAYERS:
        break;
      default:
        break;
    }

    print('player: $player');
    print('opponent: $opponent');

    /*opponent = Player(
        name: 'AI BD',
        color: event.opponentColor,
        mark: Mark.PY,
        strategy: MiniMaxStrategy(depth: 2));*/

    GameManager manager = GameManager(
        settings: event.dimension,
        thinkTime: event.thinkTime,
        player: player,
        opponent: opponent,
        current: player);

    _log.info('Add game ${player.name} vs ${opponent.name}, key: ${manager.gameKey}');
    add(GameUpdated(manager));
    _createGame(manager);
  }

  Stream<GamesState> _mapAddMoveToState(AddMove event) async* {
    if (state is GameLoadedSuccess) {
      GameManager manager = (state as GameLoadedSuccess).manager;
      LastMove lastMove = _lastMoveNotation(manager, event.dot);
      Move move = Move(
          notation: lastMove.notation,
          dot: event.dot,
          madeBy: manager.current.id);
      _addMove(manager.gameKey, move);

      _log.info('Move ${event.dot.id} added');
      add(MovesLoading(lastMove: lastMove));
    }
  }

  LastMove _lastMoveNotation(GameManager manager, Dot dot) {
    List<String> centerIds = [];
    int notation = 0;
    SquareKeys.squaresOf(dot).forEach((key) {
      if (manager.board.squares.containsKey(key)) {
        Square square = manager.board.squares[key];
        if (square.touchableDots
                .where((d) =>
                    d.id != dot.id &&
                    d.hasMark &&
                    d.mark == manager.current.mark)
                .length ==
            3) {
          centerIds.add(Utils.dotId(key));
          notation++;
        }
      }
    });

    return LastMove(
        id: dot.id,
        notation: notation,
        color: manager.current.color,
        squares: centerIds);
  }

  Stream<GamesState> _mapGameUpdatedToState11(GameUpdated event) async* {
    print('Game => updated');
    //yield GameLoadedSuccess(event.game);

    /*if (state is GameLoadedSuccess) {
      final game = (state as GameLoadedSuccess).game;
      final current = game.currentTurn;
      Board board = game.board;
      //final playerDots = current.moves.map((move) => move.dot.copyWith(color: current.color, checked: true)).toList();
      if (current.moves.isNotEmpty) {
        final lastMove = current.moves.last;
        final dots = board.dots;
        final updateDots = dots.map((dot) {
          if (lastMove.dot.id == dot.id)
            return dot.copyWith(color: current.color, checked: true);

          return dot;
        }).toList();
        board = board.copyWith(dots: updateDots);
      }

      final Game updatedGame = game.copyWith(
          participants: event.game.participants,
          currentTurn: event.game.currentTurn,
          board: board);

      yield GameLoadedSuccess(updatedGame);
    }
    */
  }

  Stream<GamesState> _mapGamesLoadedToState() async* {
    print('Game => loaded');
    /*try {
      _gamesSubscription?.cancel();
      _gamesSubscription = _gamesRepository.games().listen(
        (games) {
          print('Loaded games:' + games.length.toString());
          add(GamesUpdated(games));
        },
      );
    } catch (_) {
      print('Game loading error');
      //yield GamesLoadFailure();
    }*/
  }

  Stream<GamesState> _mapGamesUpdatedToState(GamesUpdated event) async* {
    yield GamesLoadSuccess(event.games);
  }

  Stream<GamesState> _mapGameBoardChangeToState(GameBoardChanged event) async* {
    print('Game => board changing');
    /*Dimension dimension =
        Dimension(rows: event.rows.toInt(), columns: event.columns.toInt());
    yield GameBoardUpdatedSuccess(
        dimension: dimension, color: event.color, dotStyle: event.dotStyle);
    */
  }

  Future _createGame(GameManager manager) {
    return _gamesRepository.createGame(manager);
  }

  Future<Move> _addMove(String gameId, Move move) {
    return moveRepository.addMove(gameId, move);
  }

  @override
  Future<void> close() {
    //participantsSubscription.cancel();
    _gamesSubscription.cancel();
    return super.close();
  }
}
