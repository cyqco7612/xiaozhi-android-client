import 'package:just_audio/just_audio.dart';

/// 短促 UI 音效播放（如发送语音时的"嗖"声）
class SoundEffect {
  SoundEffect._();

  /// 播放发送语音的"嗖"音效，失败时静默忽略不影响主流程
  static Future<void> playWhoosh() async {
    AudioPlayer? player;
    try {
      player = AudioPlayer();
      await player.setAsset('assets/sounds/whoosh.wav');
      await player.play();
      // 音效约 0.3 秒，稍作等待后释放
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      print('SoundEffect: 播放 whoosh 音效失败: $e');
    } finally {
      try {
        await player?.dispose();
      } catch (_) {}
    }
  }
}
