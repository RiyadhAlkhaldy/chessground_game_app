import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

abstract class GetStorageController extends GetxController {
  String? getPlayer(String key);
  String? getUUid(String key);
  bool hasData(String key);
  void saveUUid(String key, String value);

  late GetStorage instance;
}

class GetStorageControllerImp extends GetStorageController {
  @override
  void onInit() {
    super.onInit();
    instance = GetStorage();
  }

  @override
  String? getPlayer(String key) {
    var hasData = instance.hasData(key);
    final player = instance.read(key);

    return hasData ? player as String : null;
  }

  // ! Authorization Bearer
  Map<String, dynamic>? get authorizationToken {
    // return hasData('user')
    //     ? {'Authorization': 'Bearer ${getHumanPlayer('user')!.token}'}
    //     : null;
    return null;
  }

  @override
  String? getUUid(String key) {
    var hasData = instance.hasData(key);
    final uuid = instance.read(key);

    return hasData ? uuid as String : null;
  }

  @override
  void saveUUid(String key, String value) {
    instance.write(key, value);
  }

  @override
  bool hasData(String key) => instance.hasData(key);
}
