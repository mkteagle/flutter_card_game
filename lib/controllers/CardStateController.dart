import 'dart:math';

import 'package:flutter/foundation.dart';

class CardStateController extends ChangeNotifier {
  final Map<int, bool> _cardsAreFaceUp = {};
  final Map<int, void Function(bool)> _cardCallbacks =
      {}; // Fixed function signature
  final ValueNotifier<int?> badgeCardIndexNotifier = ValueNotifier<int?>(null);
  final ValueNotifier<bool> babyInStartPositionNotifier =
      ValueNotifier<bool>(true);

  void registerCard(int index, void Function(bool) flipCallback) {
    _cardCallbacks[index] = flipCallback;
    _cardsAreFaceUp[index] = true;
  }

  bool isFaceUp(int index) => _cardsAreFaceUp[index] ?? true;

  void flipCard(int index) {
    if (_cardsAreFaceUp.containsKey(index)) {
      _cardsAreFaceUp[index] = !_cardsAreFaceUp[index]!;
      _cardCallbacks[index]?.call(true);
      notifyListeners();
    }
  }

  void flipRandomCard() {
    final faceDownIndices = _cardsAreFaceUp.keys
        .where((index) => !_cardsAreFaceUp[index]!)
        .toList();

    if (faceDownIndices.isNotEmpty) {
      final randomIndex =
          faceDownIndices[Random().nextInt(faceDownIndices.length)];
      _cardsAreFaceUp[randomIndex] = true;
      _cardCallbacks[randomIndex]?.call(true);
      notifyListeners();
    }
  }

  void resetCardsToFaceDown() {
    for (var index in _cardsAreFaceUp.keys) {
      if (_cardsAreFaceUp[index] == true) {
        _cardsAreFaceUp[index] = false;
        _cardCallbacks[index]?.call(false);
      }
    }
    notifyListeners();
  }

  void resetAllCards() {
    for (var index in _cardsAreFaceUp.keys) {
      _cardsAreFaceUp[index] = true;
      _cardCallbacks[index]?.call(false);
    }
    notifyListeners();
  }

  void resetBadge() {
    badgeCardIndexNotifier.value = null;
    babyInStartPositionNotifier.value = true;
    notifyListeners();
  }

  @override
  void dispose() {
    badgeCardIndexNotifier.dispose();
    babyInStartPositionNotifier.dispose();
    super.dispose();
  }
}
