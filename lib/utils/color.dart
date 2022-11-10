// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';

class NotesColor extends ChangeNotifier {
  static Color getNoteColor({required int notIndex}) {
    var _lightColors =
        allNotesColorTheme[PreferencesStorage.getColorfulNotesColorIndex()]
            .colorList;
    return PreferencesStorage.getIsColorful()
        ? _lightColors[notIndex % _lightColors.length]
        : Color(0xFFA7BEAE);
  }

  void toggleColor() {
    PreferencesStorage.setIsColorful(!PreferencesStorage.getIsColorful());
    notifyListeners();
  }
}

// class HexColor extends Color {
//   static int _getColorFromHex(String hexColor) {
//     hexColor = hexColor.toUpperCase().replaceAll("#", "");
//     if (hexColor.length == 6) {
//       hexColor = "FF" + hexColor;
//     }
//     return int.parse(hexColor, radix: 16);
//   }
//   HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
// }

class NotesColorTheme {
  final String prefix;
  final String? helper;
  final List<Color> colorList;
  const NotesColorTheme(
      {required this.prefix, this.helper, required this.colorList});
}

List<NotesColorTheme> allNotesColorTheme = [
  NotesColorTheme(
    prefix: 'Nord Arctic'.tr(),
    helper: 'Default'.tr(),
    colorList: <Color>[
      Color(0xFF5E81AC),
      Color(0xFFD08770),
      Color(0xFFA3BE8C),
      Color(0xFFB48EAD),
      Color(0xFF81A1C1),
    ],
  ),
  NotesColorTheme(
    prefix: 'Harmony'.tr(),
    helper: 'Deep Blue, Northern Sky, Baby Blue and Coffee'.tr(),
    colorList: <Color>[
      Color(0xFF2460A7),
      Color(0xFF85B3D1),
      Color(0xFFB3C7D6),
      Color(0xFFD9B48F),
    ],
  ),
  NotesColorTheme(
    prefix: 'Refreshing'.tr(),
    helper: 'Soft Pink, Peach Amber, Yucca and Arbor Green'.tr(),
    colorList: <Color>[
      Color(0xFFFFDDE2),
      Color(0xFFFAA094),
      Color(0xFF9ED9CC),
      Color(0xFF008C76),
    ],
  ),
  NotesColorTheme(
    prefix: 'Peace'.tr(),
    helper: 'Blue Sky, Elation, Nugget and Celestial'.tr(),
    colorList: <Color>[
      Color(0xFFABD1C9),
      Color(0xFFDFDCE5),
      Color(0xFFDBB04A),
      Color(0xFF97B3D0),
    ],
  ),
  NotesColorTheme(
    prefix: 'Nostalgic'.tr(),
    helper: 'Desert Sand, Burnished Brown, Old Burgundy and Mystic'.tr(),
    colorList: <Color>[
      Color(0xFFDBBEA1),
      Color(0xFFA37B73),
      Color(0xFF3E282B),
      Color(0xFFD34F73),
    ],
  ),
  NotesColorTheme(
    prefix: 'Sapphire'.tr(),
    helper: 'Sapphire, Light Slate Gray, Cadet Gray and American Silver'.tr(),
    colorList: <Color>[
      Color(0xFF2E5266),
      Color(0xFF6E8898),
      Color(0xFF9FB1BC),
      Color(0xFFD3D0CB),
    ],
  ),
  NotesColorTheme(
    prefix: 'Ensemble'.tr(),
    helper: 'Light Purple, Light Blue and Light Green'.tr(),
    colorList: <Color>[
      Color(0xFFD7A9E3),
      Color(0xFF8BBEE8),
      Color(0xFFA8D5BA),
    ],
  ),
  NotesColorTheme(
    prefix: 'Radiant'.tr(),
    helper: 'Radiant Yellow, Living Coral and Purple'.tr(),
    colorList: <Color>[
      Color(0xFFF9A12E),
      Color(0xFFFC766A),
      Color(0xFF9B4A97),
    ],
  ),
  NotesColorTheme(
    prefix: 'Innocent'.tr(),
    helper: 'White, Pink Lady and Sky Blue'.tr(),
    colorList: <Color>[
      Color(0xFFFCF6F5),
      Color(0xFFEDC2D8),
      Color(0xFF8ABAD3),
    ],
  ),
  NotesColorTheme(
    prefix: 'Oktoberfest'.tr(),
    helper: 'Red, Yellow and Navy'.tr(),
    colorList: <Color>[
      Color(0xFFF65058),
      Color(0xFFFBDE44),
      Color(0xFF28334A),
    ],
  ),
  NotesColorTheme(
    prefix: 'Nature'.tr(),
    helper: 'Tanager Turquoise, Teal Blue and Kelly Green'.tr(),
    colorList: <Color>[
      Color(0xFF95DBE5),
      Color(0xFF078282),
      Color(0xFF339E66),
    ],
  ),
  NotesColorTheme(
    prefix: 'Knockout'.tr(),
    helper: 'Knockout Pink, Safety Yellow and Out of the Blue'.tr(),
    colorList: <Color>[
      Color(0xFFFF3EA5),
      Color(0xFFEDFF00),
      Color(0xFF00A4CC),
    ],
  ),
  NotesColorTheme(
    prefix: 'Danger'.tr(),
    helper: 'Danger Red, Tap Shoe and Blue Blossom'.tr(),
    colorList: <Color>[
      Color(0xFFD9514E),
      Color(0xFF2A2B2D),
      Color(0xFF2DA8D8),
    ],
  ),
  NotesColorTheme(
    prefix: 'Light Teal'.tr(),
    helper: null,
    colorList: <Color>[
      Color(0xFFA7BEAE),
    ],
  ),
  NotesColorTheme(
    prefix: 'Fresh Mint'.tr(),
    helper: null,
    colorList: <Color>[
      Color(0xFFADEFD1),
    ],
  ),
  NotesColorTheme(
    prefix: 'Sailor Blue'.tr(),
    helper: null,
    colorList: <Color>[
      Color(0xFF00203F),
    ],
  ),
];

Color getFontColorForBackground(Color background) {
  return (background.computeLuminance() > 0.179) ? Colors.black : Colors.white;
}
