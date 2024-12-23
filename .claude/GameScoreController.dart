import 'package:flutter/foundation.dart';
import '../models/GameConstants.dart';

class GameScoreController extends ChangeNotifier {
  int _playerScore = 0;
  int _npcScore = 0;
  int _roundsPlayed = 0;

  int get playerScore => _playerScore;
  int get npcScore => _npcScore;
  int get roundsPlayed => _roundsPlayed;

  void addPlayerScore() {
    _playerScore += GameConstants.pointsForFindingNPC;
    _roundsPlayed++;
    notifyListeners();
  }

  void addNPCScore() {
    _npcScore += GameConstants.pointsForNPCFindingPlayer;
    _roundsPlayed++;
    notifyListeners();
  }

  void resetRoundsPlayed() {
    _roundsPlayed = 0;
    notifyListeners();
  }

  void resetScores() {
    _playerScore = 0;
    _npcScore = 0;
    _roundsPlayed = 0;
    notifyListeners();
  }
}
