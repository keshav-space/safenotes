// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_nord_theme/flutter_nord_theme.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode =
      PreferencesStorage.isThemeDark ? ThemeMode.dark : ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void setIsDarkMode(bool isDark) {
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    PreferencesStorage.setIsThemeDark(isDark);
    notifyListeners();
  }

  void setIsDarkDimTheme(bool isDim) {
    //themeMode = isDim ? ThemeMode.dark : ThemeMode.light;
    PreferencesStorage.setIsDimTheme(isDim);
    notifyListeners();
  }
}

class AppThemes {
  //static final ThemeData darkTheme = ThemeData.dark();
  static ThemeData get darkTheme =>
      PreferencesStorage.isDimTheme ? dimTheme : lightOutTheme;

  static final ThemeData lightOutTheme = NordTheme.dark().copyWith(
      textTheme: ThemeData.dark().textTheme.apply(
            fontFamily: 'NotoSerif',
          ),
      primaryTextTheme: ThemeData.dark().textTheme.apply(
            fontFamily: 'NotoSerif',
          ),
      backgroundColor: Colors.black,
      bottomAppBarColor: Colors.grey.shade900,
      dialogBackgroundColor: Colors.grey.shade900,
      // primaryColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      canvasColor: Colors.black,
      // primaryColorDark: Colors.black,
      appBarTheme: AppBarTheme().copyWith(
        color: Colors.grey.shade900,
      ),
      bottomSheetTheme: BottomSheetThemeData().copyWith(
        modalBackgroundColor: Colors.grey.shade900,
      )
      //platform: TargetPlatform.iOS,
      );

  static final ThemeData dimTheme = NordTheme.dark().copyWith(
    textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'NotoSerif',
        ),
    primaryTextTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'NotoSerif',
        ),

    //platform: TargetPlatform.iOS,
  );

  static Color get darkSettingsScaffold => PreferencesStorage.isDimTheme
      ? NordColors.polarNight.darkest
      : Colors.black;

  static Color? get darkSettingsCanvas => PreferencesStorage.isDimTheme
      ? NordColors.polarNight.darker
      : Colors.grey.shade900;

  static final ThemeData lightTheme = NordTheme.light().copyWith(
    textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'NotoSerif',
        ),
    primaryTextTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'NotoSerif',
        ),
    unselectedWidgetColor: NordColors.frost.darker,

    //platform: TargetPlatform.iOS,
  );
}
