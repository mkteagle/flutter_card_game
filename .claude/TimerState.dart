import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerState extends ChangeNotifier {
  Timer? _timer;
  int _remainingSeconds;
  bool _isRunning = false;
  final int _startTime;
  final Function()? onTimerComplete;

  TimerState({
    int startTimeInSeconds = 60,
    this.onTimerComplete,
  })  : _startTime = startTimeInSeconds,
        _remainingSeconds = startTimeInSeconds;

  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;

  void start() {
    if (_isRunning) return;

    _isRunning = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _isRunning = false;
        _timer?.cancel();
        onTimerComplete?.call();
        notifyListeners();
      }
    });
    notifyListeners();
  }

  void pause() {
    _isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  void resume() {
    if (_remainingSeconds > 0) {
      start();
    }
  }

  void reset() {
    _timer?.cancel();
    _remainingSeconds = _startTime;
    _isRunning = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
