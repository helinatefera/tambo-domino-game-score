import 'package:flutter/material.dart';

import '../widgets/premium_navbar.dart';
import '../widgets/domino_background.dart';


class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

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
                child: Column(
                  children: [
                    _buildHeader(context),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16,
                          bottom: 120, // Space for Navbar
                        ),
                        children: [
                          _buildSection(
                            context,
                            'What is Domino?',
                            'Domino is a classic tile-based game where players match tiles with the same number of pips. The game is typically played in teams, and players score points by playing tiles that match the open ends of the layout.',
                          ),
                          const SizedBox(height: 16),
                          _buildSection(
                            context,
                            'Why This App?',
                            'This app helps you keep track of scores during your domino games. Instead of using pen and paper, you can easily add points for each team, view scoring history, and save your game results to the leaderboard.',
                          ),
                          const SizedBox(height: 16),
                          _buildFAQSection(context),
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
                      currentIndex: 3,
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
                            Navigator.pushReplacementNamed(context, '/ranking');
                            break;
                          case 2:
                            Navigator.pushReplacementNamed(
                              context,
                              '/settings',
                            );
                            break;
                          case 3:
                            // Already on Help
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

  Widget _buildHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            'HELP & FAQ',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQSection(BuildContext context) {
    final faqs = [
      {
        'question': 'How do I add points?',
        'answer':
            'Tap the quick score buttons (5, 10, 15, 20) or use the + button to enter a custom score. Points are added to the team on the corresponding side.',
      },
      {
        'question': 'Can I undo a score?',
        'answer':
            'Yes! Use the undo button (↶) below each team\'s score section to remove the last added score.',
      },
      {
        'question': 'How do I reset the game?',
        'answer':
            'Tap the refresh icon (↻) in the top right corner of the scorer screen to reset all scores.',
      },
      {
        'question': 'How do I save a game to the leaderboard?',
        'answer':
            'Go to the Ranking tab and tap the + button to add a leaderboard entry with the player name and final score.',
      },
      {
        'question': 'Can I customize player names?',
        'answer':
            'Yes! Go to the Team Settings tab to set the number of players and customize their names and initial points.',
      },
      {
        'question': 'How do I share the app?',
        'answer':
            'Go to the Share & Rate tab to share the app with friends or rate it on the app store.',
      },
    ];

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            ...faqs.map(
              (faq) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      faq['question']!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      faq['answer']!,
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
