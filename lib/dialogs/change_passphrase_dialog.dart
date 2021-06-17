import 'dart:ui';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:safe_notes/model/safe_note.dart';
import 'package:safe_notes/databaseAndStorage/prefrence_sotorage_and_state_controls.dart';
import 'package:safe_notes/databaseAndStorage/safe_notes_database.dart';

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
  bool isHiddenNewConfirm = false;
  final oldPassphraseController = TextEditingController();
  final newPassphraseController = TextEditingController();
  final newConfirmPassphraseController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
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
                        buildOldPassField(),
                        SizedBox(height: 15),
                        buildNewPassField(node),
                        SizedBox(height: 15),
                        buildNewConfirmPassField(),
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

  Widget buildOldPassField() => TextFormField(
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
      //onEditingComplete: () => node.nextFocus(),
      validator: (password) =>
          sha256.convert(utf8.encode(password!)).toString() !=
                  AppSecurePreferencesStorage.getPassPhraseHash()
              ? 'Wrong encryption Phrase!'
              : null);

  Widget buildNewPassField(node) => TextFormField(
        controller: newPassphraseController,
        autofocus: true,
        enableInteractiveSelection: false,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'New Passphrase',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          prefixIcon: Icon(Icons.lock),
        ),
        keyboardType: TextInputType.visiblePassword,
        onEditingComplete: () => node.nextFocus(),
        validator: (password) => password != null && password.length < 8
            ? 'Enter min. 8 characters'
            : null,
      );

  Widget buildNewConfirmPassField() => TextFormField(
      controller: newConfirmPassphraseController,
      //autofocus: true,
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
  void toggleNewConfirmPasswordVisibility() =>
      setState(() => isHiddenNewConfirm = !isHiddenNewConfirm);

  finalSublmitChange() async {
    final form = formKey.currentState!;
    if (form.validate()) {
      AppSecurePreferencesStorage.setPassPhraseHash(sha256
          .convert(utf8.encode(newConfirmPassphraseController.text))
          .toString());
      PhraseHandler.initPass(newConfirmPassphraseController.text);
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
