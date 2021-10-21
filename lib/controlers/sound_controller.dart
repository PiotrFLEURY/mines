import 'package:just_audio/just_audio.dart';

class SoundController {
  late AudioPlayer musicPlayer;
  late AudioPlayer effectPlayer;
  late AudioPlayer explosionPlayer;

  SoundController() {
    musicPlayer = AudioPlayer();

    effectPlayer = AudioPlayer();

    explosionPlayer = AudioPlayer();
  }

  void dispose() {
    musicPlayer.dispose();
    effectPlayer.dispose();
    explosionPlayer.dispose();
  }

  void pauseMusic() async {
    await musicPlayer.setAsset('assets/audio/mixkit-vertigo-597(2).mp3');
    musicPlayer.pause();
  }

  void playClic() async {
    await effectPlayer
        .setAsset('assets/audio/mixkit-mouse-click-close-1113.wav');
    effectPlayer.play();
  }

  void playMusic() async {
    musicPlayer.play();
  }

  void playExplosion() async {
    await explosionPlayer
        .setAsset('assets/audio/mixkit-explosion-with-rocks-debris-1703.wav');
    explosionPlayer.play();
  }

  void toggleSound(bool enabled) {
    if (enabled) {
      musicPlayer.setVolume(1.0);
      effectPlayer.setVolume(1.0);
      explosionPlayer.setVolume(1.0);
      playMusic();
    } else {
      pauseMusic();
      musicPlayer.setVolume(0.0);
      effectPlayer.setVolume(0.0);
      explosionPlayer.setVolume(0.0);
    }
  }
}
