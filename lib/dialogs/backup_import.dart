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

  FileImportDialog({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double paddingAllAround = 10.0;
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
              _title(context, paddingAllAround),
              _body(context, paddingAllAround),
              _buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(BuildContext context, double padding) {
    final String title = 'Import your backup'.tr();
    final double topSpacing = 15.0;

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding:
            EdgeInsets.only(top: topSpacing, left: padding), //, right: 100),
        child: Text(title, style: dialogHeadTextStyle),
      ),
    );
  }

  Widget _body(BuildContext context, double padding) {
    final String cautionMessage =
        "If the Notes in your backup file was encrypted with different passphrase then you'll be prompted to enter the passphrase of the device that generated backup."
            .tr();
    final double topSpacing = 15.0;

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding:
            EdgeInsets.only(top: topSpacing, left: padding, bottom: padding),
        child: Text(cautionMessage, style: dialogBodyTextStyle),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    final double paddingAroundLR = 10.0;
    final double paddingAroundTB = 5.0;
    final double buttonTextFontSize = 14.0;
    final String yesButtonText = 'Select file'.tr();

    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.fromLTRB(
          paddingAroundLR, 0, paddingAroundLR, paddingAroundTB),
      child: ElevatedButton(
        child: _buttonText(yesButtonText, buttonTextFontSize),
        onPressed: this.callback,
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
          showSnackBarMessage(context, snackMessage);
        },
      );
    },
  );
}
