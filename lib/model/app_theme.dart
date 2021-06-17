import 'package:flutter/material.dart';
import 'package:safe_notes/databaseAndStorage/prefrence_sotorage_and_state_controls.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = AppSecurePreferencesStorage.getIsThemeDark()
      ? ThemeMode.dark
      : ThemeMode.light; //ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;
  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    AppSecurePreferencesStorage.setIsThemeDark(isOn);
    notifyListeners();
  }
}

class AppThemes {
  static final darkTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF212121),
    accentColor: Colors.white,
    accentIconTheme: IconThemeData(color: Colors.black),
    dividerColor: Colors.black12,
    appBarTheme: AppBarTheme(
      //color: Color.fromRGBO(0, 265, 45, 50)
      color: Colors.blueGrey.shade800,
    ),
    colorScheme: ColorScheme.dark(primary: Colors.blue),
    scaffoldBackgroundColor: Colors.blueGrey.shade900,
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: Colors.grey),
  );

  static final lightTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.white,
    brightness: Brightness.light,
    backgroundColor: const Color(0xFFE5E5E5),
    accentColor: Colors.black,
    accentIconTheme: IconThemeData(color: Colors.white),
    dividerColor: Colors.white54,
    colorScheme: ColorScheme.light(
        primary: const Color(0xff303F9F),
        primaryVariant: const Color(0xff3F51B5)),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.blueGrey.shade500),
    appBarTheme: AppBarTheme(
      color: Colors.blueGrey.shade500,
    ),
  );
}
