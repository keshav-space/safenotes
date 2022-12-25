// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_nord_theme/flutter_nord_theme.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';

class Style {
  static TextStyle buttonTextStyle() {
    return TextStyle(
      color: PreferencesStorage.isThemeDark
          ? NordColors.polarNight.darkest
          : Colors.white,
    );
  }
}

TextStyle dialogBodyTextStyle = TextStyle(
  fontSize: 14,
);

TextStyle dialogHeadTextStyle = TextStyle(
  fontFamily: 'MerriweatherBlack',
  fontWeight: FontWeight.bold,
  letterSpacing: 0,
  fontSize: 20,
);

TextStyle appBarTitle = TextStyle(
  fontFamily: 'MerriweatherBlack',
  fontWeight: FontWeight.bold,
  letterSpacing: -0.4,
  fontSize: 20,
  color: Colors.white,
);
