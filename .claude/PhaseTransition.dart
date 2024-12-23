import 'package:flutter/material.dart';
import '../models/GameConstants.dart';
import '../models/GameTypes.dart';

class PhaseTransition extends StatelessWidget {
  final GamePhase phase;
  final DayPhase dayPhase;
  final bool isVisible;

  const PhaseTransition({
    Key? key,
    required this.phase,
    required this.dayPhase,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: GameConstants.phaseTransitionDuration,
      color: dayPhase == DayPhase.day
          ? GameConstants.dayTimeColor.withOpacity(0.7)
          : GameConstants.nightTimeColor.withOpacity(0.7),
      child: Center(
        child: AnimatedScale(
          duration: GameConstants.phaseTransitionDuration,
          scale: isVisible ? 1.0 : 0.0,
          child: Card(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    dayPhase == DayPhase.day
                        ? Icons.wb_sunny
                        : Icons.nightlight_round,
                    size: 48,
                    color: dayPhase == DayPhase.day
                        ? Colors.orange
                        : Colors.indigo,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getTransitionMessage(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getTransitionMessage() {
    switch (phase) {
      case GamePhase.playerHiding:
        return dayPhase == DayPhase.day
            ? "Hide the Baby!"
            : "The Werewolf Must Hide!";
      case GamePhase.npcSeeking:
        return "The Nanny is Looking!";
      case GamePhase.playerSeeking:
        return dayPhase == DayPhase.day
            ? "Find the Nanny!"
            : "Hunt Down the Nanny!";
    }
  }
}
