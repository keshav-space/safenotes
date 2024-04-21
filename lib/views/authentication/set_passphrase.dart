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
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/dialogs/generic.dart';
import 'package:safenotes/models/session.dart';
import 'package:safenotes/utils/passphrase_util.dart';
import 'package:safenotes/utils/snack_message.dart';
import 'package:safenotes/utils/styles.dart';
import 'package:safenotes/widgets/footer.dart';
import 'package:safenotes/widgets/login_button.dart';

class SetEncryptionPhrasePage extends StatefulWidget {
  final StreamController<SessionState> sessionStream;
  final bool? isKeyboardFocused;

  const SetEncryptionPhrasePage({
    Key? key,
    required this.sessionStream,
    this.isKeyboardFocused,
  }) : super(key: key);

  @override
  SetEncryptionPhrasePageState createState() => SetEncryptionPhrasePageState();
}

class SetEncryptionPhrasePageState extends State<SetEncryptionPhrasePage> {
  final _formKey = GlobalKey<FormState>();
  final _passPhraseController = TextEditingController();
  final _passPhraseControllerConfirm = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final _focusFirst = FocusNode();
  final _focusSecond = FocusNode();
  bool _isHiddenFirst = true;
  bool _isHiddenConfirm = true;

  @override
  void dispose() {
    _passPhraseController.dispose();
    _passPhraseControllerConfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    scrollToBottomIfOnScreenKeyboard();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Set Passphrase'.tr(),
            style: appBarTitle,
          ),
          centerTitle: true,
        ),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.only(bottom: bottom),
                child: Column(
                  children: [
                    _buildTopLogo(),
                    _buildPassphraseSetWorkflow(context),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: footer(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopLogo() {
    final double topPadding = MediaQuery.of(context).size.height * 0.070;
    final double dimensions =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.width * 0.40
            : MediaQuery.of(context).size.height * 0.40;

    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Center(
        child: SizedBox(
          width: dimensions,
          height: dimensions,
          child: Image.asset(SafeNotesConfig.appLogoPath),
        ),
      ),
    );
  }

  Widget _buildPassphraseSetWorkflow(BuildContext context) {
    const double padding = 16.0;
    const double inputBoxSeparation = 10.0;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(padding),
        child: Column(
          children: [
            AutofillGroup(
              child: Column(
                children: [
                  _inputFieldFirst(),
                  const SizedBox(height: inputBoxSeparation),
                  _inputFieldConfirm(context),
                ],
              ),
            ),
            _buildForgotPassphrase(),
            _buildLoginButton(),
          ],
        ),
      ),
    );
  }

  void scrollToBottomIfOnScreenKeyboard() {
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  Widget _inputFieldFirst() {
    const double inputBoxEdgeRadius = 10.0;
    final String firstHintText = 'New Passphrase'.tr();

    return TextFormField(
      enableIMEPersonalizedLearning: false,
      controller: _passPhraseController,
      autofocus: widget.isKeyboardFocused ?? true, //true,
      obscureText: _isHiddenFirst,
      focusNode: _focusFirst,
      decoration: _inputBoxDecoration(
        inputFieldID: 'first',
        inputHintText: firstHintText,
        label: firstHintText,
        inputBoxEdgeRadius: inputBoxEdgeRadius,
      ),
      autofillHints: const [AutofillHints.password],

      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(_focusSecond);
      },
      validator: _firstInputValidator,
    );
  }

  Widget _inputFieldConfirm(BuildContext context) {
    const double inputBoxEdgeRadius = 10.0;
    const double padding = 10.0;
    final String confirmHintText = 'Re-enter Passphrase'.tr();

    return Padding(
      padding: const EdgeInsets.only(top: padding),
      child: TextFormField(
        enableIMEPersonalizedLearning: false,
        controller: _passPhraseControllerConfirm,
        focusNode: _focusSecond,
        obscureText: _isHiddenConfirm,
        decoration: _inputBoxDecoration(
          inputFieldID: 'confirm',
          inputHintText: confirmHintText,
          label: confirmHintText,
          inputBoxEdgeRadius: inputBoxEdgeRadius,
        ),
        autofillHints: const [AutofillHints.password],
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.done,
        onEditingComplete: _loginController,
        validator: _confirmInputValidator,
      ),
    );
  }

  InputDecoration _inputBoxDecoration({
    required String inputFieldID,
    required String inputHintText,
    required String label,
    required double inputBoxEdgeRadius,
  }) {
    bool? visibility;

    if (inputFieldID == 'first') {
      visibility = _isHiddenFirst;
    } else {
      visibility = _isHiddenConfirm;
    }

    return InputDecoration(
      hintText: inputHintText,
      label: Text(label),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBoxEdgeRadius),
      ),
      prefixIcon: const Icon(Icons.lock),
      suffixIcon: IconButton(
        icon: !visibility
            ? const Icon(Icons.visibility_off)
            : const Icon(Icons.visibility),
        onPressed: () {
          if (inputFieldID == 'first') {
            return setState(() => _isHiddenFirst = !_isHiddenFirst);
          } else {
            return setState(() => _isHiddenConfirm = !_isHiddenConfirm);
          }
        },
      ),
    );
  }

  String? _firstInputValidator(String? passphrase) {
    const int minPassphraseLength = 8;
    const double minPassphraseStrength = 0.5;

    return passphrase == null || passphrase.length < minPassphraseLength
        ? 'Must be at least 8 characters long!'.tr()
        : (estimateBruteforceStrength(passphrase) < minPassphraseStrength)
            ? 'Passphrase is too weak!'.tr()
            : null;
  }

  String? _confirmInputValidator(String? passphraseConfirm) {
    return passphraseConfirm == null ||
            passphraseConfirm != _passPhraseController.text
        ? 'Passphrase mismatch!'.tr()
        : null;
  }

  Widget _buildLoginButton() {
    return ButtonWidget(
      text: 'Confirm'.tr(),
      onClicked: () async {
        _loginController();
      },
    );
  }

  Widget _buildForgotPassphrase() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        child: Text('What is passphrase?'.tr()),
        onPressed: () {
          showGenericDialog(
            context: context,
            icon: Icons.info_outline,
            message:
                'Passphrase is similar to password but generally longer, it will be used to encrypt and decrypt your notes. Use strong passphrase and make sure to remember it. It is impossible to decrypt your notes without the passphrase. With great security comes the great responsibility of remembering the passphrase!'
                    .tr(),
          );
        },
      ),
    );
  }

  void _loginController() async {
    final form = _formKey.currentState!;

    if (form.validate()) {
      final enteredPassphrase = _passPhraseController.text;
      final enteredPassphraseConfirm = _passPhraseControllerConfirm.text;

      if (enteredPassphrase == enteredPassphraseConfirm) {
        showSnackBarMessage(context, 'Passphrase set!'.tr());

        // Setting hash for PassPhrase in share prefrences
        Session.setOrChangePassphrase(enteredPassphrase);
        // start listening for session inactivity on successful login
        widget.sessionStream.add(SessionState.startListening);

        TextInput.finishAutofillContext();
        await Navigator.pushReplacementNamed(
          context,
          '/home',
          arguments: widget.sessionStream,
        );
      } else {
        showSnackBarMessage(context, 'Passphrase mismatch!'.tr());
      }
    }
  }
}
