import 'dart:math';

final List<String> cardAssets = [
  'assets/ace_of_clubs.svg',
  'assets/ace_of_diamonds.svg',
  'assets/2_of_hearts.svg',
  'assets/3_of_spades.svg',
  'assets/king_of_clubs.svg',
  // Add all your card assets here
];

List<String> getRandomCards(int count) {
  final random = Random();
  final selectedCards = cardAssets..shuffle(random);
  return selectedCards.take(count).toList();
}
