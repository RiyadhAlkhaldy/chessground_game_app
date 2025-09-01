import 'package:sound_effect/sound_effect.dart';

class PlaySoundUseCase {
  final SoundEffect _soundEffectPlugin;

  PlaySoundUseCase(this._soundEffectPlugin) {
    _soundEffectPlugin.load('demo', 'assets/sounds/demo.mp3');
  }

  Future<void> executeMoveSound() async {
    await _soundEffectPlugin.play('');
  }

  Future<void> executeCaptureSound() async {
    await _soundEffectPlugin.play('');
  }

  Future<void> executeCheckSound() async {
    await _soundEffectPlugin.play('');
  }

  Future<void> executeResetGameSound() async {
    await _soundEffectPlugin.play('');
  }

  Future<void> executePromoteSound() async {
    await _soundEffectPlugin.play('');
  }
}
