import '../../core/constants/app_images_sounds.dart';
import '../../domain/services/sound_effect_service.dart';

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
    await soundEffect.soundEffect.play(Assets.soundsMoveSelf);
  }

  Future<void> executeCaptureSound() async {
    if (!soundEffect.soundLoaded) await soundEffect.loadSounds();
    await soundEffect.soundEffect.play(Assets.soundsCapture);
  }

  Future<void> executeCheckSound() async {
    if (!soundEffect.soundLoaded) await soundEffect.loadSounds();
    await soundEffect.soundEffect.play(Assets.soundsMoveCheck);
  }

  Future<void> executeCheckmateSound() async {
    if (!soundEffect.soundLoaded) await soundEffect.loadSounds();
    // reuse win/lose or custom sound
    await soundEffect.soundEffect.play(Assets.soundsGameWinLong);
  }

  Future<void> executePromoteSound() async {
    if (!soundEffect.soundLoaded) await soundEffect.loadSounds();
    await soundEffect.soundEffect.play(Assets.soundsPromote);
  }

  Future<void> executeTimeoutSound() async {
    if (!soundEffect.soundLoaded) await soundEffect.loadSounds();
    await soundEffect.soundEffect.play(Assets.soundsGameLose);
  }

  Future<void> executeResignSound() async {
    if (!soundEffect.soundLoaded) await soundEffect.loadSounds();
    await soundEffect.soundEffect.play(Assets.soundsGameLose);
  }

  Future<void> executeDrawSound() async {
    if (!soundEffect.soundLoaded) await soundEffect.loadSounds();
    await soundEffect.soundEffect.play(Assets.soundsNotification);
  }
}
