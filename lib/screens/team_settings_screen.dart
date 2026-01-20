import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../main.dart';
import '../widgets/premium_navbar.dart';
import '../widgets/domino_background.dart';
import '../widgets/banner_ad_widget.dart';
import '../utils/ad_helper.dart';

class TeamSettingsScreen extends StatefulWidget {
  const TeamSettingsScreen({super.key});

  @override
  State<TeamSettingsScreen> createState() => _TeamSettingsScreenState();
}

class _TeamSettingsScreenState extends State<TeamSettingsScreen> {
  int _numberOfPlayers = 2;
  int _targetRounds = 0; // 0 for unlimited
  int _targetScore = 100; // Default target
  String _tableTheme = 'Golden'; // Default theme
  final List<TextEditingController> _playerNameControllers = [];
  final TextEditingController _newPlayerNameController =
      TextEditingController();
  bool _isLoading = true;

  // Theme Definitions
  final Map<String, List<Color>> _themeColors = {
    'Golden': [const Color(0xFFFFD700), const Color(0xFFFFD700)],
    'Classic Green': [const Color(0xFF4CAF50), const Color(0xFF2E7D32)],
    'Wood': [const Color(0xFF8D6E63), const Color(0xFF5D4037)],
    'Midnight': [const Color(0xFF2C3E50), const Color(0xFF000000)],
  };

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadSettings();
  }

  void _initializeControllers() {
    // Initialize with default values to avoid red screen
    if (_playerNameControllers.isEmpty) {
      for (int i = 0; i < _numberOfPlayers; i++) {
        _playerNameControllers.add(TextEditingController(text: ''));
      }
    }
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final numberOfPlayers = prefs.getInt('numberOfPlayers') ?? 2;
      final targetRounds = prefs.getInt('targetRounds') ?? 0;
      final targetScore = prefs.getInt('targetScore') ?? 100;
      final tableTheme = prefs.getString('tableTheme') ?? 'Golden';
      final playerNamesJson = prefs.getString('playerNames');

      List<String> playerNames = [];

      if (playerNamesJson != null) {
        try {
          playerNames = List<String>.from(json.decode(playerNamesJson));
        } catch (e) {
          playerNames = [];
        }
      }

      // Dispose old controllers
      for (var controller in _playerNameControllers) {
        try {
          controller.dispose();
        } catch (_) {}
      }

      _playerNameControllers.clear();

      setState(() {
        _numberOfPlayers = numberOfPlayers;
        _targetRounds = targetRounds;
        _targetScore = targetScore;
        _tableTheme = tableTheme;

        for (int i = 0; i < _numberOfPlayers; i++) {
          _playerNameControllers.add(
            TextEditingController(
              text: i < playerNames.length ? playerNames[i] : '',
            ),
          );
        }
        _isLoading = false;
      });
    } catch (e) {
      if (_playerNameControllers.isEmpty) {
        _initializeControllers();
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final playerNames = _playerNameControllers.asMap().entries.map((entry) {
      final index = entry.key;
      final controller = entry.value;
      final name = controller.text.trim();
      return name.isEmpty ? 'Player ${index + 1}' : name;
    }).toList();

    await prefs.setInt('numberOfPlayers', _numberOfPlayers);
    await prefs.setInt('targetRounds', _targetRounds);
    await prefs.setInt('targetScore', _targetScore);
    await prefs.setString('tableTheme', _tableTheme);
    await prefs.setString('playerNames', json.encode(playerNames));
  }

  void _updateNumberOfPlayers(int newCount) {
    if (newCount < 2) return;

    setState(() {
      if (newCount > _numberOfPlayers) {
        for (int i = _numberOfPlayers; i < newCount; i++) {
          _playerNameControllers.add(TextEditingController(text: ''));
        }
      } else {
        for (int i = _numberOfPlayers - 1; i >= newCount; i--) {
          if (i < _playerNameControllers.length) {
            try {
              _playerNameControllers[i].dispose();
            } catch (_) {}
            _playerNameControllers.removeAt(i);
          }
        }
      }
      _numberOfPlayers = newCount;
    });
    _saveSettings();
  }

  void _updateTargetScore(int newScore) {
    if (newScore < 0) return;
    setState(() {
      _targetScore = newScore;
    });
    _saveSettings();
  }

  void _updateTheme(String newTheme) {
    setState(() {
      _tableTheme = newTheme;
    });
    _saveSettings();
  }

  void _addPlayer() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Player'),
        content: TextField(
          controller: _newPlayerNameController,
          decoration: const InputDecoration(
            labelText: 'Player Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _newPlayerNameController.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (_newPlayerNameController.text.isNotEmpty) {
                _updateNumberOfPlayers(_numberOfPlayers + 1);
                _playerNameControllers.last.text =
                    _newPlayerNameController.text;
                _newPlayerNameController.clear();
                _saveSettings();
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _playerNameControllers) {
      try {
        controller.dispose();
      } catch (_) {}
    }
    try {
      _newPlayerNameController.dispose();
    } catch (_) {}
    super.dispose();
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
                            child: SingleChildScrollView(
                              // Made scaleable for small screens
                              padding: const EdgeInsets.fromLTRB(
                                20,
                                10,
                                20,
                                100,
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  _buildGlassCard(
                                    child: _buildNumberOfPlayersSection(),
                                  ),
                                  const SizedBox(height: 20),
                                  _buildGlassCard(
                                    child: _buildTargetScoreSection(),
                                  ),
                                  const SizedBox(height: 20),
                                  _buildGlassCard(
                                    child: _buildPlayersSection(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              // Glassmorphic Bottom Navigation
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BannerAdWidget(
                      adUnitId: AdHelper.bannerAdUnitId,
                    ),
                    PremiumGlassNavbar(
                      currentIndex: 2,
                  items: [
                    NavItem(icon: Icons.videogame_asset_rounded, label: 'Play'),
                    NavItem(icon: Icons.emoji_events_rounded, label: 'Rank'),
                    NavItem(icon: Icons.settings_rounded, label: 'Settings'),
                    NavItem(icon: Icons.help_outline_rounded, label: 'Help'),
                    NavItem(icon: Icons.share_rounded, label: 'Share'),
                  ],
                  onTap: (index) {
                    switch (index) {
                      case 0:
                        Navigator.pushReplacementNamed(context, '/scorer');
                        break;
                      case 1:
                        Navigator.pushReplacementNamed(context, '/ranking');
                        break;
                      case 2:
                        // Already on Settings
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.palette_rounded, color: Colors.white),
            onPressed: toggleTheme,
          ),
        ],
      ),
    );
  }

  Widget _buildNumberOfPlayersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.groups_rounded, color: Colors.white70, size: 24),
            SizedBox(width: 12),
            Text(
              'Number of Players',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRoundBtn(
              Icons.remove_rounded,
              () => _updateNumberOfPlayers(_numberOfPlayers - 1),
            ),
            const SizedBox(width: 30),
            Text(
              '$_numberOfPlayers',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 30),
            _buildRoundBtn(
              Icons.add_rounded,
              () => _updateNumberOfPlayers(_numberOfPlayers + 1),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoundBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildTargetScoreSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              Icons.emoji_events_rounded,
              color: Colors.amberAccent,
              size: 24,
            ),
            SizedBox(width: 12),
            Text(
              'Win Condition',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _targetScore == 0
                      ? 'Infinite Points'
                      : 'Target: $_targetScore Points',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Reach this score to win the game',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                _buildActionIconButton(
                  Icons.remove_circle_outline,
                  () => _updateTargetScore(_targetScore - 10),
                ),
                _buildActionIconButton(
                  Icons.add_circle_outline,
                  () => _updateTargetScore(_targetScore + 10),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionIconButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white, size: 32),
    );
  }

  Widget _buildPlayersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.person_rounded, color: Colors.white70, size: 24),
                SizedBox(width: 12),
                Text(
                  'Players',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: _addPlayer,
              icon: const Icon(
                Icons.add_circle_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...List.generate(_numberOfPlayers, (index) {
          if (index >= _playerNameControllers.length) {
            return const SizedBox.shrink();
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: TextField(
              controller: _playerNameControllers[index],
              onChanged: (_) => _saveSettings(),
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                labelText: 'Player ${index + 1} Name',
                labelStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.1),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.white, width: 2),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
