import 'package:flutter/widgets.dart';
import 'package:sound_effect/sound_effect.dart';

import '../../core/constants/app_images_sounds.dart';

class SoundEffectService {
  final soundEffect = SoundEffect();

  bool soundLoaded = false;
  String? loadError;

  Future<void> loadSounds() async {
    try {
      await soundEffect.initialize();
      await soundEffect.load(Assets.soundsMoveSelf, Assets.soundsMoveSelf);
      await soundEffect.load(Assets.soundsMoveCheck, Assets.soundsMoveCheck);
      await soundEffect.load(
        Assets.soundsMoveOpponentCheck,
        Assets.soundsMoveOpponentCheck,
      );
      await soundEffect.load(Assets.soundsClick, Assets.soundsClick);
      await soundEffect.load(Assets.soundsCapture, Assets.soundsCapture);
      await soundEffect.load(Assets.soundsCastle, Assets.soundsCastle);
      await soundEffect.load(Assets.soundsEventStart, Assets.soundsEventStart);
      await soundEffect.load(Assets.soundsGameLose, Assets.soundsGameLose);
      await soundEffect.load(Assets.soundsPremove, Assets.soundsPremove);
      await soundEffect.load(Assets.soundsPromote, Assets.soundsPromote);
      await soundEffect.load(Assets.soundsTenseconds, Assets.soundsTenseconds);

      soundLoaded = true;
    } catch (e) {
      debugPrint("loadError: $e");
      loadError = e.toString();
    }
  }

  Future<void> releaseSounds() async {
    await soundEffect.release();
  }
}
