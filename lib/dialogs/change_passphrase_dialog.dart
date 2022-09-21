import 'dart:ui';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:safenotes/model/safe_note.dart';
import 'package:safenotes/databaseAndStorage/preference_storage_and_state_controls.dart';
import 'package:safenotes/databaseAndStorage/safe_notes_database.dart';

class ChangePassphraseDialog extends StatefulWidget {
  final List<SafeNote> allnotes;

  const ChangePassphraseDialog({
    Key? key,
    required this.allnotes,
  }) : super(key: key);

  @override
  _ChangePassphraseDialogState createState() =>
      new _ChangePassphraseDialogState();
}

class _ChangePassphraseDialogState extends State<ChangePassphraseDialog> {
  final formKey = GlobalKey<FormState>();
  bool isHiddenOld = true;
  bool isHiddenNew = true;
  bool isHiddenNewConfirm = true;
  final oldPassphraseController = TextEditingController();
  final newPassphraseController = TextEditingController();
  final newConfirmPassphraseController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final focusNew = FocusNode();
    final focusNewConfirm = FocusNode();
    return new BackdropFilter(
        filter: ImageFilter.blur(),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Text(
                  'Change Your Passphrase',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        buildOldPassField(focusNew),
                        SizedBox(height: 15),
                        buildNewPassField(focusNew, focusNewConfirm),
                        SizedBox(height: 15),
                        buildNewConfirmPassField(focusNewConfirm),
                        SizedBox(height: 15),
                        ElevatedButton(
                            child: Text('Submit'),
                            onPressed: () async {
                              await finalSublmitChange();
                            }),
                        //buildNoAccount(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildOldPassField(focusNew) => TextFormField(
      controller: oldPassphraseController,
      autofocus: true,
      enableInteractiveSelection: false,
      obscureText: isHiddenOld,
      decoration: InputDecoration(
          hintText: 'Old Passphrase',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: (isHiddenOld
                ? Icon(Icons.visibility_off)
                : Icon(Icons.visibility)),
            onPressed: toggleOldPasswordVisibility,
          )),
      keyboardType: TextInputType.visiblePassword,
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(focusNew);
      },
      validator: (password) =>
          sha256.convert(utf8.encode(password!)).toString() !=
                  AppSecurePreferencesStorage.getPassPhraseHash()
              ? 'Wrong encryption Phrase!'
              : null);

  Widget buildNewPassField(focusNew, focusNewConfirm) => TextFormField(
        controller: newPassphraseController,
        focusNode: focusNew,
        enableInteractiveSelection: false,
        obscureText: isHiddenNew,
        decoration: InputDecoration(
            hintText: 'New Passphrase',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            prefixIcon: Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: (isHiddenNew
                  ? Icon(Icons.visibility_off)
                  : Icon(Icons.visibility)),
              onPressed: toggleNewPasswordVisibility,
            )),
        keyboardType: TextInputType.visiblePassword,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(focusNewConfirm);
        },
        validator: (password) => password != null && password.length < 8
            ? 'Enter min. 8 characters'
            : null,
      );

  Widget buildNewConfirmPassField(focusNewConfirm) => TextFormField(
      controller: newConfirmPassphraseController,
      focusNode: focusNewConfirm,
      enableInteractiveSelection: false,
      obscureText: isHiddenNewConfirm,
      decoration: InputDecoration(
          hintText: 'Confirm Pass',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: (isHiddenNewConfirm
                ? Icon(Icons.visibility_off)
                : Icon(Icons.visibility)),
            onPressed: toggleNewConfirmPasswordVisibility,
          )),
      keyboardType: TextInputType.visiblePassword,
      onEditingComplete: () async => await finalSublmitChange(),
      validator: (password) => password != newPassphraseController.text
          ? 'Passphrase Mismatch!'
          : null);

  void toggleOldPasswordVisibility() =>
      setState(() => isHiddenOld = !isHiddenOld);
  void toggleNewPasswordVisibility() =>
      setState(() => isHiddenNew = !isHiddenNew);
  void toggleNewConfirmPasswordVisibility() =>
      setState(() => isHiddenNewConfirm = !isHiddenNewConfirm);

  finalSublmitChange() async {
    final form = formKey.currentState!;
    // Update SHA256 signature of passphrase
    if (form.validate()) {
      AppSecurePreferencesStorage.setPassPhraseHash(sha256
          .convert(utf8.encode(newConfirmPassphraseController.text))
          .toString());
      PhraseHandler.initPass(newConfirmPassphraseController.text);
      // Re-encrypt and update all the existing notes
      for (final note in widget.allnotes) {
        await NotesDatabase.instance.encryptAndUpdate(note);
      }
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Passphrase changed!'),
        ));
      Navigator.of(context).pop();
    }
  }
}
