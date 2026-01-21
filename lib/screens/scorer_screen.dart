import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../main.dart';
import 'ranking_screen.dart';
import '../widgets/premium_navbar.dart';
import '../widgets/domino_background.dart';


class ScorerScreen extends StatefulWidget {
  const ScorerScreen({super.key});

  @override
  State<ScorerScreen> createState() => ScorerScreenState();
}

class ScorerScreenState extends State<ScorerScreen> {
  List<String> _playerNames = [];
  List<List<int>> _playerScores = [];
  int _currentRound = 1;
  int _targetScore = 100;
  bool _isLoading = true;
  bool _hasWinner = false;
  final List<TextEditingController> _scoreControllers = [];

  @override
  void dispose() {
    for (var controller in _scoreControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Load data immediately
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // Load synchronously to set initial state before first build
    final prefs = await SharedPreferences.getInstance();
    final numPlayers = prefs.getInt('numberOfPlayers') ?? 2;
    final targetScore = prefs.getInt('targetScore') ?? 100;
    final namesJson = prefs.getString('playerNames');

    List<String> names = [];
    if (namesJson != null) {
      try {
        names = List<String>.from(json.decode(namesJson));
      } catch (e) {
        names = [];
      }
    }

    while (names.length < numPlayers) {
      names.add('Player ${names.length + 1}');
    }
    if (names.length > numPlayers) {
      names = names.sublist(0, numPlayers);
    }

    // Initialize controllers immediately
    for (int i = 0; i < numPlayers; i++) {
      _scoreControllers.add(TextEditingController(text: '0'));
    }

    // Set initial state before first build
    if (mounted) {
      setState(() {
        _playerNames = names;
        _targetScore = targetScore;
        _isLoading = false;
      });
    }

    // Then load scores and other data
    await refresh();
  }

  Future<void> refresh() async {
    final prefs = await SharedPreferences.getInstance();
    final numPlayers = prefs.getInt('numberOfPlayers') ?? 2;
    final targetScore = prefs.getInt('targetScore') ?? 100;
    final namesJson = prefs.getString('playerNames');

    List<String> names = [];
    if (namesJson != null) {
      names = List<String>.from(json.decode(namesJson));
    }

    while (names.length < numPlayers) {
      names.add('Player ${names.length + 1}');
    }
    if (names.length > numPlayers) {
      names = names.sublist(0, numPlayers);
    }

    final scoresJson = prefs.getString('current_game_scores');
    final currentRound = prefs.getInt('current_game_round') ?? 1;
    List<List<int>> scores = List.generate(numPlayers, (_) => []);

    if (scoresJson != null) {
      try {
        final decoded = json.decode(scoresJson) as List<dynamic>;
        for (int i = 0; i < decoded.length && i < numPlayers; i++) {
          scores[i] = List<int>.from(decoded[i]);
        }
      } catch (e) {
        debugPrint('Error loading scores: $e');
      }
    }

    // Dispose old controllers
    for (var controller in _scoreControllers) {
      controller.dispose();
    }
    _scoreControllers.clear();
    for (int i = 0; i < numPlayers; i++) {
      _scoreControllers.add(TextEditingController(text: '0'));
    }

    setState(() {
      _playerNames = names;
      _playerScores = scores;
      _currentRound = currentRound;
      _targetScore = targetScore;
      _isLoading = false;
      _hasWinner = false;
    });

    _checkWinCondition(silent: true);
  }

  Future<void> _saveGameData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_game_scores', json.encode(_playerScores));
    await prefs.setInt('current_game_round', _currentRound);
  }

  void _checkWinCondition({bool silent = false}) async {
    if (_targetScore <= 0 || _hasWinner) return;

    for (int i = 0; i < _playerScores.length; i++) {
      final total = _playerScores[i].fold(0, (a, b) => a + b);
      if (total >= _targetScore) {
        _hasWinner = true;
        await _saveWinnerToRanking(_playerNames[i], total);
        if (!silent) {
          _showWinnerCelebration(_playerNames[i]);
        }
        break;
      }
    }
  }

  Future<void> _saveWinnerToRanking(String playerName, int finalScore) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final leaderboardJson = prefs.getString('leaderboard');

      List<LeaderboardEntry> leaderboard = [];
      if (leaderboardJson != null) {
        final List<dynamic> decoded = json.decode(leaderboardJson);
        leaderboard = decoded
            .map((entry) => LeaderboardEntry.fromJson(entry))
            .toList();
      }

      final existingIndex = leaderboard.indexWhere(
        (entry) => entry.playerName.toLowerCase() == playerName.toLowerCase(),
      );

      if (existingIndex >= 0) {
        final existing = leaderboard[existingIndex];
        leaderboard[existingIndex] = LeaderboardEntry(
          playerName: existing.playerName,
          winCount: existing.winCount + 1,
          totalScore: existing.totalScore + finalScore,
          lastWinDate: DateTime.now(),
          firstWinDate: existing.firstWinDate,
        );
      } else {
        leaderboard.add(
          LeaderboardEntry(
            playerName: playerName,
            winCount: 1,
            totalScore: finalScore,
            lastWinDate: DateTime.now(),
            firstWinDate: DateTime.now(),
          ),
        );
      }

      leaderboard.sort((a, b) {
        if (b.winCount != a.winCount) return b.winCount.compareTo(a.winCount);
        return b.totalScore.compareTo(a.totalScore);
      });

      await prefs.setString(
        'leaderboard',
        json.encode(leaderboard.map((e) => e.toJson()).toList()),
      );
    } catch (e) {
      debugPrint('Error saving winner to ranking: $e');
    }
  }

  void _showWinnerCelebration(String winnerName) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.85),
      transitionDuration: const Duration(milliseconds: 600),
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  duration: const Duration(seconds: 1),
                  tween: Tween(begin: 0, end: 1),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Opacity(opacity: value, child: child),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amber.withValues(alpha: 0.15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withValues(alpha: 0.2),
                          blurRadius: 50,
                          spreadRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.emoji_events_rounded,
                      size: 100,
                      color: Colors.amber,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'VICTORY!',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 8,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  winnerName.toUpperCase(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2,
                    color: Colors.amber.shade200,
                  ),
                ),
                const SizedBox(height: 60),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _reset();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'NEW GAME',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'BACK TO SCOREBOARD',
                    style: TextStyle(color: Colors.white38),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _reset() {
    setState(() {
      for (var list in _playerScores) {
        list.clear();
      }
      _currentRound = 1;
      _hasWinner = false;
    });
    _saveGameData();
  }

  void _onAddRound() {
    if (_hasWinner) return;

    bool hasValue = false;
    List<int> newScores = [];
    for (int i = 0; i < _scoreControllers.length; i++) {
      final scoreCount = int.tryParse(_scoreControllers[i].text) ?? 0;
      if (scoreCount != 0) hasValue = true;
      newScores.add(scoreCount);
    }

    if (!hasValue) return;

    setState(() {
      for (int i = 0; i < _playerScores.length; i++) {
        _playerScores[i].add(newScores[i]);
      }
      _currentRound++;
      for (var controller in _scoreControllers) {
        controller.text = '0';
      }
    });
    _saveGameData();
    _checkWinCondition();
  }

  void _removeRound(int roundIndex) {
    setState(() {
      for (int i = 0; i < _playerScores.length; i++) {
        if (roundIndex < _playerScores[i].length) {
          _playerScores[i].removeAt(roundIndex);
        }
      }
      _hasWinner = false;
    });
    _saveGameData();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      extendBody: true,
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
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Column(
                        children: [
                          _buildHeader(),
                          Expanded(
                            child: ListView(
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                10,
                                20,
                                100,
                              ),
                              children: [
                                _buildGlassCard(
                                  child: Column(
                                    children: [
                                      Wrap(
                                        spacing: 20,
                                        runSpacing: 20,
                                        alignment: WrapAlignment.center,
                                        children: List.generate(
                                          _playerNames.length,
                                          (index) {
                                            return _buildPlayerInputSection(
                                              index,
                                              _scoreControllers[index],
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: _onAddRound,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white
                                              .withValues(alpha: 0.2),
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          minimumSize: const Size(
                                            double.infinity,
                                            50,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                            side: BorderSide(
                                              color: Colors.white.withValues(
                                                alpha: 0.3,
                                              ),
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Add Round',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _buildGlassCard(child: _buildRoundsTable()),
                              ],
                            ),
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

                    PremiumGlassNavbar(
                      currentIndex: 0,
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
                      onTap: (index) async {
                        switch (index) {
                          case 0:
                            // Already on Scorer
                            break;
                          case 1:
                            Navigator.pushReplacementNamed(context, '/ranking');
                            break;
                          case 2:
                            await Navigator.pushNamed(context, '/settings');
                            refresh();
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

  Widget _buildGlassCard({required Widget child}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.onSurface.withValues(alpha: 0.08),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colorScheme.onSurface.withValues(alpha: 0.1)),
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Scorer',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                onPressed: _reset,
              ),
              IconButton(
                icon: const Icon(Icons.palette_rounded, color: Colors.white),
                onPressed: toggleTheme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerInputSection(int index, TextEditingController controller) {
    if (index >= _playerNames.length) return const SizedBox();
    return Column(
      children: [
        Text(
          _playerNames[index],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 100,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoundsTable() {
    final List<int> totals = _playerScores
        .map((scores) => scores.fold(0, (a, b) => a + b))
        .toList();
    final int maxRounds = _playerScores.isNotEmpty
        ? _playerScores[0].length
        : 0;

    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              flex: 2,
              child: Text(
                'TOTAL',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...List.generate(
              totals.length,
              (index) => Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    '${totals[index]}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const Expanded(flex: 1, child: SizedBox()),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(color: Colors.white24),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 300),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: maxRounds,
            itemBuilder: (context, index) {
              final List<int> roundScores = _playerScores
                  .map((scores) => scores[index])
                  .toList();
              final int maxScoreInRound = roundScores.reduce(
                (a, b) => a > b ? a : b,
              );
              final int minScoreInRound = roundScores.reduce(
                (a, b) => a < b ? a : b,
              );

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'R${index + 1}',
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    ...List.generate(roundScores.length, (pIndex) {
                      final score = roundScores[pIndex];
                      Color scoreColor = Colors.white;
                      if (score == maxScoreInRound &&
                          score != minScoreInRound) {
                        scoreColor = Colors.tealAccent;
                      }
                      if (score == minScoreInRound &&
                          score != maxScoreInRound) {
                        scoreColor = Colors.redAccent.shade100;
                      }

                      return Expanded(
                        flex: 2,
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '$score',
                              style: TextStyle(
                                color: scoreColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          color: Colors.white38,
                          size: 20,
                        ),
                        onPressed: () => _removeRound(index),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
