import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingCardPlaceholder extends StatelessWidget {
  final double width;
  final double height;

  const LoadingCardPlaceholder({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
