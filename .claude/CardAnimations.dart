import 'package:flutter/material.dart';
import 'package:flutter_cards/models/GameConstants.dart';

class CardAnimationController {
  final AnimationController controller;
  late final Animation<double> flipAnimation;
  late final Animation<double> scaleAnimation;
  late final Animation<double> elevationAnimation;

  CardAnimationController({required TickerProvider vsync})
      : controller = AnimationController(
          duration: GameConstants.cardFlipAnimationDuration,
          vsync: vsync,
        ) {
    // Flip animation
    flipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutQuad,
    ));

    // Scale animation during flip
    scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.1)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.1, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(controller);

    // Elevation animation
    elevationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 2, end: 8)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 8, end: 2)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(controller);
  }

  void flip({bool forward = true}) {
    if (forward) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  void dispose() {
    controller.dispose();
  }
}
