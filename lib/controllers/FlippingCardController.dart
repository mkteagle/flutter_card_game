import 'package:flutter/material.dart';

class FlippingCardController {
  final AnimationController animationController;
  final VoidCallback onFlipComplete;
  bool _isFaceUp = true;

  FlippingCardController({
    required this.animationController,
    required this.onFlipComplete,
  });

  bool get isFaceUp => _isFaceUp;

  void flipToFront({bool animate = true}) {
    if (!_isFaceUp) {
      _isFaceUp = true;
      if (animate) {
        animationController.reverse().then((_) => onFlipComplete());
      } else {
        animationController.value = 0;
        onFlipComplete();
      }
    }
  }

  void flipToBack({bool animate = true}) {
    if (_isFaceUp) {
      _isFaceUp = false;
      if (animate) {
        animationController.forward().then((_) => onFlipComplete());
      } else {
        animationController.value = 1;
        onFlipComplete();
      }
    }
  }

  void toggleFlip() {
    if (_isFaceUp) {
      flipToBack();
    } else {
      flipToFront();
    }
  }

  void dispose() {
    animationController.dispose();
  }
}
