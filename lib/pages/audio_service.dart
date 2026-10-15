import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioService extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  bool _isPlaying = false;
  double _progress = 0.0;
  String _currentReciterName = 'عبد الباسط عبد الصمد';
  String _currentSurahName = 'سورة البقرة';

  bool get isPlaying => _isPlaying;
  double get progress => _progress;
  String get currentReciterName => _currentReciterName;
  String get currentSurahName => _currentSurahName;

  AudioService() {
    _player.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      notifyListeners();
    });

    _player.positionStream.listen((pos) {
      final total = _player.duration ?? Duration.zero;
      if (total.inMilliseconds > 0) {
        _progress = (pos.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0);
        notifyListeners();
      }
    });
  }

  Future<void> playAyahOrSurah(String audioUrl, {String? reciter, String? surah}) async {
    try {
      if (reciter != null) _currentReciterName = reciter;
      if (surah != null) _currentSurahName = surah;

      await _player.setUrl(audioUrl);
      await _player.play();
      notifyListeners();
    } catch (e) {
      debugPrint('Audio Playback Error: $e');
    }
  }

  Future<void> togglePlay() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
    notifyListeners();
  }

  Future<void> seek(double relativeValue) async {
    final total = _player.duration ?? Duration.zero;
    final target = total * relativeValue;
    await _player.seek(target);
  }

  Future<void> next() async {
    // الانتقال للمقطع التالي
  }

  Future<void> previous() async {
    // الانتقال للمقطع السابق
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
