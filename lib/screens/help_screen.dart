import 'package:flutter/material.dart';

import '../widgets/premium_navbar.dart';
import '../widgets/domino_background.dart';
import '../utils/localization.dart';


class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
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
                            l10n.whatIsDomino,
                            l10n.whatIsDominoDesc,
                          ),
                          const SizedBox(height: 16),
                          _buildSection(
                            context,
                            l10n.whyThisApp,
                            l10n.whyThisAppDesc,
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
                          label: l10n.play,
                        ),
                        NavItem(
                          icon: Icons.emoji_events_rounded,
                          label: l10n.rank,
                        ),
                        NavItem(
                          icon: Icons.settings_rounded,
                          label: l10n.settings,
                        ),
                        NavItem(
                          icon: Icons.help_outline_rounded,
                          label: l10n.help,
                        ),
                        NavItem(icon: Icons.share_rounded, label: l10n.share),
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
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            l10n.help.toUpperCase(),
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
    final l10n = AppLocalizations.of(context);
    final faqs = [
      {
        'question': l10n.faq1Q,
        'answer': l10n.faq1A,
      },
      {
        'question': l10n.faq2Q,
        'answer': l10n.faq2A,
      },
      {
        'question': l10n.faq3Q,
        'answer': l10n.faq3A,
      },
      {
        'question': l10n.faq4Q,
        'answer': l10n.faq4A,
      },
      {
        'question': l10n.faq5Q,
        'answer': l10n.faq5A,
      },
      {
        'question': l10n.faq6Q,
        'answer': l10n.faq6A,
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
              l10n.faqTitle,
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
