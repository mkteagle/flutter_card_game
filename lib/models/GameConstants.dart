import 'dart:math';
import 'package:flutter/material.dart';

class GameConstants {
  // Game rules
  static const int roundsPerPhase = 3;
  static const int pointsForFindingNPC = 1;
  static const int pointsForNPCFindingPlayer = 1;
  static const int pointsForEvadingNPC = 1;

  // Timer durations
  static const int npcSeekingDuration = 30;
  static const int transitionDuration = 1;
  static const int npcSearchInterval = 2;

  // Card layout
  static const double minCardWidth = 80.0;
  static const double cardPadding = 8.0;
  static const double cardAspectRatio = 2.5 / 3.5;
  static const double cardElevation = 8.0;

  // Character sizes
  static const double defaultCharacterSize = 40.0;
  static const double miniCharacterSize = 30.0;
  static const double badgeCharacterSize = 24.0;

  // Animation durations
  static const Duration cardFlipAnimationDuration = Duration(milliseconds: 300);
  static const Duration phaseTransitionDuration = Duration(seconds: 1);
  static const Duration foundDelay = Duration(milliseconds: 1000);

  // Asset paths
  static const String backCardAsset = 'assets/playing_card_back.svg';

  // Sound effects
  static const String cardFlipSound = 'sounds/card_flip.mp3';
  static const String foundTargetSound = 'sounds/found_target.mp3';
  static const String sunriseSound = 'sounds/sunrise.mp3';
  static const String sunsetSound = 'sounds/sunset.mp3';

  // Colors
  static const Color dayTimeColor = Color(0xFF87CEEB);
  static const Color nightTimeColor = Color(0xFF1A237E);

  // Theme Colors
  static const Color primaryColor = Color(0xFF6200EA);
  static const Color accentColor = Color(0xFFFF4081);
  static const Color dayBgStart = Color(0xFFFFF9C4);
  static const Color dayBgEnd = Color(0xFFFFE0B2);
  static const Color nightBgStart = Color(0xFF1A237E);
  static const Color nightBgEnd = Color(0xFF311B92);
  static const Color playerScoreColor = Color(0xFF4CAF50);
  static const Color npcScoreColor = Color(0xFFF44336);

  // Text Styles
  static const TextStyle headlineStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    shadows: [
      Shadow(
        color: Colors.black26,
        offset: Offset(2, 2),
        blurRadius: 4,
      ),
    ],
  );

  static const TextStyle scoreStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    shadows: [
      Shadow(
        color: Colors.black26,
        offset: Offset(1, 1),
        blurRadius: 2,
      ),
    ],
  );

  static const TextStyle timerStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    shadows: [
      Shadow(
        color: Colors.black38,
        offset: Offset(2, 2),
        blurRadius: 4,
      ),
    ],
  );
}

// Standard playing card assets
final List<String> cardAssets = _getShuffledCardAssets();

List<String> _getShuffledCardAssets() {
  final cards = [
    'assets/cards/2_of_clubs.svg',
    'assets/cards/2_of_diamonds.svg',
    'assets/cards/2_of_hearts.svg',
    'assets/cards/2_of_spades.svg',
    'assets/cards/3_of_clubs.svg',
    'assets/cards/3_of_diamonds.svg',
    'assets/cards/3_of_hearts.svg',
    'assets/cards/3_of_spades.svg',
    'assets/cards/4_of_clubs.svg',
    'assets/cards/4_of_diamonds.svg',
    'assets/cards/4_of_hearts.svg',
    'assets/cards/4_of_spades.svg',
    'assets/cards/5_of_clubs.svg',
    'assets/cards/5_of_diamonds.svg',
    'assets/cards/5_of_hearts.svg',
    'assets/cards/5_of_spades.svg',
    'assets/cards/6_of_clubs.svg',
    'assets/cards/6_of_diamonds.svg',
    'assets/cards/6_of_hearts.svg',
    'assets/cards/6_of_spades.svg',
    'assets/cards/7_of_clubs.svg',
    'assets/cards/7_of_diamonds.svg',
    'assets/cards/7_of_hearts.svg',
    'assets/cards/7_of_spades.svg',
    'assets/cards/8_of_clubs.svg',
    'assets/cards/8_of_diamonds.svg',
    'assets/cards/8_of_hearts.svg',
    'assets/cards/8_of_spades.svg',
    'assets/cards/9_of_clubs.svg',
    'assets/cards/9_of_diamonds.svg',
    'assets/cards/9_of_hearts.svg',
    'assets/cards/9_of_spades.svg',
    'assets/cards/10_of_clubs.svg',
    'assets/cards/10_of_diamonds.svg',
    'assets/cards/10_of_hearts.svg',
    'assets/cards/10_of_spades.svg',
    'assets/cards/ace_of_clubs.svg',
    'assets/cards/ace_of_diamonds.svg',
    'assets/cards/ace_of_hearts.svg',
    'assets/cards/ace_of_spades.svg',
    'assets/cards/jack_of_clubs.svg',
    'assets/cards/jack_of_diamonds.svg',
    'assets/cards/jack_of_hearts.svg',
    'assets/cards/jack_of_spades.svg',
    'assets/cards/king_of_clubs.svg',
    'assets/cards/king_of_diamonds.svg',
    'assets/cards/king_of_hearts.svg',
    'assets/cards/king_of_spades.svg',
    'assets/cards/queen_of_clubs.svg',
    'assets/cards/queen_of_diamonds.svg',
    'assets/cards/queen_of_hearts.svg',
    'assets/cards/queen_of_spades.svg',
  ];

  // Create a Random instance outside of the shuffle to ensure better randomization
  final random = Random();

  // Fisher-Yates shuffle algorithm
  for (int i = cards.length - 1; i > 0; i--) {
    int j = random.nextInt(i + 1);
    String temp = cards[i];
    cards[i] = cards[j];
    cards[j] = temp;
  }

  return cards;
}
