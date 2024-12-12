import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static late SharedPreferences prefs;

  static Future<void> setTheme(String theme) async {
    await prefs.setString("theme", theme);
  }

  static String getTheme() {
    return prefs.getString("theme") ?? "light";
  }

  static Future<void> setLanguage(String language) async {
    await prefs.setString("language", language);
  }

  static String getLanguage() {
    return prefs.getString("language") ?? "en";
  }
}
