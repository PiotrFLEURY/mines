import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static Future<bool> isSoundEnabled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('soundEnabled') ?? true;
  }

  static Future<void> setSoundEnabled(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('soundEnabled', value);
  }
}
