class NPointConfig {
  // Replace with your npoint.io Bin ID
  static const String binId = '621ffd18f0b6248c6264';

  // Base URL for npoint.io API
  static const String baseUrl = 'https://api.npoint.io';

  static String get url => '$baseUrl/$binId';
}
