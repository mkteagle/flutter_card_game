import 'package:flutter/material.dart';
import '../controllers/GameController.dart';
import '../models/GameTypes.dart';
import '../models/GameConstants.dart';

class GameStatus extends StatelessWidget {
  final GameController gameController;

  const GameStatus({
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
      listenable: gameController,
      builder: (context, _) {
        final isDay = gameController.phaseController.dayPhase == DayPhase.day;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDay
                  ? [GameConstants.dayBgStart, GameConstants.dayBgEnd]
                  : [GameConstants.nightBgStart, GameConstants.nightBgEnd],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: const Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        isDay ? Icons.wb_sunny : Icons.nightlight_round,
                        size: 32,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isDay ? 'Day Time' : 'Night Time',
                        style: GameConstants.headlineStyle,
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${gameController.timerController.remainingSeconds}s',
                      style: GameConstants.timerStyle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getGamePhaseMessage(),
                  style: GameConstants.headlineStyle.copyWith(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildScoreCard(
                    isDay ? 'Baby' : 'Werewolf',
                    gameController.scoreController.playerScore,
                    GameConstants.playerScoreColor,
                  ),
                  const SizedBox(width: 16),
                  _buildScoreCard(
                    'Nanny',
                    gameController.scoreController.npcScore,
                    GameConstants.npcScoreColor,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScoreCard(String label, int score, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GameConstants.scoreStyle.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(
            score.toString(),
            style: GameConstants.scoreStyle,
          ),
        ],
      ),
    );
  }
}
