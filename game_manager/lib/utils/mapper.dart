import 'package:game_manager/entities/entities.dart';
import 'package:game_manager/game_manager.dart';

class Mapper {
  static GameEntity toGameEntity(GameManager manager) {
    return GameEntity(
      //id: Uuid().generateV4(),
      id: manager.gameKey,
      userId: manager.player.id,
      settings: manager.settings,
      //startTime: startTime,
      //endTime: endTime,
      //maxPlayers: maxPlayers,
      //moveTimeLimit: moveTimeLimit);
    );
  }
}
