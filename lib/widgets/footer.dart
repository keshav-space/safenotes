// Flutter imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
              style: style.copyWith(
                fontFamily: 'NotoMonochromaticEmoji',
              ),
            ),
            Text(onEarth, style: style)
          ],
        ),
      ],
    ),
  );
}
