import 'package:flutter/foundation.dart';
import '../models/GameTypes.dart';

class GamePhaseController extends ChangeNotifier {
  final ValueNotifier<GamePhase> currentPhaseNotifier =
      ValueNotifier<GamePhase>(GamePhase.playerHiding);
  final ValueNotifier<DayPhase> dayPhaseNotifier =
      ValueNotifier<DayPhase>(DayPhase.day);
  final ValueNotifier<bool> isTransitioningNotifier =
      ValueNotifier<bool>(false);

  GamePhase get currentPhase => currentPhaseNotifier.value;
  DayPhase get dayPhase => dayPhaseNotifier.value;

  void setCurrentPhase(GamePhase phase) {
    currentPhaseNotifier.value = phase;
    notifyListeners();
  }

  void setDayPhase(DayPhase phase) {
    dayPhaseNotifier.value = phase;
    notifyListeners();
  }

  void switchToNightPhase() {
    setDayPhase(DayPhase.night);
    setCurrentPhase(GamePhase.playerSeeking);
    notifyListeners();
  }

  void startTransition() {
    isTransitioningNotifier.value = true;
    notifyListeners();
  }

  void endTransition() {
    isTransitioningNotifier.value = false;
    notifyListeners();
  }

  @override
  void dispose() {
    currentPhaseNotifier.dispose();
    dayPhaseNotifier.dispose();
    isTransitioningNotifier.dispose();
    super.dispose();
  }
}
