import 'package:chessground_game_app/core/global_feature/domain/services/service/sound_effect_service.dart';

class PlaySoundUseCase {
  final SoundEffectService soundEffect;

  PlaySoundUseCase(this.soundEffect) {
    soundEffect.loadSounds();
  }

  // Future<void> executeResetGameSound() async {
  //   await soundEffect.soundEffect.play(Assets.soundsMoveSelf);
  // }

  Future<void> executeMoveSound() async {
    if (!soundEffect.soundLoaded) await soundEffect.loadSounds();
    await soundEffect.soundEffect.play(Sound.move.name);
  }

  Future<void> executeCaptureSound() async {
    if (!soundEffect.soundLoaded) await soundEffect.loadSounds();
    await soundEffect.soundEffect.play(Sound.capture.name);
  }

  Future<void> executeCheckSound() async {
    if (!soundEffect.soundLoaded) await soundEffect.loadSounds();
    await soundEffect.soundEffect.play(Sound.capture.name);
  }

  Future<void> executeCheckmateSound() async {
    if (!soundEffect.soundLoaded) await soundEffect.loadSounds();
    // reuse win/lose or custom sound
    await soundEffect.soundEffect.play(Sound.capture.name);
  }

  Future<void> executePromoteSound() async {
    if (!soundEffect.soundLoaded) await soundEffect.loadSounds();
    await soundEffect.soundEffect.play(Sound.confirmation.name);
  }

  Future<void> executeTimeoutSound() async {
    if (!soundEffect.soundLoaded) await soundEffect.loadSounds();
    await soundEffect.soundEffect.play(Sound.lowTime.name);
  }

  Future<void> executeResignSound() async {
    if (!soundEffect.soundLoaded) await soundEffect.loadSounds();
    await soundEffect.soundEffect.play(Sound.confirmation.name);
  }

  Future<void> executeDrawSound() async {
    if (!soundEffect.soundLoaded) await soundEffect.loadSounds();
    await soundEffect.soundEffect.play(Sound.confirmation.name);
  }

  Future<void> executeDongSound() async {
    if (!soundEffect.soundLoaded) await soundEffect.loadSounds();
    await soundEffect.soundEffect.play(Sound.dong.name);
  }

  Future<void> executeLowTimeSound() async {
    if (!soundEffect.soundLoaded) await soundEffect.loadSounds();
    await soundEffect.soundEffect.play(Sound.lowTime.name);
  }

  Future<void> executeErrorSound() async {
    if (!soundEffect.soundLoaded) await soundEffect.loadSounds();
    await soundEffect.soundEffect.play(Sound.error.name);
  }

  Future<void> executeClockSound() async {
    if (!soundEffect.soundLoaded) await soundEffect.loadSounds();
    await soundEffect.soundEffect.play(Sound.clock.name);
  }
}
