import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FlippingCard extends StatefulWidget {
  final String frontAsset;
  final String backAsset;

  const FlippingCard({
    Key? key,
    required this.frontAsset,
    required this.backAsset,
  }) : super(key: key);

  @override
  _FlippingCardState createState() => _FlippingCardState();
}

class _FlippingCardState extends State<FlippingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  void _flipCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _isFront = !_isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * 3.14;
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
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
