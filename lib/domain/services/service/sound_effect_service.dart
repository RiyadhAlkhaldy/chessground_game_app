import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sound_effect/sound_effect.dart';

import '../../../core/utils/dialog/constants/app_images_sounds.dart';

enum Sound {
  move,
  capture,
  lowTime,
  dong,
  error,
  confirmation,
  puzzleStormEnd,
  clock,
  berserk,
}

class SoundEffectService {
  final soundEffect = SoundEffect();

  bool soundLoaded = false;
  String? loadError;
  final _extension = defaultTargetPlatform == TargetPlatform.iOS
      ? 'aifc'
      : 'mp3';

  /// Loads a single sound from the given [SoundTheme].
  Future<void> loadSound(String themePath, Sound sound) async {
    const standardPath = 'assets/sounds/standard';
    final soundId = sound.name;
    final file = '$soundId.$_extension';
    String fullPath = '$themePath/$_extension';
    // If the sound file is not found in the theme, fallback to the standard theme.
    try {
      await rootBundle.load(fullPath);
    } catch (_) {
      fullPath = '$standardPath/$file';
    }
    await soundEffect.load(soundId, fullPath);
  }

  Future<void> loadSounds() async {
    if (soundLoaded) return;
    try {
      await soundEffect.initialize();
      // loadSound(Assets.soundsNesCapture, Sound.capture);
      // loadSound(Assets.soundsSfxCapture, Sound.capture);
      // loadSound(Assets.soundsLispCapture, Sound.capture);
      loadSound(Assets.soundsStandardMove, Sound.move);
      loadSound(Assets.soundsStandardCapture, Sound.capture);
      loadSound(Assets.soundsStandardDong, Sound.dong);
      loadSound(Assets.soundsStandardClock, Sound.clock);
      loadSound(Assets.soundsStandardBerserk, Sound.berserk);
      loadSound(Assets.soundsLispConfirmation, Sound.confirmation);
      loadSound(Assets.soundsStandardError, Sound.error);
      loadSound(Assets.soundsStandardLowTime, Sound.lowTime);
      loadSound(Assets.soundsStandardPuzzleStormEnd, Sound.puzzleStormEnd);

      soundLoaded = true;
    } catch (e) {
      debugPrint("loadError: $e");
      loadError = e.toString();
    }
  }

  Future<void> releaseSounds() async {
    await soundEffect.release();
    soundLoaded = false;
  }
}
