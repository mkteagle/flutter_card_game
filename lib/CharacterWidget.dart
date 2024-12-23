import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/GameTypes.dart';
import '../models/GameConstants.dart';

class CharacterWidget extends StatelessWidget {
  final CharacterType type;
  final double size;
  final bool isDraggable;
  final bool showRemoveButton;
  final VoidCallback? onRemove;

  const CharacterWidget({
    Key? key,
    required this.type,
    this.size = GameConstants.defaultCharacterSize,
    this.isDraggable = false,
    this.showRemoveButton = false,
    this.onRemove,
  }) : super(key: key);

  String _getAssetPath() {
    switch (type) {
      case CharacterType.baby:
        return 'assets/emojis/baby.svg';
      case CharacterType.werewolf:
        return 'assets/emojis/werewolf.svg';
      case CharacterType.nanny:
        return 'assets/emojis/nanny.svg';
    }
  }

  Widget _buildCharacter() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: SvgPicture.asset(
            _getAssetPath(),
            width: size,
            height: size,
          ),
        ),
        if (showRemoveButton && onRemove != null)
          Positioned(
            right: -8,
            top: -8,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isDraggable) {
      return Draggable<CharacterType>(
        data: type,
        feedback: _buildCharacter(),
        childWhenDragging: Container(),
        child: _buildCharacter(),
      );
    }
    return _buildCharacter();
  }
}
