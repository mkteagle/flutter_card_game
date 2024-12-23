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
  }

  void checkGuess(int position) {
    if (phaseController.currentPhase != GamePhase.playerSeeking) return;

    cardController.flipCard(position);
    soundManager.playCardFlip();

    if (_npcSpot?.position == position) {
      scoreController.addPlayerScore();
      soundManager.playFoundTarget();
      cardController.badgeCardIndexNotifier.value = position;

      if (phaseController.dayPhase == DayPhase.night) {
        // Check for short circuit during night phase
        if (timerController.remainingSeconds > _minTimeThreshold) {
          timerController.stopTimer();
          // Switch to day phase immediately
          Future.delayed(GameConstants.foundDelay, () {
            phaseController.setDayPhase(DayPhase.day);
            soundManager.playSunrise();
            phaseController.setCurrentPhase(GamePhase.playerHiding);
            cardController.resetAllCards();
            cardController.resetBadge();
            cardController.babyInStartPositionNotifier.value = true;
          });
        } else {
          // Continue night phase with new nanny position
          Future.delayed(GameConstants.foundDelay, () {
            cardController.badgeCardIndexNotifier.value = null;
            hideNPCForNightPhase();
          });
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
    }
  }

  void setNPCSpot(HidingSpot spot) {
    _npcSpot = spot;
  }

  void reset() {
    _readyToStart = false;
    _npcSpot = null;
  }
}
