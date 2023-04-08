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

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onClicked;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double topSpacing = 10.0;

    return Padding(
      padding: EdgeInsets.only(top: topSpacing),
      child: SizedBox(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shadowColor: PreferencesStorage.isThemeDark
                ? NordColors.snowStorm.lightest
                : NordColors.polarNight.darkest,
            minimumSize: Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5.0,
          ),
          child: FittedBox(
            child: Text(
              text,
              style: TextStyle(fontSize: 20),
            ),
          ),
          onPressed: onClicked,
        ),
      ),
    );
  }
}
