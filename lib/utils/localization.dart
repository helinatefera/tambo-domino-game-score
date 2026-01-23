import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static final ValueNotifier<Locale> languageNotifier = ValueNotifier(
    const Locale('en'),
  );

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'play': 'Play',
      'rank': 'Rank',
      'settings': 'Settings',
      'help': 'Help',
      'share': 'Share',
      'games': 'Games',
      'wins': 'Wins',
      'newScoreboard': 'NEW SCOREBOARD',
      'dominoScore': 'Domino Score',
      'scorer': 'Scorer',
      'victory': 'VICTORY!',
      'newGame': 'NEW GAME',
      'backToScoreboard': 'BACK TO SCOREBOARD',
      'addRound': 'Add Score',
      'total': 'TOTAL',
      'numberOfPlayers': 'Number of Teams',
      'winCondition': 'Win Condition',
      'infinitePoints': 'Infinite Points',
      'targetPoints': 'Target: @score Points',
      'reachScoreMessage': 'Reach this score to win the game',
      'players': 'Teams',
      'addPlayer': 'Add Team',
      'playerName': 'Team Name',
      'indexedPlayerName': 'Team @index Name',
      'playerDefaultName': 'Team @index',
      'cancel': 'Cancel',
      'add': 'Add',
      'language': 'Language',
      'whatIsDomino': 'What is Domino?',
      'whatIsDominoDesc':
          'Domino is a classic tile-based game where players match tiles with the same number of pips. The game is typically played in teams, and players score points by playing tiles that match the open ends of the layout.',
      'whyThisApp': 'Why This App?',
      'whyThisAppDesc':
          'This app helps you keep track of scores during your domino games. Instead of using pen and paper, you can easily add points for each team, view scoring history, and save your game results to the leaderboard.',
      'faqTitle': 'Frequently Asked Questions',
      'faq1Q': 'How do I add points?',
      'faq1A':
          'Tap the quick score buttons (5, 10, 15, 20) or use the + button to enter a custom score. Points are added to the team on the corresponding side.',
      'faq2Q': 'Can I undo a score?',
      'faq2A':
          'Yes! Use the undo button (↶) below each team\'s score section to remove the last added score.',
      'faq3Q': 'How do I reset the game?',
      'faq3A':
          'Tap the refresh icon (↻) in the top right corner of the scorer screen to reset all scores.',
      'faq4Q': 'How do I save a game to the leaderboard?',
      'faq4A':
          'Go to the Ranking tab and tap the + button to add a leaderboard entry with the player name and final score.',
      'faq5Q': 'Can I customize player names?',
      'faq5A':
          'Yes! Go to the Team Settings tab to set the number of players and customize their names and initial points.',
      'faq6Q': 'How do I share the app?',
      'faq6A':
          'Go to the Share & Rate tab to share the app with friends or rate it on the app store.',
      'shareApp': 'Share App',
      'shareAppSubtitle': 'Share this app with your friends',
      'rateApp': 'Rate App',
      'rateAppSubtitle': 'Rate us on the app store',
      'sendFeedback': 'Send Feedback',
      'sendFeedbackSubtitle': 'Help us improve the app',
      'about': 'About',
      'aboutSubtitle': 'App version and information',
      'aboutContent':
          'Domino Score v1.0.0\n\nA simple and elegant way to keep track of your domino game scores.\n\nMade with ❤️ for domino enthusiasts.',
      'close': 'Close',
      'privacyPolicy': 'Privacy Policy',
      'privacyPolicySubtitle': 'View our privacy policy',
      'termsOfService': 'Terms of Service',
      'termsOfServiceSubtitle': 'View terms and conditions',
      'shareMessage':
          'Check out this awesome Domino Score app! Keep track of your domino game scores easily.',
      'shareSubject': 'Domino Score App',
      'privacyPolicyContent':
          'Privacy Policy\n\nTambo71 LLC respects your privacy. We do not collect any personal data. All game scores and settings are stored locally on your device.\n\nContact: daryl@tambo71.com',
      'termsOfServiceContent':
          'Terms of Service\n\nBy using this app, you agree to these terms. The app is provided "as is" without warranties. Tambo71 LLC is not liable for any damages arising from the use of this app.\n\n© 2024 Tambo71 LLC',
      'topPlayer': 'Top Player',
    },
    'es': {
      'play': 'Jugar',
      'rank': 'Ranking',
      'settings': 'Ajustes',
      'help': 'Ayuda',
      'share': 'Compartir',
      'games': 'Partidas',
      'wins': 'Victorias',
      'newScoreboard': 'NUEVA TABLA',
      'dominoScore': 'Puntaje Dominó',
      'scorer': 'Marcador',
      'victory': '¡VICTORIA!',
      'newGame': 'NUEVO JUEGO',
      'backToScoreboard': 'VOLVER AL MARCADOR',
      'addRound': 'Agregar Ronda',
      'total': 'TOTAL',
      'numberOfPlayers': 'Número de Jugadores',
      'winCondition': 'Condición de Victoria',
      'infinitePoints': 'Puntos Infinitos',
      'targetPoints': 'Objetivo: @score Puntos',
      'reachScoreMessage': 'Alcanza este puntaje para ganar',
      'players': 'Jugadores',
      'addPlayer': 'Agregar Jugador',
      'playerName': 'Nombre del Jugador',
      'indexedPlayerName': 'Nombre del Jugador @index',
      'playerDefaultName': 'Jugador @index',
      'cancel': 'Cancelar',
      'add': 'Agregar',
      'language': 'Idioma',
      'whatIsDomino': '¿Qué es Dominó?',
      'whatIsDominoDesc':
          'El dominó es un juego clásico de fichas donde los jugadores emparejan fichas con el mismo número de puntos. Generalmente se juega en equipos, y los jugadores anotan puntos jugando fichas que coincidan con los extremos abiertos del juego.',
      'whyThisApp': '¿Por qué esta App?',
      'whyThisAppDesc':
          'Esta aplicación te ayuda a llevar el puntaje de tus juegos de dominó. En lugar de usar papel y lápiz, puedes agregar puntos fácilmente para cada equipo, ver el historial de puntajes y guardar los resultados en la tabla de clasificación.',
      'faqTitle': 'Preguntas Frecuentes',
      'faq1Q': '¿Cómo agrego puntos?',
      'faq1A':
          'Toca los botones de puntaje rápido (5, 10, 15, 20) o usa el botón + para ingresar un puntaje personalizado. Los puntos se agregan al equipo del lado correspondiente.',
      'faq2Q': '¿Puedo deshacer un puntaje?',
      'faq2A':
          '¡Sí! Usa el botón de deshacer (↶) debajo de la sección de puntaje de cada equipo para eliminar el último puntaje agregado.',
      'faq3Q': '¿Cómo reinicio el juego?',
      'faq3A':
          'Toca el icono de actualizar (↻) en la esquina superior derecha de la pantalla del marcador para reiniciar todos los puntajes.',
      'faq4Q': '¿Cómo guardo un juego en el ranking?',
      'faq4A':
          'Ve a la pestaña de Ranking y toca el botón + para agregar una entrada con el nombre del jugador y el puntaje final.',
      'faq5Q': '¿Puedo personalizar los nombres?',
      'faq5A':
          '¡Sí! Ve a la pestaña de Ajustes para establecer el número de jugadores y personalizar sus nombres y puntos iniciales.',
      'faq6Q': '¿Cómo comparto la app?',
      'faq6A':
          'Ve a la pestaña de Compartir para enviar la app a amigos o calificarla en la tienda.',
      'shareApp': 'Compartir App',
      'shareAppSubtitle': 'Comparte esta app con tus amigos',
      'rateApp': 'Calificar App',
      'rateAppSubtitle': 'Califícanos en la tienda',
      'sendFeedback': 'Enviar Comentarios',
      'sendFeedbackSubtitle': 'Ayúdanos a mejorar la app',
      'about': 'Acerca de',
      'aboutSubtitle': 'Versión e información de la app',
      'aboutContent':
          'Domino Score v1.0.0\n\nUna forma simple y elegante de llevar el puntaje de tus juegos de dominó.\n\nHecho con ❤️ para entusiastas del dominó.',
      'close': 'Cerrar',
      'privacyPolicy': 'Política de Privacidad',
      'privacyPolicySubtitle': 'Ver nuestra política de privacidad',
      'termsOfService': 'Términos de Servicio',
      'termsOfServiceSubtitle': 'Ver términos y condiciones',
      'shareMessage':
          '¡Mira esta increíble app de Domino Score! Lleva el puntaje de tus juegos fácilmente.',
      'shareSubject': 'App Domino Score',
      'privacyPolicyContent':
          'Política de Privacidad\n\nTambo71 LLC respeta tu privacidad. No recopilamos datos personales. Todos los puntajes y configuraciones se guardan localmente.\n\nContacto: daryl@tambo71.com',
      'termsOfServiceContent':
          'Términos de Servicio\n\nAl usar esta app, aceptas estos términos. La app se ofrece "tal cual" sin garantías. Tambo71 LLC no es responsable de daños por el uso de esta app.\n\n© 2024 Tambo71 LLC',
      'topPlayer': 'Mejor Jugador',
    },
  };

  String get play => _localizedValues[locale.languageCode]!['play']!;
  String get rank => _localizedValues[locale.languageCode]!['rank']!;
  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get help => _localizedValues[locale.languageCode]!['help']!;
  String get share => _localizedValues[locale.languageCode]!['share']!;
  String get games => _localizedValues[locale.languageCode]!['games']!;
  String get wins => _localizedValues[locale.languageCode]!['wins']!;
  String get newScoreboard =>
      _localizedValues[locale.languageCode]!['newScoreboard']!;
  String get dominoScore =>
      _localizedValues[locale.languageCode]!['dominoScore']!;
  String get scorer => _localizedValues[locale.languageCode]!['scorer']!;
  String get victory => _localizedValues[locale.languageCode]!['victory']!;
  String get newGame => _localizedValues[locale.languageCode]!['newGame']!;
  String get backToScoreboard =>
      _localizedValues[locale.languageCode]!['backToScoreboard']!;
  String get addRound => _localizedValues[locale.languageCode]!['addRound']!;
  String get total => _localizedValues[locale.languageCode]!['total']!;
  String get numberOfPlayers =>
      _localizedValues[locale.languageCode]!['numberOfPlayers']!;
  String get winCondition =>
      _localizedValues[locale.languageCode]!['winCondition']!;
  String get infinitePoints =>
      _localizedValues[locale.languageCode]!['infinitePoints']!;
  String targetPoints(int score) =>
      _localizedValues[locale.languageCode]!['targetPoints']!.replaceAll(
        '@score',
        score.toString(),
      );
  String get reachScoreMessage =>
      _localizedValues[locale.languageCode]!['reachScoreMessage']!;
  String get players => _localizedValues[locale.languageCode]!['players']!;
  String get addPlayer => _localizedValues[locale.languageCode]!['addPlayer']!;
  String get playerName =>
      _localizedValues[locale.languageCode]!['playerName']!;
  String indexedPlayerName(int index) =>
      _localizedValues[locale.languageCode]!['indexedPlayerName']!.replaceAll(
        '@index',
        index.toString(),
      );
  String playerDefaultName(int index) =>
      _localizedValues[locale.languageCode]!['playerDefaultName']!.replaceAll(
        '@index',
        index.toString(),
      );
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get add => _localizedValues[locale.languageCode]!['add']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;

  // Help & Share keys
  String get whatIsDomino =>
      _localizedValues[locale.languageCode]!['whatIsDomino']!;
  String get whatIsDominoDesc =>
      _localizedValues[locale.languageCode]!['whatIsDominoDesc']!;
  String get whyThisApp =>
      _localizedValues[locale.languageCode]!['whyThisApp']!;
  String get whyThisAppDesc =>
      _localizedValues[locale.languageCode]!['whyThisAppDesc']!;
  String get faqTitle => _localizedValues[locale.languageCode]!['faqTitle']!;
  String get faq1Q => _localizedValues[locale.languageCode]!['faq1Q']!;
  String get faq1A => _localizedValues[locale.languageCode]!['faq1A']!;
  String get faq2Q => _localizedValues[locale.languageCode]!['faq2Q']!;
  String get faq2A => _localizedValues[locale.languageCode]!['faq2A']!;
  String get faq3Q => _localizedValues[locale.languageCode]!['faq3Q']!;
  String get faq3A => _localizedValues[locale.languageCode]!['faq3A']!;
  String get faq4Q => _localizedValues[locale.languageCode]!['faq4Q']!;
  String get faq4A => _localizedValues[locale.languageCode]!['faq4A']!;
  String get faq5Q => _localizedValues[locale.languageCode]!['faq5Q']!;
  String get faq5A => _localizedValues[locale.languageCode]!['faq5A']!;
  String get faq6Q => _localizedValues[locale.languageCode]!['faq6Q']!;
  String get faq6A => _localizedValues[locale.languageCode]!['faq6A']!;
  String get shareApp => _localizedValues[locale.languageCode]!['shareApp']!;
  String get shareAppSubtitle =>
      _localizedValues[locale.languageCode]!['shareAppSubtitle']!;
  String get rateApp => _localizedValues[locale.languageCode]!['rateApp']!;
  String get rateAppSubtitle =>
      _localizedValues[locale.languageCode]!['rateAppSubtitle']!;
  String get sendFeedback =>
      _localizedValues[locale.languageCode]!['sendFeedback']!;
  String get sendFeedbackSubtitle =>
      _localizedValues[locale.languageCode]!['sendFeedbackSubtitle']!;
  String get about => _localizedValues[locale.languageCode]!['about']!;
  String get aboutSubtitle =>
      _localizedValues[locale.languageCode]!['aboutSubtitle']!;
  String get aboutContent =>
      _localizedValues[locale.languageCode]!['aboutContent']!;
  String get close => _localizedValues[locale.languageCode]!['close']!;
  String get privacyPolicy =>
      _localizedValues[locale.languageCode]!['privacyPolicy']!;
  String get privacyPolicySubtitle =>
      _localizedValues[locale.languageCode]!['privacyPolicySubtitle']!;
  String get termsOfService =>
      _localizedValues[locale.languageCode]!['termsOfService']!;
  String get termsOfServiceSubtitle =>
      _localizedValues[locale.languageCode]!['termsOfServiceSubtitle']!;
  String get shareMessage =>
      _localizedValues[locale.languageCode]!['shareMessage']!;
  String get shareSubject =>
      _localizedValues[locale.languageCode]!['shareSubject']!;
  String get privacyPolicyContent =>
      _localizedValues[locale.languageCode]!['privacyPolicyContent']!;
  String get termsOfServiceContent =>
      _localizedValues[locale.languageCode]!['termsOfServiceContent']!;
  String get topPlayer => _localizedValues[locale.languageCode]!['topPlayer']!;

  static AppLocalizations of(BuildContext context) {
    return AppLocalizations(languageNotifier.value);
  }
}
