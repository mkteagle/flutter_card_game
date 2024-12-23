import 'package:flutter/material.dart';
import '../controllers/GameController.dart';
import '../models/GameTypes.dart';

class GameHeader extends StatelessWidget {
  final GameController gameController;

  const GameHeader({
    Key? key,
    required this.gameController,
  }) : super(key: key);

  String _getGamePhaseMessage() {
    switch (gameController.phaseController.currentPhase) {
      case GamePhase.playerHiding:
        return gameController.phaseController.dayPhase == DayPhase.day
            ? 'Hide the baby!'
            : 'The werewolf must hide!';
      case GamePhase.npcSeeking:
        return 'The nanny is looking for you!';
      case GamePhase.playerSeeking:
        return gameController.phaseController.dayPhase == DayPhase.day
            ? 'Find the nanny!'
            : 'Hunt down the nanny!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        gameController,
        gameController.timerController,
      ]),
      builder: (context, _) {
        final isDay = gameController.phaseController.dayPhase == DayPhase.day;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDay
                  ? [
                      const Color(0xFF6366F1).withOpacity(0.95),
                      const Color(0xFF4F46E5).withOpacity(0.95),
                    ]
                  : [
                      const Color(0xFF1E1B4B).withOpacity(0.95),
                      const Color(0xFF312E81).withOpacity(0.95),
                    ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side - Phase indicators
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isDay ? Icons.light_mode : Icons.dark_mode,
                              size: 18,
                              color: isDay
                                  ? const Color(0xFFFCD34D)
                                  : const Color(0xFF93C5FD),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isDay ? 'Day Phase' : 'Night Phase',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          _getGamePhaseMessage(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Right side - Scores and Timer
                  Row(
                    children: [
                      _buildScoreChip(
                        isDay ? 'Baby' : 'Werewolf',
                        gameController.scoreController.playerScore,
                        const Color(0xFF4ADE80),
                      ),
                      const SizedBox(width: 8),
                      _buildScoreChip(
                        'Nanny',
                        gameController.scoreController.npcScore,
                        const Color(0xFFF43F5E),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.timer_outlined,
                              size: 16,
                              color: Colors.white70,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${gameController.timerController.remainingSeconds}s',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildScoreChip(String label, int score, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              score.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
