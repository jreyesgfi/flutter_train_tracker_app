import 'package:shared_preferences/shared_preferences.dart';

class ChronoStorage {
  /// Builds a unique key for a given stage.
  static String keyForStage(int stage) => 'chrono_start_$stage';

  /// Loads the saved start time for [stage]. If no value is saved,
  /// it saves the current time and returns it.
  static Future<DateTime> loadStartTime(int stage) async {
    final prefs = await SharedPreferences.getInstance();
    final key = keyForStage(stage);
    final savedStart = prefs.getInt(key);
    if (savedStart != null) {
      return DateTime.fromMillisecondsSinceEpoch(savedStart);
    } else {
      final now = DateTime.now();
      await prefs.setInt(key, now.millisecondsSinceEpoch);
      return now;
    }
  }

  /// Resets (forces a new start time) for the given [stage] and saves it.
  static Future<DateTime> resetStartTime(int stage) async {
    final prefs = await SharedPreferences.getInstance();
    final key = keyForStage(stage);
    final now = DateTime.now();
    await prefs.setInt(key, now.millisecondsSinceEpoch);
    return now;
  }

  /// Deletes all saved chrono start times (i.e. keys that start with 'chrono_start_').
  static Future<void> deleteAllChronoStartTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith('chrono_start_'));
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}
