// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';

class ExportMethordDialog extends StatefulWidget {
  @override
  _ExportMethorDialogState createState() => _ExportMethorDialogState();
}

class _ExportMethorDialogState extends State<ExportMethordDialog> {
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
                'Data Export Method',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              SizedBox(height: 12),
              Text(
                SafeNotesConfig.getExportDialogMsg(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                child: Text('Encrypted (Recommended)'),
                onPressed: () {
                  //ExportEncryptionControl.setIsExportEncrypted(true);
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
