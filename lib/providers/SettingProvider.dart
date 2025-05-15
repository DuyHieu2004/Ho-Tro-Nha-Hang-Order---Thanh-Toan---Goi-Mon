import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  String _fontFamily = 'Roboto';
  final List<String> _availableFonts = ['Roboto', 'Lobster', 'OpenSans'];

  ThemeMode get themeMode => _themeMode;
  String get fontFamily => _fontFamily;
  List<String> get availableFonts => _availableFonts;

  SettingProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('themeMode');
    final savedFont = prefs.getString('fontFamily');

    if (savedTheme != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedTheme,
        orElse: () => ThemeMode.light,
      );
    }
    if (savedFont != null && _availableFonts.contains(savedFont)) {
      _fontFamily = savedFont;
    } else {
      _fontFamily = 'Roboto';
    }

    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode.toString());
    notifyListeners();
  }

  void changeFont(String font) async {
    if (_availableFonts.contains(font)) {
      _fontFamily = font;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fontFamily', font);
      notifyListeners();
    }
  }
}