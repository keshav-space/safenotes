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
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:crypto/crypto.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:safenotes_nord_theme/safenotes_nord_theme.dart';

// Project imports:
import 'package:safenotes/data/database_handler.dart';
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/models/safenote.dart';
import 'package:safenotes/models/session.dart';
import 'package:safenotes/utils/passphrase_util.dart';
import 'package:safenotes/utils/snack_message.dart';
import 'package:safenotes/utils/styles.dart';

class ChangePassphrase extends StatefulWidget {
  const ChangePassphrase({Key? key}) : super(key: key);
  @override
  _ChangePassphraseState createState() => _ChangePassphraseState();
}

class _ChangePassphraseState extends State<ChangePassphrase> {
  final formKey = GlobalKey<FormState>();
  bool _isHiddenOld = true;
  bool _isHiddenNew = true;
  bool _isHiddenNewConfirm = true;
  final _oldPassphraseController = TextEditingController();
  final _newPassphraseController = TextEditingController();
  final _newConfirmPassphraseController = TextEditingController();
  final _scrollController = ScrollController();
  late List<SafeNote> allnotes;
  final _focusOld = FocusNode();
  final _focusNew = FocusNode();
  final _focusNewConfirm = FocusNode();

  @override
  initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void dispose() {
    _focusOld.dispose();
    _focusNew.dispose();
    _focusNewConfirm.dispose();
    super.dispose();
  }

  Future<void> _loadNotes() async {
    allnotes = await NotesDatabase.instance.decryptReadAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    scrollToBottomIfOnScreenKeyboard();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: SingleChildScrollView(
        //reverse: true,
        controller: _scrollController,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottom),
          child: _buildPassphraseChangeWorkflow(context),
        ),
      ),
    );
  }

  void scrollToBottomIfOnScreenKeyboard() {
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  Widget _buildPassphraseChangeWorkflow(BuildContext context) {
    final String pageTitleName = 'Change Passphrase'.tr();
    const double paddingBetweenInputBox = 25.0;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: paddingBetweenInputBox, bottom: 10),
              child: Text(
                pageTitleName,
                style: dialogHeadTextStyle.copyWith(
                  fontSize: 22,
                  color: PreferencesStorage.isThemeDark
                      ? Colors.white
                      : Colors.grey.shade600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: paddingBetweenInputBox),
              child: _buildCurrentPassField(),
            ),
            AutofillGroup(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: paddingBetweenInputBox),
                    child: _buildNewPassField(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: paddingBetweenInputBox,
                      bottom: paddingBetweenInputBox,
                    ),
                    child: _buildNewConfirmPassField(),
                  ),
                ],
              ),
            ),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentPassField() {
    const double inputBoxEdgeRadious = 10.0;
    final String inputHintOld = 'Current Passphrase'.tr();
    final String validationErrorMsg = 'Wrong passphrase!'.tr();

    return TextFormField(
      enableIMEPersonalizedLearning: false,
      controller: _oldPassphraseController,
      autofocus: true,
      focusNode: _focusOld,
      enableInteractiveSelection: false,
      obscureText: _isHiddenOld,
      decoration: _inputBoxDecoration(
        context,
        'first',
        inputHintOld,
        inputBoxEdgeRadious,
      ),
      autofillHints: const [AutofillHints.password],
      keyboardType: TextInputType.visiblePassword,
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(_focusNew);
      },
      textInputAction: TextInputAction.next,
      validator: (passphrase) {
        return sha256.convert(utf8.encode(passphrase!)).toString() !=
                PreferencesStorage.passPhraseHash
            ? validationErrorMsg
            : null;
      },
    );
  }

  Widget _buildNewPassField() {
    const double inputBoxEdgeRadious = 10.0;
    final String inputHintNew = 'New Passphrase'.tr();

    return TextFormField(
      enableIMEPersonalizedLearning: false,
      controller: _newPassphraseController,
      focusNode: _focusNew,
      enableInteractiveSelection: false,
      obscureText: _isHiddenNew,
      decoration: _inputBoxDecoration(
        context,
        'second',
        inputHintNew,
        inputBoxEdgeRadious,
      ),
      autofillHints: const [AutofillHints.password],
      keyboardType: TextInputType.visiblePassword,
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(_focusNewConfirm);
      },
      textInputAction: TextInputAction.next,
      validator: _firstInputValidator,
    );
  }

  String? _firstInputValidator(String? passphrase) {
    const int minPassphraseLength = 8;
    const double minPassphraseStrength = 0.5;
    final String minpCharacterMsg = 'Minimum 8 characters long!'.tr();
    final String tooWeakMsg = 'Passphrase is too weak!'.tr();

    return passphrase == null || passphrase.length < minPassphraseLength
        ? minpCharacterMsg
        : (estimateBruteforceStrength(passphrase) < minPassphraseStrength)
            ? tooWeakMsg
            : null;
  }

  Widget _buildNewConfirmPassField() {
    const double inputBoxEdgeRadious = 10.0;
    final String inputHintConfirm = 'Confirm New Passphrase'.tr();
    final String passPhraseMismatchMsg = 'Passphrase Mismatch!'.tr();

    return TextFormField(
      enableIMEPersonalizedLearning: false,
      controller: _newConfirmPassphraseController,
      focusNode: _focusNewConfirm,
      enableInteractiveSelection: false,
      obscureText: _isHiddenNewConfirm,
      decoration: _inputBoxDecoration(
        context,
        'third',
        inputHintConfirm,
        inputBoxEdgeRadious,
      ),
      autofillHints: const [AutofillHints.password],
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      onEditingComplete: _finalSublmitChange,
      validator: (password) => password != _newPassphraseController.text
          ? passPhraseMismatchMsg
          : null,
    );
  }

  InputDecoration _inputBoxDecoration(BuildContext context, String inputFieldID,
      String inputHintText, double inputBoxEdgeRadious) {
    bool? visibility;

    if (inputFieldID == 'first') {
      visibility = _isHiddenOld;
    } else if (inputFieldID == 'second') {
      visibility = _isHiddenNew;
    } else {
      visibility = _isHiddenNewConfirm;
    }

    return InputDecoration(
      hintText: inputHintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBoxEdgeRadious),
      ),
      prefixIcon: const Icon(Icons.lock),
      suffixIcon: IconButton(
        icon: !visibility ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
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
      setState(() => _isHiddenOld = !_isHiddenOld);
  void _toggleNewPasswordVisibility() =>
      setState(() => _isHiddenNew = !_isHiddenNew);
  void _toggleNewConfirmPasswordVisibility() =>
      setState(() => _isHiddenNewConfirm = !_isHiddenNewConfirm);

  Widget _buildButtons(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 10, top: 25, bottom: 20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shadowColor: PreferencesStorage.isThemeDark
                ? NordColors.snowStorm.lightest
                : NordColors.polarNight.darkest,
            minimumSize: const Size(200, 50), //Size.fromHeight(50),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 5.0, //StadiumBorder(),
          ),
          onPressed: _finalSublmitChange,
          child: Wrap(
            children: <Widget>[
              const Icon(Icons.key, size: 25.0),
              const SizedBox(width: 20),
              Text('Confirm'.tr(), style: const TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }

  void _finalSublmitChange() async {
    final form = formKey.currentState!;
    final String passChangedSnackMsg = 'Passphrase changed!'.tr();

    // Update SHA256 signature of passphrase
    if (form.validate()) {
      Session.setOrChangePassphrase(_newConfirmPassphraseController.text);
      // Re-encrypt and update all the existing notes
      for (final note in allnotes) {
        await NotesDatabase.instance.encryptAndUpdate(note);
      }
      showSnackBarMessage(context, passChangedSnackMsg);
      Navigator.of(context).pop();
    }
  }
}
