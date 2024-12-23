import 'package:flutter/material.dart';
import 'package:flutter_cards/controllers/CardStateController.dart';
import 'package:flutter_cards/controllers/GamePhaseController.dart';
import 'package:flutter_cards/controllers/GameScoreController.dart';
import 'package:flutter_cards/controllers/GameTimerController.dart';
import 'package:flutter_cards/controllers/NpcController.dart';
import 'package:flutter_cards/controllers/PlayerController.dart';
import 'package:flutter_cards/models/GameTypes.dart';
import 'package:flutter_cards/services/SoundManager.dart';

class GameController extends ChangeNotifier {
  final GamePhaseController phaseController;
  final GameTimerController timerController;
  final CardStateController cardController;
  final GameScoreController scoreController;
  final SoundManager soundManager = SoundManager();

  late final NPCController npcController;
  late final PlayerController playerController;

  GameController({
    required this.phaseController,
    required this.timerController,
    required this.cardController,
    required this.scoreController,
  }) {
    npcController = NPCController(
      phaseController: phaseController,
      timerController: timerController,
      cardController: cardController,
      scoreController: scoreController,
      soundManager: soundManager,
    );

    playerController = PlayerController(
      phaseController: phaseController,
      timerController: timerController,
      cardController: cardController,
      scoreController: scoreController,
      soundManager: soundManager,
    );

    // Set up night phase initialization
    timerController.setNightPhaseCallback(() {
      cardController.resetCardsToFaceDown();
      playerController.hideNPCForNightPhase();
    });
  }

  bool get readyToStart => playerController.readyToStart;
  DayPhase get currentDayPhase => phaseController.dayPhase;

  void submitPlayerHiding(int position) {
    playerController.submitHiding(position);
    npcController.setPlayerSpot(HidingSpot(
      position: position,
      character: currentDayPhase == DayPhase.day
          ? CharacterType.baby
          : CharacterType.werewolf,
    ));
    notifyListeners();
  }

  void checkPlayerGuess(int position) {
    playerController.checkGuess(position);
    notifyListeners();
  }

  void startNpcSeekingPhase() {
    if (phaseController.currentPhase != GamePhase.playerHiding ||
        !playerController.readyToStart) {
      return;
    }
    npcController.startSeeking();
    notifyListeners();
  }

  @override
  void dispose() {
    phaseController.dispose();
    timerController.dispose();
    cardController.dispose();
    scoreController.dispose();
    soundManager.dispose();
    super.dispose();
  }
}
