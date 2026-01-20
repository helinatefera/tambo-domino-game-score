import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../widgets/premium_navbar.dart';
import '../widgets/domino_background.dart';
import '../widgets/banner_ad_widget.dart';
import '../utils/ad_helper.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();

  static void refresh() {
    // This can be called to refresh the leaderboard
    // The screen will refresh when navigated to
  }
}

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

class _RankingScreenState extends State<RankingScreen> {
  List<LeaderboardEntry> _leaderboard = [];

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload leaderboard when screen becomes visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLeaderboard();
    });
  }

  Future<void> _loadLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();
    final leaderboardJson = prefs.getString('leaderboard');

    if (leaderboardJson != null) {
      final List<dynamic> decoded = json.decode(leaderboardJson);
      setState(() {
        _leaderboard =
            decoded.map((entry) => LeaderboardEntry.fromJson(entry)).toList()
              ..sort((a, b) {
                // Sort by win count first, then by total score
                if (b.winCount != a.winCount) {
                  return b.winCount.compareTo(a.winCount);
                }
                return b.totalScore.compareTo(a.totalScore);
              });
      });
    }
  }

  Future<void> _saveLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();
    final leaderboardJson = json.encode(
      _leaderboard.map((entry) => entry.toJson()).toList(),
    );
    await prefs.setString('leaderboard', leaderboardJson);
  }

  void _addTestEntry() {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController();
        final scoreController = TextEditingController();

        return AlertDialog(
          title: const Text('Add Leaderboard Entry'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Player Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: scoreController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Score',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    scoreController.text.isNotEmpty) {
                  final score = int.tryParse(scoreController.text);
                  if (score != null) {
                    setState(() {
                      final now = DateTime.now();
                      _leaderboard.add(
                        LeaderboardEntry(
                          playerName: nameController.text,
                          winCount: 1,
                          totalScore: score,
                          lastWinDate: now,
                          firstWinDate: now,
                        ),
                      );
                      _leaderboard.sort((a, b) {
                        if (b.winCount != a.winCount) {
                          return b.winCount.compareTo(a.winCount);
                        }
                        return b.totalScore.compareTo(a.totalScore);
                      });
                    });
                    _saveLeaderboard();
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _clearLeaderboard() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Leaderboard?'),
        content: const Text('This will delete all saved leaderboard entries.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _leaderboard.clear();
              });
              _saveLeaderboard();
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: DominoBackground(
        opacity: 0.4,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.surface.withValues(alpha: 0.7),
                colorScheme.surface.withValues(alpha: 0.6),
                Theme.of(
                  context,
                ).scaffoldBackgroundColor.withValues(alpha: 0.7),
              ],
            ),
          ),
          child: Stack(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: _leaderboard.isEmpty
                          ? _buildEmptyState()
                          : _buildLeaderboardList(),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BannerAdWidget(adUnitId: AdHelper.bannerAdUnitId),
                    PremiumGlassNavbar(
                      currentIndex: 1,
                      items: [
                        NavItem(
                          icon: Icons.videogame_asset_rounded,
                          label: 'Play',
                        ),
                        NavItem(
                          icon: Icons.emoji_events_rounded,
                          label: 'Rank',
                        ),
                        NavItem(
                          icon: Icons.settings_rounded,
                          label: 'Settings',
                        ),
                        NavItem(
                          icon: Icons.help_outline_rounded,
                          label: 'Help',
                        ),
                        NavItem(icon: Icons.share_rounded, label: 'Share'),
                      ],
                      onTap: (index) {
                        switch (index) {
                          case 0:
                            Navigator.pushReplacementNamed(context, '/scorer');
                            break;
                          case 1:
                            // Already on Ranking
                            break;
                          case 2:
                            Navigator.pushReplacementNamed(
                              context,
                              '/settings',
                            );
                            break;
                          case 3:
                            Navigator.pushNamed(context, '/help');
                            break;
                          case 4:
                            Navigator.pushNamed(context, '/share');
                            break;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'RANKING',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _addTestEntry,
                icon: Icon(
                  Icons.add_circle_outline,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                tooltip: 'Add Entry',
              ),
              if (_leaderboard.isNotEmpty)
                IconButton(
                  onPressed: _clearLeaderboard,
                  icon: Icon(
                    Icons.delete_outline,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  tooltip: 'Clear Leaderboard',
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 80,
            color: colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No Leaderboard Entries',
            style: TextStyle(
              fontSize: 20,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add entries to track top scores',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList() {
    return ListView.builder(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).size.height * 0.12,
      ),
      itemCount: _leaderboard.length,
      itemBuilder: (context, index) {
        final entry = _leaderboard[index];
        final rank = index + 1;

        final colorScheme = Theme.of(context).colorScheme;
        return Card(
          color: colorScheme.onSurface.withValues(alpha: 0.08),
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: colorScheme.onSurface.withValues(alpha: 0.1),
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            leading: CircleAvatar(
              backgroundColor: _getRankColor(rank),
              child: Text(
                '$rank',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              entry.playerName,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.emoji_events_rounded,
                      size: 14,
                      color: _getRankColor(rank),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${entry.winCount} ${entry.winCount == 1 ? 'win' : 'wins'}',
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.score_rounded,
                      size: 14,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${entry.totalScore} total pts',
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Last win: ${entry.lastWinDate.day}/${entry.lastWinDate.month}/${entry.lastWinDate.year}',
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getRankColor(rank).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getRankColor(rank).withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${entry.winCount}x',
                    style: TextStyle(
                      color: _getRankColor(rank),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getRankColor(int rank) {
    if (rank == 1) return Colors.amber;
    if (rank == 2) return Colors.grey.shade400;
    if (rank == 3) return Colors.brown.shade300;
    return Theme.of(context).colorScheme.primary;
  }
}
