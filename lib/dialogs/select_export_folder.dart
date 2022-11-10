// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';

// Project imports:
import 'package:safenotes/utils/style.dart';

class ExportChooseDirectoryDialog extends StatefulWidget {
  @override
  _ExportChooseDirectoryDialogState createState() =>
      _ExportChooseDirectoryDialogState();
}

class _ExportChooseDirectoryDialogState
    extends State<ExportChooseDirectoryDialog> {
  final String dialogTitle = 'Destination Folder'.tr();
  final String chooseFolderMsg = 'chooseExportDestinationMessage'.tr();
  final String buttonText = 'Choose Folder'.tr();

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 12),
              Text(
                dialogTitle,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              SizedBox(height: 12),
              Text(
                chooseFolderMsg,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                child: Text(
                  buttonText,
                  style: Style.buttonTextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

showExportDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return ExportChooseDirectoryDialog();
    },
  );
}
