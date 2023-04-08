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
import 'package:easy_localization/easy_localization.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';

Widget footer() {
  final double fontSize = 12;
  final Color color =
      PreferencesStorage.isThemeDark ? Color(0xFFafb8ba) : Color(0xFF8e989c);
  final TextStyle style = TextStyle(color: color, fontSize: fontSize);
  final footerSecondText = 'Made with ♥ on Earth'.tr().split('♥');
  final madeWith = footerSecondText[0];
  final onEarth = footerSecondText[1];

  return Padding(
    padding: EdgeInsets.only(bottom: 20),
    child: Column(
      children: [
        Text('Safe Notes'.tr(), style: style),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(madeWith, style: style),
            Text(
              '♥',
              style: style.copyWith(fontFamily: 'NotoMonochromaticEmoji'),
            ),
            Text(onEarth, style: style)
          ],
        ),
      ],
    ),
  );
}
