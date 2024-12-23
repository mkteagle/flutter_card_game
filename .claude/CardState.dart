import 'package:flutter/foundation.dart';

class CardState {
  final int index;
  bool isFaceUp;
  bool isRevealed;

  CardState({
    required this.index,
    this.isFaceUp = true,
    this.isRevealed = false,
  });
}

class CardStateManager extends ChangeNotifier {
  List<CardState> cards;

  CardStateManager()
      : cards = List.generate(52, (index) => CardState(index: index));

  void flipAll(bool faceUp) {
    for (var card in cards) {
      card.isFaceUp = faceUp;
    }
    notifyListeners();
  }

  void flipCard(int index, bool faceUp) {
    if (index >= 0 && index < cards.length) {
      cards[index].isFaceUp = faceUp;
      notifyListeners();
    }
  }

  bool isCardFaceUp(int index) {
    if (index >= 0 && index < cards.length) {
      return cards[index].isFaceUp;
    }
    return false;
  }

  List<int> getFaceDownCards() {
    return cards
        .where((card) => !card.isFaceUp)
        .map((card) => card.index)
        .toList();
  }

  void reset() {
    for (var card in cards) {
      card.isFaceUp = true;
      card.isRevealed = false;
    }
    notifyListeners();
  }
}
