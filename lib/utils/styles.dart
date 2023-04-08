/*
* Copyright (C) Keshav Priyadarshi and others - All Rights Reserved.
*
* SPDX-License-Identifier: GPL-3.0-or-later
* You may use, distribute and modify this code under the
* terms of the GPL-3.0+ license.
*
* You should have received a copy of the GNU General Public License v3.0 with
* this file. If not, please visit https://www.gnu.org/licenses/gpl-3.0.html
*
* See https://safenotes.dev for support or download.
*/

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
