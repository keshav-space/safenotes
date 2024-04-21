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
import 'package:easy_localization/easy_localization.dart';

// Project imports:
import 'package:safenotes/models/file_handler.dart';
import 'package:safenotes/utils/snack_message.dart';
import 'package:safenotes/utils/styles.dart';

class FileImportDialog extends StatelessWidget {
  final VoidCallback callback;

  const FileImportDialog({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double paddingAllAround = 20.0;
    const double dialogRadius = 10.0;

    return BackdropFilter(
      filter: ImageFilter.blur(),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(dialogRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(paddingAllAround),
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
    final String title = 'Import your backup'.tr();

    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: dialogHeadTextStyle,
      ),
    );
  }

  Widget _body() {
    final String cautionMessage =
        "If the Notes in your backup file was encrypted with different passphrase then you'll be prompted to enter the passphrase of the device that generated backup."
            .tr();
    const double topSpacing = 10.0;

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: topSpacing),
        child: Text(
          cautionMessage,
          style: dialogBodyTextStyle,
        ),
      ),
    );
  }

  Widget _buildButtons() {
    const double buttonTextFontSize = 15.0;
    final String yesButtonText = 'Select file'.tr();

    return Container(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: callback,
        child: _buttonText(yesButtonText, buttonTextFontSize),
      ),
    );
  }

  Widget _buttonText(String text, double fontSize) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
    );
  }
}

Future<void> showImportDialog(BuildContext context,
    {VoidCallback? homeRefresh}) async {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext contextChild) {
      return FileImportDialog(
        callback: () async {
          Navigator.of(contextChild).pop();
          String? snackMessage =
              await FileHandler().selectFileAndImport(context);
          if (homeRefresh != null) homeRefresh();

          // TODO: refactor without using BuildContexts across async gap
          if (context.mounted) showSnackBarMessage(context, snackMessage);
        },
      );
    },
  );
}
