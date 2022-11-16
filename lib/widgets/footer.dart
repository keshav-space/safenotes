// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';

Widget footer() {
  final double fontSize = 12;
  final Color color =
      PreferencesStorage.isThemeDark ? Color(0xFFafb8ba) : Color(0xFF8e989c);
  final TextStyle style = TextStyle(color: color, fontSize: fontSize);

  return Padding(
    padding: EdgeInsets.only(bottom: 20),
    child: Column(
      children: [
        Text("Safe Notes", style: style),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Made with ', style: style),
            Text(
              '♥',
              style: style.copyWith(
                fontFamily: 'NotoMonochromaticEmoji',
              ),
            ),
            Text(' on Earth', style: style)
          ],
        ),
      ],
    ),
  );
}
