import 'dart:io';
import 'package:flutter/foundation.dart';

class AdHelper {
  // Test Ad Unit IDs - Replace with your actual ad unit IDs from AdMob
  // For Android
  static const String bannerAdUnitIdAndroid = 'ca-app-pub-3940256099942544/6300978111';
  
  // For iOS
  static const String bannerAdUnitIdIOS = 'ca-app-pub-3940256099942544/2934735716';
  
  // Get the appropriate ad unit ID based on platform
  static String get bannerAdUnitId {
    if (kIsWeb) {
      return bannerAdUnitIdAndroid; // Default for web
    }
    if (Platform.isIOS) {
      return bannerAdUnitIdIOS;
    }
    // Default to Android
    return bannerAdUnitIdAndroid;
  }
  
  // TODO: Replace with your actual ad unit IDs from AdMob:
  // 1. Go to AdMob Console (https://apps.admob.com)
  // 2. Create ad units for your app
  // 3. Replace the test IDs above with your real ad unit IDs
}

