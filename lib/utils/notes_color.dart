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

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';

class NotesColor extends ChangeNotifier {
  static Color getNoteColor({required int notIndex}) {
    var lightColors =
        allNotesColorTheme[PreferencesStorage.colorfulNotesColorIndex]
            .colorList;
    return PreferencesStorage.isColorful
        ? lightColors[notIndex % lightColors.length]
        : const Color(0xFFA7BEAE);
  }

  void toggleColor() {
    PreferencesStorage.setIsColorful(!PreferencesStorage.isColorful);
    notifyListeners();
  }
}

Color getFontColorForBackground(Color background) {
  return (background.computeLuminance() > 0.179) ? Colors.black : Colors.white;
}

class NotesColorTheme {
  final String prefix;
  final String? helper;
  final List colorList;
  const NotesColorTheme(
      {required this.prefix, this.helper, required this.colorList});
}

List<NotesColorTheme> allNotesColorTheme = [
  const NotesColorTheme(
    prefix: 'Nord Arctic',
    helper: 'Default',
    colorList: [
      Color(0xFF5E81AC),
      Color(0xFFD08770),
      Color(0xFFA3BE8C),
      Color(0xFFB48EAD),
      Color(0xFF81A1C1),
    ],
  ),
  const NotesColorTheme(
    prefix: 'Harmony',
    helper: 'Deep Blue, Northern Sky, Baby Blue and Coffee',
    colorList: [
      Color(0xFF2460A7),
      Color(0xFF85B3D1),
      Color(0xFFB3C7D6),
      Color(0xFFD9B48F),
    ],
  ),
  const NotesColorTheme(
    prefix: 'Refreshing',
    helper: 'Soft Pink, Peach Amber, Yucca and Arbor Green',
    colorList: [
      Color(0xFFFFDDE2),
      Color(0xFFFAA094),
      Color(0xFF9ED9CC),
      Color(0xFF008C76),
    ],
  ),
  const NotesColorTheme(
    prefix: 'Peace',
    helper: 'Blue Sky, Elation, Nugget and Celestial',
    colorList: [
      Color(0xFFABD1C9),
      Color(0xFFDFDCE5),
      Color(0xFFDBB04A),
      Color(0xFF97B3D0),
    ],
  ),
  const NotesColorTheme(
    prefix: 'Nostalgic',
    helper: 'Desert Sand, Burnished Brown, Old Burgundy and Mystic',
    colorList: [
      Color(0xFFDBBEA1),
      Color(0xFFA37B73),
      Color(0xFF3E282B),
      Color(0xFFD34F73),
    ],
  ),
  const NotesColorTheme(
    prefix: 'Sapphire',
    helper: 'Sapphire, Light Slate Gray, Cadet Gray and American Silver',
    colorList: [
      Color(0xFF2E5266),
      Color(0xFF6E8898),
      Color(0xFF9FB1BC),
      Color(0xFFD3D0CB),
    ],
  ),
  const NotesColorTheme(
    prefix: 'Ensemble',
    helper: 'Light Purple, Light Blue and Light Green',
    colorList: [
      Color(0xFFD7A9E3),
      Color(0xFF8BBEE8),
      Color(0xFFA8D5BA),
    ],
  ),
  const NotesColorTheme(
    prefix: 'Radiant',
    helper: 'Radiant Yellow, Living Coral and Purple',
    colorList: [
      Color(0xFFF9A12E),
      Color(0xFFFC766A),
      Color(0xFF9B4A97),
    ],
  ),
  const NotesColorTheme(
    prefix: 'Innocent',
    helper: 'White, Pink Lady and Sky Blue',
    colorList: [
      Color(0xFFFCF6F5),
      Color(0xFFEDC2D8),
      Color(0xFF8ABAD3),
    ],
  ),
  const NotesColorTheme(
    prefix: 'Oktoberfest',
    helper: 'Red, Yellow and Navy',
    colorList: [
      Color(0xFFF65058),
      Color(0xFFFBDE44),
      Color(0xFF28334A),
    ],
  ),
  const NotesColorTheme(
    prefix: 'Nature',
    helper: 'Tanager Turquoise, Teal Blue and Kelly Green',
    colorList: [
      Color(0xFF95DBE5),
      Color(0xFF078282),
      Color(0xFF339E66),
    ],
  ),
  const NotesColorTheme(
    prefix: 'Knockout',
    helper: 'Knockout Pink, Safety Yellow and Out of the Blue',
    colorList: [
      Color(0xFFFF3EA5),
      Color(0xFFEDFF00),
      Color(0xFF00A4CC),
    ],
  ),
  const NotesColorTheme(
    prefix: 'Danger',
    helper: 'Danger Red, Tap Shoe and Blue Blossom',
    colorList: [
      Color(0xFFD9514E),
      Color(0xFF2A2B2D),
      Color(0xFF2DA8D8),
    ],
  ),
  const NotesColorTheme(
    prefix: 'Light Teal',
    helper: null,
    colorList: [
      Color(0xFFA7BEAE),
    ],
  ),
  const NotesColorTheme(
    prefix: 'Fresh Mint',
    helper: null,
    colorList: [
      Color(0xFFADEFD1),
    ],
  ),
  const NotesColorTheme(
    prefix: 'Sailor Blue',
    helper: null,
    colorList: [
      Color(0xFF00203F),
    ],
  ),
];
