// Represents the current phase of gameplay
enum GamePhase {
  playerHiding, // Player hides at start of round
  npcSeeking, // Nanny tries to find player
  playerSeeking // Player tries to find nanny
}

// Represents the time of day which affects player roles
enum DayPhase {
  day, // Player is baby, NPC is nanny seeking
  night // Player is werewolf, nanny is hiding
}

// Represents different character types
enum CharacterType {
  baby, // Player during day
  werewolf, // Player during night
  nanny // The NPC (seeking during day, hiding during night)
}

// Class to track hiding positions
class HidingSpot {
  final int position;
  final CharacterType character;

  const HidingSpot({
    required this.position,
    required this.character,
  });
}

// Class to track scoring events
class ScoreEvent {
  final int points;
  final String reason;
  final bool isPlayerScore;

  const ScoreEvent({
    required this.points,
    required this.reason,
    required this.isPlayerScore,
  });
}
