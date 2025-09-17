import '../../core/constants/app_images_sounds.dart';
import '../../domain/services/sound_effect_service.dart';

class PlaySoundUseCase {
  final SoundEffectService soundEffect;

  PlaySoundUseCase(this.soundEffect) {
    // soundEffect.loadSounds();
  }

  Future<void> executeMoveSound() async {
    await soundEffect.soundEffect.play(Assets.soundsMoveSelf);
  }

  Future<void> executeCaptureSound() async {
    await soundEffect.soundEffect.play(Assets.soundsCapture);
  }

  Future<void> executeCheckSound() async {
    await soundEffect.soundEffect.play(Assets.soundsMoveCheck);
  }

  // Future<void> executeResetGameSound() async {
  //   await soundEffect.soundEffect.play(Assets.soundsMoveSelf);
  // }

  Future<void> executePromoteSound() async {
    await soundEffect.soundEffect.play(Assets.soundsPromote);
  }
}
