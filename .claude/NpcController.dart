import 'package:flutter_cards/controllers/CardStateController.dart';
import 'package:flutter_cards/controllers/GamePhaseController.dart';
import 'package:flutter_cards/controllers/GameScoreController.dart';
import 'package:flutter_cards/controllers/GameTimerController.dart';
import 'package:flutter_cards/models/GameConstants.dart';
import 'package:flutter_cards/models/GameTypes.dart';
import 'package:flutter_cards/services/SoundManager.dart';

class NPCController {
  final GamePhaseController phaseController;
  final GameTimerController timerController;
  final CardStateController cardController;
  final GameScoreController scoreController;
  final SoundManager soundManager;
  DateTime? _lastSearchTime;
  bool _foundThisRound = false;
  HidingSpot? _playerSpot;
  static const int _minTimeThreshold = 5;

  NPCController({
    required this.phaseController,
    required this.timerController,
    required this.cardController,
    required this.scoreController,
    required this.soundManager,
  });

  void setPlayerSpot(HidingSpot spot) {
    _playerSpot = spot;
    _foundThisRound = false;
  }

  void startSeeking() {
    cardController.resetCardsToFaceDown();
    phaseController.setCurrentPhase(GamePhase.npcSeeking);
    phaseController.startTransition();
    cardController.badgeCardIndexNotifier.value = null;
    _lastSearchTime = null;

    Future.delayed(GameConstants.phaseTransitionDuration, () {
      phaseController.endTransition();
      timerController.startTimer(onTick: checkAndPerformSearch);
    });
  }

  void checkAndPerformSearch() {
    if (!timerController.isTimerRunning) return;

    final now = DateTime.now();
    if (_lastSearchTime == null ||
        now.difference(_lastSearchTime!).inSeconds >=
            GameConstants.npcSearchInterval) {
      _startSearch();
      _lastSearchTime = now;
    }
  }

  void _startSearch() {
    cardController.flipRandomCard();
    soundManager.playCardFlip();
    _checkFoundPlayer();
  }

  void _checkFoundPlayer() {
    if (_playerSpot != null && cardController.isFaceUp(_playerSpot!.position)) {
      _foundThisRound = true;
      soundManager.playFoundTarget();
      scoreController.addNPCScore();
      cardController.badgeCardIndexNotifier.value = _playerSpot!.position;

      // Check for short circuit
      if (timerController.remainingSeconds > _minTimeThreshold) {
        timerController.stopTimer();
        // Switch to night phase immediately
        Future.delayed(GameConstants.foundDelay, () {
          phaseController.setDayPhase(DayPhase.night);
          soundManager.playSunset();
          phaseController.setCurrentPhase(GamePhase.playerSeeking);
          cardController.resetAllCards();
          cardController.resetBadge();
          _playerSpot = null;
        });
      } else {
        // Regular transition
        Future.delayed(GameConstants.foundDelay, () {
          phaseController.setCurrentPhase(GamePhase.playerHiding);
          cardController.resetAllCards();
          cardController.resetBadge();
          cardController.babyInStartPositionNotifier.value = true;
          _playerSpot = null;
        });
      }
    }
  }
}
