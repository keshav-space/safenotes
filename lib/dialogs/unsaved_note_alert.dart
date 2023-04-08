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

// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';

// Project imports:
import 'package:safenotes/models/editor_state.dart';
import 'package:safenotes/utils/styles.dart';

class UnsavedAlert extends StatefulWidget {
  @override
  _UnsavedAlertState createState() => _UnsavedAlertState();
}

class _UnsavedAlertState extends State<UnsavedAlert> {
  @override
  Widget build(BuildContext context) {
    final double paddingAllAround = 20.0;
    final double dialogRadius = 10.0;

    return BackdropFilter(
      filter: ImageFilter.blur(),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(dialogRadius),
        ),
        child: Padding(
          padding: EdgeInsets.all(paddingAllAround),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _title(),
              _body(),
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title() {
    final String title = 'Are you sure?'.tr();
    final double topSpacing = 10.0;

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(top: topSpacing), //, right: 100),
        child: Text(
          title,
          style: dialogHeadTextStyle,
        ),
      ),
    );
  }

  Widget _body() {
    final String cautionMessage = 'Do you want to discard changes.'.tr();
    final double topSpacing = 15.0;

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(top: topSpacing, bottom: topSpacing),
        child: Text(
          cautionMessage,
          //textAlign: TextAlign.center,
          style: dialogBodyTextStyle,
        ),
      ),
    );
  }

  Widget _buildButtons() {
    final double buttonTextFontSize = 15.0;
    final String yesButtonText = 'Yes'.tr();
    final String noButtonText = 'No'.tr();

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(NordColors.aurora.red),
              ),
              child: _buttonText(yesButtonText, buttonTextFontSize),
              onPressed: () {
                // User was warned about unsaved change, and user choose to
                // discard the changes hence the NoteEditorState().handleUngracefulExit() won't save the notes
                NoteEditorState.setSaveAttempted(true);
                Navigator.of(context).pop(true);
              },
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.06),
          Expanded(
            child: ElevatedButton(
              child: _buttonText(noButtonText, buttonTextFontSize),
              onPressed: () => Navigator.of(context).pop(false),
              // return false to dialog caller
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonText(String text, double fontSize) {
    return AutoSizeText(
      text,
      textAlign: TextAlign.center,
      minFontSize: 8,
      maxLines: 1,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
    );
  }
}
