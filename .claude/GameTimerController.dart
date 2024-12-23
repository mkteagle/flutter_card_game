import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_cards/controllers/GamePhaseController.dart';
import 'package:flutter_cards/controllers/GameScoreController.dart';
import 'package:flutter_cards/models/GameConstants.dart';
import 'package:flutter_cards/models/GameTypes.dart';
import 'package:flutter_cards/services/SoundManager.dart';

class GameTimerController extends ChangeNotifier {
  final GamePhaseController phaseController;
  final GameScoreController scoreController;
  final SoundManager soundManager;
  Timer? _gameTimer;
  int _remainingSeconds = GameConstants.npcSeekingDuration;
  bool _isTimerRunning = false;
  Function? _onTick;
  Function? _onNightPhaseStart;

  GameTimerController({
    required this.phaseController,
    required this.scoreController,
    required this.soundManager,
  });

  bool get isTimerRunning => _isTimerRunning;
  int get remainingSeconds => _remainingSeconds;

  void setNightPhaseCallback(Function callback) {
    _onNightPhaseStart = callback;
  }

  void startTimer({Function? onTick}) {
    if (_gameTimer != null) _gameTimer!.cancel();

    _isTimerRunning = true;
    _onTick = onTick;
    _remainingSeconds = GameConstants.npcSeekingDuration;

    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        _onTick?.call();
        notifyListeners();
      } else {
        handleTimeComplete();
      }
    });
    notifyListeners();
  }

  void stopTimer() {
    _isTimerRunning = false;
    _gameTimer?.cancel();
    _gameTimer = null;
    notifyListeners();
  }

  void handleTimeComplete() {
    stopTimer();

    if (phaseController.currentPhase == GamePhase.npcSeeking) {
      // Day phase ended - NPC didn't find player
      scoreController.addPlayerScore();
      Future.delayed(GameConstants.foundDelay, () {
        // Switch to night phase where nanny hides and werewolf hunts
        phaseController.setDayPhase(DayPhase.night);
        soundManager.playSunset();
        phaseController.setCurrentPhase(GamePhase.playerSeeking);
        resetTimer();
        _onNightPhaseStart?.call(); // This will set up nanny's hiding spot
        startTimer();
      });
    } else if (phaseController.currentPhase == GamePhase.playerSeeking) {
      if (phaseController.dayPhase == DayPhase.night) {
        // Night phase ended - Werewolf didn't find nanny
        scoreController.addNPCScore();
        Future.delayed(GameConstants.foundDelay, () {
          // Switch back to day phase where baby hides
          phaseController.setDayPhase(DayPhase.day);
          soundManager.playSunrise();
          phaseController.setCurrentPhase(GamePhase.playerHiding);
        });
      }
    }
  }

  void resetTimer() {
    _remainingSeconds = GameConstants.npcSeekingDuration;
    _isTimerRunning = false;
    _gameTimer?.cancel();
    _gameTimer = null;
    notifyListeners();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }
}
