import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:safe_notes/databaseAndStorage/prefrence_sotorage_and_state_controls.dart';

class ImportPassPhraseDialog extends StatefulWidget {
  @override
  _ImportPassPhraseDialogState createState() =>
      new _ImportPassPhraseDialogState();
}

class _ImportPassPhraseDialogState extends State<ImportPassPhraseDialog> {
  bool isHiddenImport = true;
  final importPassphraseController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new BackdropFilter(
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
                  'Import Data is Encrypted',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                SizedBox(height: 12),
                Text(
                  'Enter the passphrase of the device that generated this file.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 15),
                buildPassField(),
                SizedBox(height: 15),
                ElevatedButton(
                    child: Text('Submit'),
                    onPressed: () async {
                      // await buildImport();
                      ImportPassPhraseHandler.setImportPassPhrase(
                          importPassphraseController.text);
                      Navigator.of(context).pop(true);
                    }),
              ],
            ),
          ),
        ));
  }

  Widget buildPassField() => TextFormField(
      controller: importPassphraseController,
      autofocus: true,
      enableInteractiveSelection: false,
      obscureText: isHiddenImport,
      decoration: InputDecoration(
          hintText: 'Encrypton Phrase',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: (isHiddenImport
                ? Icon(Icons.visibility_off)
                : Icon(Icons.visibility)),
            onPressed: togglePasswordVisibility,
          )),
      keyboardType: TextInputType.visiblePassword,
      onEditingComplete: () {
        ImportPassPhraseHandler.setImportPassPhrase(
            importPassphraseController.text);
        Navigator.of(context).pop(true);
      });

  void togglePasswordVisibility() =>
      setState(() => isHiddenImport = !isHiddenImport);
}
