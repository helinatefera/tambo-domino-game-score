class LeaderboardEntry {
  final String playerName;
  final int winCount;
  final int totalScore;
  final DateTime lastWinDate;
  final DateTime firstWinDate;

  LeaderboardEntry({
    required this.playerName,
    required this.winCount,
    required this.totalScore,
    required this.lastWinDate,
    required this.firstWinDate,
  });

  Map<String, dynamic> toJson() => {
        'playerName': playerName,
        'winCount': winCount,
        'totalScore': totalScore,
        'lastWinDate': lastWinDate.toIso8601String(),
        'firstWinDate': firstWinDate.toIso8601String(),
      };

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      LeaderboardEntry(
        playerName: json['playerName'],
        winCount: json['winCount'] ?? 1, // For backward compatibility
        totalScore:
            json['totalScore'] ?? json['score'] ?? 0, // Support old format
        lastWinDate: json['lastWinDate'] != null
            ? DateTime.parse(json['lastWinDate'])
            : (json['date'] != null
                ? DateTime.parse(json['date'])
                : DateTime.now()),
        firstWinDate: json['firstWinDate'] != null
            ? DateTime.parse(json['firstWinDate'])
            : (json['date'] != null
                ? DateTime.parse(json['date'])
                : DateTime.now()),
      );
}

