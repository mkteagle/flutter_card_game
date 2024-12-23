import 'package:flutter/material.dart';
import 'package:flutter_cards/controllers/CardStateController.dart';
import 'package:flutter_cards/controllers/GamePhaseController.dart';
import 'package:flutter_cards/controllers/GameScoreController.dart';
import 'package:flutter_cards/controllers/GameTimerController.dart';
import 'package:flutter_cards/services/SoundManager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controllers/GameController.dart';
import '../models/GameTypes.dart';
import '../models/GameConstants.dart';
import 'FlippingCard.dart';
import 'GameHeader.dart';
import 'PhaseTransition.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late final GameController _gameController;
  final List<String> _cardAssets = cardAssets;

  @override
  void initState() {
    super.initState();

    // Create timer controller first since others depend on it
    final timerController = GameTimerController(
      phaseController: GamePhaseController(),
      scoreController: GameScoreController(),
      soundManager: SoundManager(),
    );

    _gameController = GameController(
      phaseController: timerController.phaseController,
      timerController: timerController,
      cardController: CardStateController(),
      scoreController: timerController.scoreController,
    );
  }

  Widget _buildDraggableBadge() {
    return ValueListenableBuilder<bool>(
      valueListenable:
          _gameController.cardController.babyInStartPositionNotifier,
      builder: (context, babyInStartPosition, _) {
        if (_gameController.phaseController.currentPhase ==
                GamePhase.playerHiding &&
            babyInStartPosition) {
          return Draggable<int>(
            data: 0,
            feedback: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 24,
              child: SvgPicture.asset(
                'assets/emojis/baby.svg',
                width: 32,
                height: 32,
              ),
            ),
            childWhenDragging: const SizedBox.shrink(),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 24,
              child: SvgPicture.asset(
                'assets/emojis/baby.svg',
                width: 32,
                height: 32,
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GameHeader(gameController: _gameController),
          Expanded(
            child: Stack(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final aspectRatio = GameConstants.cardAspectRatio;
                    final padding = GameConstants.cardPadding;
                    final minCardWidth = GameConstants.minCardWidth;

                    int crossAxisCount =
                        (constraints.maxWidth / (minCardWidth + padding * 2))
                            .floor()
                            .clamp(1, 13);

                    return Padding(
                      padding: EdgeInsets.all(padding),
                      child: GridView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: aspectRatio,
                          crossAxisSpacing: padding,
                          mainAxisSpacing: padding,
                        ),
                        itemCount: _cardAssets.length,
                        itemBuilder: (context, index) {
                          return FlippingCard(
                            frontAsset: _cardAssets[index],
                            backAsset: GameConstants.backCardAsset,
                            gameController: _gameController,
                            index: index,
                          );
                        },
                      ),
                    );
                  },
                ),
                ValueListenableBuilder<bool>(
                  valueListenable:
                      _gameController.phaseController.isTransitioningNotifier,
                  builder: (context, isTransitioning, _) {
                    return PhaseTransition(
                      phase: _gameController.phaseController.currentPhase,
                      dayPhase: _gameController.phaseController.dayPhase,
                      isVisible: isTransitioning,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDraggableBadge(),
          const SizedBox(width: 16),
          ListenableBuilder(
            listenable: Listenable.merge([
              _gameController.cardController.babyInStartPositionNotifier,
              _gameController.phaseController.currentPhaseNotifier,
            ]),
            builder: (context, _) {
              final babyInStartPosition = _gameController
                  .cardController.babyInStartPositionNotifier.value;
              final currentPhase = _gameController.phaseController.currentPhase;

              if (!babyInStartPosition &&
                  currentPhase == GamePhase.playerHiding &&
                  _gameController.readyToStart) {
                return FloatingActionButton.extended(
                  onPressed: () => _gameController.startNpcSeekingPhase(),
                  backgroundColor: GameConstants.primaryColor,
                  label: const Text("Let's Begin"),
                  icon: const Icon(Icons.play_arrow),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  @override
  void dispose() {
    _gameController.dispose();
    super.dispose();
  }
}
