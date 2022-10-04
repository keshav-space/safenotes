// Dart imports:
import 'dart:convert';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:crypto/crypto.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';

// Project imports:
import 'package:safenotes/data/database_handler.dart';
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/models/safenote.dart';
import 'package:safenotes/utils/passphrase_strength.dart';

class ChangePassphraseDialog extends StatefulWidget {
  final List<SafeNote> allnotes;

  const ChangePassphraseDialog({
    Key? key,
    required this.allnotes,
  }) : super(key: key);

  @override
  _ChangePassphraseDialogState createState() => _ChangePassphraseDialogState();
}

class _ChangePassphraseDialogState extends State<ChangePassphraseDialog> {
  final formKey = GlobalKey<FormState>();
  bool _isHiddenOld = true;
  bool _isHiddenNew = true;
  bool _isHiddenNewConfirm = true;
  final _oldPassphraseController = TextEditingController();
  final _newPassphraseController = TextEditingController();
  final _newConfirmPassphraseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String changePassphraseTitle = 'Change Your Passphrase';
    final double dialogEdgeRadious = 10.0;
    final double dialogAllAroundPadding = 15.0;
    final double titleTopPadding = 10.0;
    final double titleFontSize = 20.0;

    return BackdropFilter(
      filter: ImageFilter.blur(),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(dialogEdgeRadious),
        ),
        child: Padding(
          padding: EdgeInsets.all(dialogAllAroundPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: titleTopPadding),
                child: Text(
                  changePassphraseTitle,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: titleFontSize),
                ),
              ),
              _buildPassphraseChangeWorkflow(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPassphraseChangeWorkflow(BuildContext context) {
    final focusNew = FocusNode();
    final focusNewConfirm = FocusNode();
    final double paddingAroundForm = 5.0;
    final double paddingBetweenInputBox = 15.0;

    return Form(
      key: this.formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(paddingAroundForm),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(top: paddingBetweenInputBox),
              child: _buildOldPassField(context, focusNew),
            ),
            Padding(
              padding: EdgeInsets.only(top: paddingBetweenInputBox),
              child: _buildNewPassField(context, focusNew, focusNewConfirm),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: paddingBetweenInputBox, bottom: paddingBetweenInputBox),
              child: _buildNewConfirmPassField(context, focusNewConfirm),
            ),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOldPassField(BuildContext context, FocusNode focusNew) {
    final double inputBoxEdgeRadious = 10.0;
    final String inputHintOld = 'Old Passphrase';
    final String validationErrorMsg = 'Wrong encryption Phrase!';

    return TextFormField(
      enableIMEPersonalizedLearning: false,
      controller: this._oldPassphraseController,
      autofocus: true,
      enableInteractiveSelection: false,
      obscureText: this._isHiddenOld,
      decoration: _inputBoxDecoration(
          context, 'first', inputHintOld, inputBoxEdgeRadious),
      keyboardType: TextInputType.visiblePassword,
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(focusNew);
      },
      validator: (passphrase) {
        return sha256.convert(utf8.encode(passphrase!)).toString() !=
                PreferencesStorage.getPassPhraseHash()
            ? validationErrorMsg
            : null;
      },
    );
  }

  Widget _buildNewPassField(
      BuildContext context, FocusNode focusNew, FocusNode focusNewConfirm) {
    final double inputBoxEdgeRadious = 10.0;
    final String inputHintNew = 'New Passphrase';

    return TextFormField(
      enableIMEPersonalizedLearning: false,
      controller: this._newPassphraseController,
      focusNode: focusNew,
      enableInteractiveSelection: false,
      obscureText: this._isHiddenNew,
      decoration: _inputBoxDecoration(
          context, 'second', inputHintNew, inputBoxEdgeRadious),
      keyboardType: TextInputType.visiblePassword,
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(focusNewConfirm);
      },
      validator: _firstInputValidator,
    );
  }

  String? _firstInputValidator(String? passphrase) {
    final int minPassphraseLength = 8;
    final double minPassphraseStrength = 0.5;
    final String minpCharacterMsg = 'Minimum 8 characters long!';
    final String tooWeakMsg = 'Passphrase is too weak!';

    return passphrase == null || passphrase.length < minPassphraseLength
        ? minpCharacterMsg
        : (estimateBruteforceStrength(passphrase) < minPassphraseStrength)
            ? tooWeakMsg
            : null;
  }

  Widget _buildNewConfirmPassField(
      BuildContext context, FocusNode focusNewConfirm) {
    final double inputBoxEdgeRadious = 10.0;
    final String inputHintConfirm = 'Confirm New Pass...';
    final String passPhraseMismatchMsg = 'Passphrase Mismatch!';

    return TextFormField(
      enableIMEPersonalizedLearning: false,
      controller: this._newConfirmPassphraseController,
      focusNode: focusNewConfirm,
      enableInteractiveSelection: false,
      obscureText: this._isHiddenNewConfirm,
      decoration: _inputBoxDecoration(
          context, 'third', inputHintConfirm, inputBoxEdgeRadious),
      keyboardType: TextInputType.visiblePassword,
      onEditingComplete: _finalSublmitChange,
      validator: (password) => password != _newPassphraseController.text
          ? passPhraseMismatchMsg
          : null,
    );
  }

  InputDecoration _inputBoxDecoration(BuildContext context, String inputFieldID,
      String inputHintText, double inputBoxEdgeRadious) {
    bool? visibility = null;
    if (inputFieldID == 'first') {
      visibility = this._isHiddenOld;
    } else if (inputFieldID == 'second') {
      visibility = this._isHiddenNew;
    } else {
      visibility = this._isHiddenNewConfirm;
    }

    return InputDecoration(
      hintText: inputHintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBoxEdgeRadious),
      ),
      prefixIcon: Icon(Icons.lock),
      suffixIcon: IconButton(
        icon: !visibility ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
        onPressed: () {
          if (inputFieldID == 'first') {
            return _toggleOldPasswordVisibility();
          } else if (inputFieldID == 'second') {
            return _toggleNewPasswordVisibility();
          } else {
            return _toggleNewConfirmPasswordVisibility();
          }
        },
      ),
    );
  }

  void _toggleOldPasswordVisibility() =>
      setState(() => this._isHiddenOld = !this._isHiddenOld);
  void _toggleNewPasswordVisibility() =>
      setState(() => this._isHiddenNew = !this._isHiddenNew);
  void _toggleNewConfirmPasswordVisibility() =>
      setState(() => this._isHiddenNewConfirm = !this._isHiddenNewConfirm);

  Widget _buildButtons(BuildContext context) {
    final double paddingAroundButtonRowLR = 20.0;
    final double paddingAroundButtonRowTop = 10.0;
    final double buttonTextFontSize = 16.0;
    final String submitButtonText = 'Submit';
    final String cancelButtonText = 'Cancel';

    return Container(
      padding: EdgeInsets.fromLTRB(paddingAroundButtonRowLR,
          paddingAroundButtonRowTop, paddingAroundButtonRowLR, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(NordColors.aurora.red),
            ),
            child: _buttonText(cancelButtonText, buttonTextFontSize),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: _buttonText(submitButtonText, buttonTextFontSize),
            onPressed: _finalSublmitChange,
          ),
        ],
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

  void _finalSublmitChange() async {
    final form = formKey.currentState!;
    final String passChangedSnackMsg = 'Passphrase changed!';

    // Update SHA256 signature of passphrase
    if (form.validate()) {
      PreferencesStorage.setPassPhraseHash(
        sha256
            .convert(utf8.encode(_newConfirmPassphraseController.text))
            .toString(),
      );
      PhraseHandler.initPass(_newConfirmPassphraseController.text);
      // Re-encrypt and update all the existing notes
      for (final note in widget.allnotes) {
        await NotesDatabase.instance.encryptAndUpdate(note);
      }
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(passChangedSnackMsg),
          ),
        );
      Navigator.of(context).pop();
    }
  }
}
