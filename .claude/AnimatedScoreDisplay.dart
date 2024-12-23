import 'package:flutter/material.dart';

class AnimatedScoreDisplay extends StatelessWidget {
  final int score;
  final TextStyle textStyle;

  const AnimatedScoreDisplay({
    Key? key,
    required this.score,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: score.toDouble()),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Text(
          value.toInt().toString(),
          style: textStyle,
        );
      },
    );
  }
}
