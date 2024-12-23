import 'package:flutter/material.dart';
import 'package:flutter_cards/CharacterWidget.dart';
import 'package:flutter_cards/controllers/FlippingCardController.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../controllers/GameController.dart';
import '../models/GameTypes.dart';

class FlippingCard extends StatefulWidget {
  final String frontAsset;
  final String backAsset;
  final int index;
  final GameController gameController;

  const FlippingCard({
    Key? key,
    required this.frontAsset,
    required this.backAsset,
    required this.index,
    required this.gameController,
  }) : super(key: key);

  @override
  _FlippingCardState createState() => _FlippingCardState();
}

class _FlippingCardState extends State<FlippingCard>
    with SingleTickerProviderStateMixin {
  late FlippingCardController cardController;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    cardController = FlippingCardController(
      animationController: animationController,
      onFlipComplete: () {
        if (mounted) setState(() {});
      },
    );

    widget.gameController.cardController.registerCard(widget.index, (animate) {
      bool shouldBeFaceUp =
          widget.gameController.cardController.isFaceUp(widget.index);
      if (shouldBeFaceUp) {
        cardController.flipToFront(animate: animate);
      } else {
        cardController.flipToBack(animate: animate);
      }
    });
  }

  CharacterType _getBadgeCharacter() {
    final isDay = widget.gameController.currentDayPhase == DayPhase.day;
    final isHiding = widget.gameController.phaseController.currentPhase ==
        GamePhase.playerHiding;

    if (isHiding) {
      return isDay ? CharacterType.baby : CharacterType.werewolf;
    }

    return CharacterType.nanny;
  }

  Widget _buildBadge() {
    final isPlayerHiding = widget.gameController.phaseController.currentPhase ==
        GamePhase.playerHiding;

    return Positioned(
      top: 8,
      right: 8,
      child: CharacterWidget(
        type: _getBadgeCharacter(),
        size: 32,
        showRemoveButton: isPlayerHiding,
        onRemove: isPlayerHiding
            ? () {
                widget.gameController.cardController.resetBadge();
              }
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int?>(
      valueListenable:
          widget.gameController.cardController.badgeCardIndexNotifier,
      builder: (context, badgeCardIndex, child) {
        final showBadge = badgeCardIndex == widget.index;

        return DragTarget<int>(
          onWillAcceptWithDetails: (data) {
            return widget.gameController.phaseController.currentPhase ==
                GamePhase.playerHiding;
          },
          onAcceptWithDetails: (data) {
            widget.gameController.submitPlayerHiding(widget.index);
          },
          builder: (context, candidateData, rejectedData) {
            return GestureDetector(
              onTap: () {
                if (widget.gameController.phaseController.currentPhase ==
                    GamePhase.playerSeeking) {
                  widget.gameController.checkPlayerGuess(widget.index);
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: animationController,
                    builder: (context, child) {
                      final angle = animationController.value * 3.14;
                      final isFrontVisible = angle < 3.14 / 2;

                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(angle),
                        child: isFrontVisible
                            ? SvgPicture.asset(widget.frontAsset)
                            : Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()..rotateY(3.14),
                                child: SvgPicture.asset(widget.backAsset),
                              ),
                      );
                    },
                  ),
                  if (showBadge) _buildBadge(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    cardController.dispose();
    super.dispose();
  }
}
