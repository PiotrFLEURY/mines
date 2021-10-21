import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences extends ChangeNotifier {
  bool _soundEnabled = true;

  void loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _soundEnabled = prefs.getBool('soundEnabled') ?? true;
  }

  get isSoundEnabled => _soundEnabled;

  Future<void> setSoundEnabled(bool value) async {
    _soundEnabled = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('soundEnabled', value);
    notifyListeners();
  }
}
