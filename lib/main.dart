import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'utils/localization.dart';

import 'screens/home_screen.dart';
import 'screens/scorer_screen.dart';
import 'screens/team_settings_screen.dart';
import 'screens/ranking_screen.dart';
import 'screens/help_screen.dart';
import 'screens/share_rate_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

enum AppTheme { light, dark, night }

final ValueNotifier<AppTheme> themeNotifier = ValueNotifier<AppTheme>(
  AppTheme.dark,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

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
        
        return ValueListenableBuilder<Locale>(
          valueListenable: AppLocalizations.languageNotifier,
          builder: (context, locale, _) {
            return MaterialApp(
              title: 'DominoApp Score Keeper',
              debugShowCheckedModeBanner: false,
              locale: locale,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('es'),
              ],
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
      },
    );
  }
}
