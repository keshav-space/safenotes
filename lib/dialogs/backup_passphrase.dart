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
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:crypto/crypto.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:safenotes_nord_theme/safenotes_nord_theme.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/utils/styles.dart';

class ImportPassPhraseDialog extends StatefulWidget {
  const ImportPassPhraseDialog({Key? key}) : super(key: key);

  @override
  _ImportPassPhraseDialogState createState() => _ImportPassPhraseDialogState();
}

class _ImportPassPhraseDialogState extends State<ImportPassPhraseDialog> {
  bool _isHiddenImport = true;
  final importPassphraseController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const double importDataPassDialogRadious = 10.0;

    return BackdropFilter(
      filter: ImageFilter.blur(),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(importDataPassDialogRadious),
        ),
        child: _buildImportPassDialog(context),
      ),
    );
  }

  Widget _buildImportPassDialog(BuildContext context) {
    const double paddingAllAround = 15.0;
    const double paddingTextTop = 12.0;
    final String titleHeading = 'Import Data is Encrypted'.tr();
    final String description =
        'Enter the passphrase of the device that generated this file.'.tr();

    return Padding(
      padding: const EdgeInsets.all(paddingAllAround),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: paddingTextTop),
            child: Text(
              titleHeading,
              style: dialogHeadTextStyle,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: paddingTextTop, bottom: paddingTextTop),
            child: Text(
              description,
              style: dialogBodyTextStyle,
            ),
          ),
          _buildPassField(context),
          _buildButtons(context),
        ],
      ),
    );
  }

  Widget _buildPassField(BuildContext context) {
    const double inputBoxRadius = 10.0;
    const double paddingTextBox = 15.0;
    final String inputBoxHint = 'Encryption Phrase'.tr();

    return Padding(
      padding: const EdgeInsets.only(top: paddingTextBox, bottom: paddingTextBox),
      child: Form(
        key: _formKey,
        child: TextFormField(
          enableIMEPersonalizedLearning: false,
          controller: importPassphraseController,
          autofocus: true,
          enableInteractiveSelection: false,
          obscureText: _isHiddenImport,
          decoration: InputDecoration(
            hintText: inputBoxHint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(inputBoxRadius),
            ),
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: !_isHiddenImport
                  ? const Icon(Icons.visibility_off)
                  : const Icon(Icons.visibility),
              onPressed: _togglePasswordVisibility,
            ),
          ),
          keyboardType: TextInputType.visiblePassword,
          validator: _passphraseValidator,
          onEditingComplete: _onEditonComplete,
        ),
      ),
    );
  }

  void _onEditonComplete() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      ImportPassPhraseHandler.setImportPassPhrase(
          importPassphraseController.text);
      Navigator.of(context).pop();
    }
  }

  String? _passphraseValidator(String? passphrase) {
    final wrongPhraseMsg = 'Wrong passphrase!'.tr();

    return sha256.convert(utf8.encode(passphrase!)).toString() !=
            ImportPassPhraseHandler.getImportPassPhraseHash()
        ? wrongPhraseMsg
        : null;
  }

  Widget _buildButtons(BuildContext context) {
    const double paddingAroundButtonRow = 15.0;
    const double buttonTextFontSize = 15.0;
    final String formSubmitButtonText = 'Submit'.tr();
    final String formCancelButtonText = 'Cancel'.tr();

    return Container(
      padding: const EdgeInsets.fromLTRB(paddingAroundButtonRow,
          paddingAroundButtonRow, paddingAroundButtonRow, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(NordColors.aurora.red),
              ),
              child: _buttonText(formCancelButtonText, buttonTextFontSize),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.06),
          Expanded(
            child: ElevatedButton(
              onPressed: _onEditonComplete,
              child: _buttonText(formSubmitButtonText, buttonTextFontSize),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonText(String text, double fontSize) {
    return AutoSizeText(
      text,
      textAlign: TextAlign.center,
      minFontSize: 8,
      maxLines: 1,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
    );
  }

  void _togglePasswordVisibility() =>
      setState(() => _isHiddenImport = !_isHiddenImport);
}
