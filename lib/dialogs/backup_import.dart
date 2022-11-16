// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';

// Project imports:
import 'package:safenotes/models/file_handler.dart';
import 'package:safenotes/utils/snack_message.dart';

class FileImportDialog extends StatelessWidget {
  final VoidCallback callback;
  FileImportDialog({required this.callback});

  @override
  Widget build(BuildContext context) {
    final String titleImport = 'Import Your Backup'.tr();
    final String importDialogMessage = 'backupImportMessage'.tr();
    final String selectFileButtonName = 'Select File'.tr();
    final double titleFontSize = 22.0;
    final double dialogBordeRadious = 10.0;

    return BackdropFilter(
      filter: ImageFilter.blur(),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(dialogBordeRadious),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 12),
              Text(
                titleImport,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: titleFontSize,
                ),
              ),
              SizedBox(height: 12),
              Text(
                importDialogMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                child: Text(
                  selectFileButtonName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: this.callback,
              ),
            ],
          ),
        ),
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
