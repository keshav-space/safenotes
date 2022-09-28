import 'package:flutter/material.dart';
import 'package:safenotes/data/preference_and_config.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = AppSecurePreferencesStorage.getIsThemeDark()
      ? ThemeMode.dark
      : ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;
  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    AppSecurePreferencesStorage.setIsThemeDark(isOn);
    notifyListeners();
  }
}

class AppThemes {
  static final ThemeData darkTheme = NordTheme.dark().copyWith(
    textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'NotoSerif',
        ),
    primaryTextTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'NotoSerif',
        ),
  );
  static final ThemeData lightTheme = NordTheme.light().copyWith(
    textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'NotoSerif',
        ),
    primaryTextTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'NotoSerif',
        ),
  );
}
