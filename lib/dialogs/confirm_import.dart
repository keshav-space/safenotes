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
import 'package:safenotes/utils/styles.dart';

class ImportConfirm extends StatefulWidget {
  final int importCount;

  ImportConfirm({
    Key? key,
    required this.importCount,
  }) : super(key: key);

  @override
  _ImportConfirmState createState() => _ImportConfirmState();
}

class _ImportConfirmState extends State<ImportConfirm> {
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
              _body(paddingAllAround),
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title() {
    final String title = 'Confirm Import!'.tr();
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

  Widget _body(double padding) {
    final String cautionMessage =
        'Do you want to import {noOfNotesInImport} new notes?'.tr(
            namedArgs: {'noOfNotesInImport': widget.importCount.toString()});
    final double topSpacing = 15.0;

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(top: topSpacing, bottom: padding),
        child: Text(
          cautionMessage,
          style: dialogBodyTextStyle,
        ),
      ),
    );
  }

  Widget _buildButtons() {
    final double buttonTextFontSize = 15.0;
    final String cancelButtonText = 'Cancel'.tr();
    final String confirmButtonText = 'Confirm'.tr();

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
              child: _buttonText(cancelButtonText, buttonTextFontSize),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.1),
          Expanded(
            child: ElevatedButton(
              child: _buttonText(confirmButtonText, buttonTextFontSize),
              onPressed: () => Navigator.of(context)
                  .pop(true), // return false to dialog caller
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
