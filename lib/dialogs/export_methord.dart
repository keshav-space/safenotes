import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
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
                AppInfo.getExportDialogMsg(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                  child: Text('Encrypted (Recommended)'),
                  onPressed: () {
                    ExportEncryptionControl.setIsExportEncrypted(true);
                    Navigator.of(context).pop(true);
                  }),
              SizedBox(height: 15),
              Text(
                'OR',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                child: Text('Unencrypted (Unsecure)'),
                style: ButtonStyle(
                  //Highlight dangers of insecure export
                  backgroundColor:
                      MaterialStateProperty.all<Color>(NordColors.aurora.red),
                ),
                onPressed: () {
                  ExportEncryptionControl.setIsExportEncrypted(false);
                  Navigator.of(context).pop(true);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
