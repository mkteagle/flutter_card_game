import 'dart:math';
import 'package:flutter_cards/controllers/CardStateController.dart';
import 'package:flutter_cards/controllers/GamePhaseController.dart';
import 'package:flutter_cards/controllers/GameScoreController.dart';
import 'package:flutter_cards/controllers/GameTimerController.dart';
import 'package:flutter_cards/models/GameConstants.dart';
import 'package:flutter_cards/models/GameTypes.dart';
import 'package:flutter_cards/services/SoundManager.dart';

class PlayerController {
  final GamePhaseController phaseController;
  final GameTimerController timerController;
  final CardStateController cardController;
  final GameScoreController scoreController;
  final SoundManager soundManager;
  bool _readyToStart = false;
  HidingSpot? _npcSpot;
  bool _hasFoundNannyThisRound = false;
  static const int _minTimeThreshold = 5;

  PlayerController({
    required this.phaseController,
    required this.timerController,
    required this.cardController,
    required this.scoreController,
    required this.soundManager,
  });

  bool get readyToStart => _readyToStart;

  void submitHiding(int position) {
    if (phaseController.currentPhase != GamePhase.playerHiding) return;

    CharacterType character = phaseController.dayPhase == DayPhase.day
        ? CharacterType.baby
        : CharacterType.werewolf;

    cardController.badgeCardIndexNotifier.value = position;
    cardController.babyInStartPositionNotifier.value = false;
    _readyToStart = true;
    soundManager.playCardFlip();
  }

  void hideNPCForNightPhase() {
    final random = Random();
    final position = random.nextInt(cardAssets.length);
    _npcSpot = HidingSpot(position: position, character: CharacterType.nanny);
    cardController.resetCardsToFaceDown();
    _hasFoundNannyThisRound = false;
  }

  void checkGuess(int position) {
    if (phaseController.currentPhase != GamePhase.playerSeeking) return;

    cardController.flipCard(position);
    soundManager.playCardFlip();

    if (_npcSpot?.position == position) {
      _hasFoundNannyThisRound = true;
      scoreController.addPlayerScore();
      soundManager.playFoundTarget();
      cardController.badgeCardIndexNotifier.value = position;

      Future.delayed(GameConstants.foundDelay, () {
        if (phaseController.dayPhase == DayPhase.night) {
          if (timerController.remainingSeconds <= _minTimeThreshold) {
            // Switch to day phase
            phaseController.setDayPhase(DayPhase.day);
            soundManager.playSunrise();
            phaseController.setCurrentPhase(GamePhase.playerHiding);
            cardController.resetAllCards();
            cardController.resetBadge();
            cardController.babyInStartPositionNotifier.value = true;
            timerController.stopTimer();
          } else {
            // Hide nanny in new position and continue night phase
            cardController.badgeCardIndexNotifier.value = null;
            hideNPCForNightPhase();
            // Timer continues counting down
          }
        } else {
          // Day phase always transitions to hiding
          timerController.stopTimer();
          Future.delayed(GameConstants.foundDelay, () {
            phaseController.setCurrentPhase(GamePhase.playerHiding);
            cardController.resetAllCards();
            cardController.resetBadge();
          });
        }
      });
    }
  }

  void handleTimeUp() {
    if (!_hasFoundNannyThisRound) {
      // Only award points to nanny if they weren't found at all during the round
      scoreController.addNPCScore();
    }
    // Switch to day phase
    phaseController.setDayPhase(DayPhase.day);
    soundManager.playSunrise();
    phaseController.setCurrentPhase(GamePhase.playerHiding);
    cardController.resetAllCards();
    cardController.resetBadge();
    cardController.babyInStartPositionNotifier.value = true;
    _hasFoundNannyThisRound = false;
  }

  void setNPCSpot(HidingSpot spot) {
    _npcSpot = spot;
  }

  void reset() {
    _readyToStart = false;
    _npcSpot = null;
    _hasFoundNannyThisRound = false;
  }
}
