import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'screens/home_screen.dart';
import 'screens/scorer_screen.dart';
import 'screens/team_settings_screen.dart';
import 'screens/ranking_screen.dart';
import 'screens/help_screen.dart';
import 'screens/share_rate_screen.dart';

enum AppTheme { light, dark, night }

final ValueNotifier<AppTheme> themeNotifier = ValueNotifier<AppTheme>(AppTheme.dark);

void toggleTheme() {
  if (themeNotifier.value == AppTheme.light) {
    themeNotifier.value = AppTheme.dark;
  } else if (themeNotifier.value == AppTheme.dark) {
    themeNotifier.value = AppTheme.night;
  } else {
    themeNotifier.value = AppTheme.light;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Google Mobile Ads
  await MobileAds.instance.initialize();
  
  // Add error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTheme>(
      valueListenable: themeNotifier,
      builder: (context, currentTheme, _) {
        final isLight = currentTheme == AppTheme.light;
        
        return MaterialApp(
          title: 'Domino Score',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFFFD700), // Yellow/Gold brand color
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: const Color(0xFFFAFAFA),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFFFD700), // Yellow/Gold brand color
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(0xFF121212),
            useMaterial3: true,
          ),
          themeMode: isLight ? ThemeMode.light : ThemeMode.dark,
          initialRoute: '/',
          routes: {
            '/': (context) => const HomeScreen(),
            '/scorer': (context) => const ScorerScreen(),
            '/settings': (context) => const TeamSettingsScreen(),
            '/ranking': (context) => const RankingScreen(),
            '/help': (context) => const HelpScreen(),
            '/share': (context) => const ShareRateScreen(),
          },
        );
      },
    );
  }
}
