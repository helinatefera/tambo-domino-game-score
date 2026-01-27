import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:in_app_review/in_app_review.dart';

import '../widgets/premium_navbar.dart';
import '../widgets/domino_background.dart';
import '../utils/localization.dart';

class ShareRateScreen extends StatelessWidget {
  const ShareRateScreen({super.key});

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _shareApp(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await Share.share(l10n.shareMessage, subject: l10n.shareSubject);
  }

  Future<void> _rateApp() async {
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
    } else {
      // Fallback to opening store listing
      // Replace with your actual app store URLs
      const androidUrl =
          'https://play.google.com/store/apps/details?id=com.tambo71.domino_score';
      // const iosUrl = 'https://apps.apple.com/app/id123456789';

      // You can detect platform and use appropriate URL
      // For now, using Android URL
      await _launchURL(androidUrl);
    }
  }

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
                          _buildActionCard(
                            context,
                            icon: Icons.share,
                            title: l10n.shareApp,
                            subtitle: l10n.shareAppSubtitle,
                            onTap: () => _shareApp(context),
                          ),
                          const SizedBox(height: 16),
                          _buildActionCard(
                            context,
                            icon: Icons.star,
                            title: l10n.rateApp,
                            subtitle: l10n.rateAppSubtitle,
                            onTap: _rateApp,
                          ),
                          const SizedBox(height: 16),
                          _buildActionCard(
                            context,
                            icon: Icons.info,
                            title: l10n.about,
                            subtitle: l10n.aboutSubtitle,
                            onTap: () {
                              _showInfoDialog(
                                context,
                                l10n.about,
                                l10n.aboutContent,
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildActionCard(
                            context,
                            icon: Icons.privacy_tip,
                            title: l10n.privacyPolicy,
                            subtitle: l10n.privacyPolicySubtitle,
                            onTap: () {
                              _showInfoDialog(
                                context,
                                l10n.privacyPolicy,
                                l10n.privacyPolicyContent,
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildActionCard(
                            context,
                            icon: Icons.description,
                            title: l10n.termsOfService,
                            subtitle: l10n.termsOfServiceSubtitle,
                            onTap: () {
                              _showInfoDialog(
                                context,
                                l10n.termsOfService,
                                l10n.termsOfServiceContent,
                              );
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
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            l10n.share.toUpperCase(),
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

  void _showInfoDialog(BuildContext context, String title, String content) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(content)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }
}
