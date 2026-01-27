import 'package:flutter/material.dart';
import '../models/leaderboard_entry.dart';
import '../services/npoint_service.dart';
import '../widgets/premium_navbar.dart';
import '../widgets/domino_background.dart';
import '../utils/localization.dart';


class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();

  static void refresh() {
    // This can be called to refresh the leaderboard
    // The screen will refresh when navigated to
  }
}

class _RankingScreenState extends State<RankingScreen> {
  List<LeaderboardEntry> _leaderboard = [];
  bool _isLoading = true;
  String? _errorMessage;

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
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final leaderboard = await NPointService.fetchLeaderboard();
      
      setState(() {
        _leaderboard = leaderboard;
        _isLoading = false;
      });
      
      debugPrint('Loaded ${_leaderboard.length} entries from npoint.io');
    } catch (e) {
      debugPrint('Error loading leaderboard: $e');
      setState(() {
        _leaderboard = [];
        _isLoading = false;
        _errorMessage = 'Failed to load leaderboard. Please check your internet connection.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
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
                      child: _isLoading
                          ? _buildLoadingState()
                          : _errorMessage != null
                              ? _buildErrorState()
                              : _leaderboard.isEmpty
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

                    PremiumGlassNavbar(
                      currentIndex: 1,
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
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              l10n.rank.toUpperCase(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          IconButton(
            onPressed: _loadLeaderboard,
            icon: Icon(
              Icons.refresh,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            tooltip: 'Refresh Leaderboard',
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading leaderboard...',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: colorScheme.error.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? 'Error loading leaderboard',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _loadLeaderboard,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
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
            'Top 10 winners will appear here',
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
