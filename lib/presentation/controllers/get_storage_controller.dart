import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../domain/models/player.dart';

abstract class GetStorageController extends GetxController {
  Player? getPlayer(String key);
  bool hasData(String key);
  late GetStorage instance;
}

class GetStorageControllerImp extends GetStorageController {
  @override
  void onInit() {
    super.onInit();
    instance = GetStorage();
  }

  @override
  Player? getPlayer(String key) {
    var hasData = instance.hasData(key);
    final player = instance.read(key);

    return hasData
        ? Player(
          name: player['name'],
          uuid: player['uuid'],
          type: player['type'],
          email: player['email'],
          image: player['image'],
          playerRating: int.parse(player['playerRating']),
        )
        : null;
  }

  // ! Authorization Bearer
  Map<String, dynamic>? get authorizationToken {
    // return hasData('user')
    //     ? {'Authorization': 'Bearer ${getHumanPlayer('user')!.token}'}
    //     : null;
    return null;
  }

  @override
  bool hasData(String key) => instance.hasData(key);
}
