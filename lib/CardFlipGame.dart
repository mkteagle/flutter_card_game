import 'package:flutter/material.dart';
import 'package:flutter_cards/FlippingCard.dart';
import 'utils.dart';

class CardFlipGame extends StatelessWidget {
  final List<String> cards = getRandomCards(5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Poker Card Flip Animation')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate card size dynamically
          final totalGap = 16 * 4; // 16px gap between 5 cards
          final cardWidth = (constraints.maxWidth - totalGap - 32) /
              5; // Adjust for padding and gaps
          final cardHeight = cardWidth *
              1.5; // Maintain card aspect ratio (width:height = 2:3)

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Ensure equal spacing
              children: cards.map((card) {
                return SizedBox(
                  width: cardWidth,
                  height: cardHeight,
                  child: FlippingCard(
                    frontAsset: card,
                    backAsset: 'assets/playing_card_back.svg',
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
