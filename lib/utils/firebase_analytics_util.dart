import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsUtil {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static Future<void> analyticLogEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }
}
