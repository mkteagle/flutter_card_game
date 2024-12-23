import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_cards/models/GameConstants.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;

  SoundManager._internal() {
    _initializeSounds();
  }

  final AudioCache _audioCache = AudioCache();
  final AudioPlayer _effectsPlayer = AudioPlayer();
  bool _soundEnabled = true;

  Future<void> _initializeSounds() async {
    await _audioCache.loadAll([
      GameConstants.cardFlipSound,
      GameConstants.foundTargetSound,
      GameConstants.sunriseSound,
      GameConstants.sunsetSound,
    ]);
  }

  void toggleSound() {
    _soundEnabled = !_soundEnabled;
  }

  Future<void> playCardFlip() async {
    if (!_soundEnabled) return;
    await _effectsPlayer.play(AssetSource(GameConstants.cardFlipSound));
  }

  Future<void> playFoundTarget() async {
    if (!_soundEnabled) return;
    await _effectsPlayer.play(AssetSource(GameConstants.foundTargetSound));
  }

  Future<void> playSunrise() async {
    if (!_soundEnabled) return;
    await _effectsPlayer.play(AssetSource(GameConstants.sunriseSound));
  }

  Future<void> playSunset() async {
    if (!_soundEnabled) return;
    await _effectsPlayer.play(AssetSource(GameConstants.sunsetSound));
  }

  void dispose() {
    _effectsPlayer.dispose();
    _audioCache.clearAll();
  }
}
