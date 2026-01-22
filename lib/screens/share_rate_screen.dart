import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../widgets/premium_navbar.dart';
import '../widgets/domino_background.dart';

class ShareRateScreen extends StatelessWidget {
  const ShareRateScreen({super.key});

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _shareApp() async {
    await Share.share(
      'Check out this awesome Domino Score app! Keep track of your domino game scores easily.',
      subject: 'Domino Score App',
    );
  }

  Future<void> _rateApp() async {
    // Replace with your actual app store URLs
    const androidUrl =
        'https://play.google.com/store/apps/details?id=com.tambo71.domino_score';
    // const iosUrl = 'https://apps.apple.com/app/id123456789';

    // You can detect platform and use appropriate URL
    // For now, using Android URL
    await _launchURL(androidUrl);
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
                          _buildActionCard(
                            context,
                            icon: Icons.share,
                            title: 'Share App',
                            subtitle: 'Share this app with your friends',
                            onTap: _shareApp,
                          ),
                          const SizedBox(height: 16),
                          _buildActionCard(
                            context,
                            icon: Icons.star,
                            title: 'Rate App',
                            subtitle: 'Rate us on the app store',
                            onTap: _rateApp,
                          ),
                          const SizedBox(height: 16),
                          _buildActionCard(
                            context,
                            icon: Icons.feedback,
                            title: 'Send Feedback',
                            subtitle: 'Help us improve the app',
                            onTap: () {
                              final email = 'feedback@domino-scorer.com';
                              _launchURL('mailto:$email?subject=Feedback');
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildActionCard(
                            context,
                            icon: Icons.info,
                            title: 'About',
                            subtitle: 'App version and information',
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('About'),
                                  content: const Text(
                                    'Domino Score v1.0.0\n\n'
                                    'A simple and elegant way to keep track of your domino game scores.\n\n'
                                    'Made with ❤️ for domino enthusiasts.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildActionCard(
                            context,
                            icon: Icons.privacy_tip,
                            title: 'Privacy Policy',
                            subtitle: 'View our privacy policy',
                            onTap: () {
                              // Replace with your actual privacy policy URL
                              _launchURL('https://example.com/privacy');
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildActionCard(
                            context,
                            icon: Icons.description,
                            title: 'Terms of Service',
                            subtitle: 'View terms and conditions',
                            onTap: () {
                              // Replace with your actual terms URL
                              _launchURL('https://example.com/terms');
                            },
                          ),
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
                      currentIndex: 4,
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
                            Navigator.pushReplacementNamed(context, '/help');
                            break;
                          case 4:
                            // Already on Share
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
            'SHARE & RATE',
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

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.onSurface.withValues(alpha: 0.08),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colorScheme.onSurface.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        leading: Icon(icon, color: colorScheme.primary),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: colorScheme.onSurface.withValues(alpha: 0.3),
        ),
        onTap: onTap,
      ),
    );
  }
}
