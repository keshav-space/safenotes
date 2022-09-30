// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:crypto/crypto.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/views/home.dart';
import 'package:safenotes/widgets/login_button.dart';

class EncryptionPhraseLoginPage extends StatefulWidget {
  @override
  _EncryptionPhraseLoginPageState createState() =>
      _EncryptionPhraseLoginPageState();
}

class _EncryptionPhraseLoginPageState extends State<EncryptionPhraseLoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isHidden = true;

  final passPhraseController = TextEditingController();
  _EncryptionPhraseLoginPageState();

  @override
  void dispose() {
    passPhraseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(AppInfo.getLoginPageName()),
            centerTitle: true,
            //actions: [TheamToggle()],
          ),
          body: Column(
            children: [
              _buildTopLogo(),
              _buildLoginWorkflow(context),
            ],
          ),
        ),
      );

  Widget _buildTopLogo() {
    const double topPadding = 90.0;
    final double logoWidth = 185.0;
    final double logoHeight = 185.0;
    return Padding(
      padding: const EdgeInsets.only(top: topPadding),
      child: Center(
        child: Container(
          width: logoWidth,
          height: logoHeight,
          child: Image.asset(AppInfo.getAppLogoPath()),
        ),
      ),
    );
  }

  Widget _buildLoginWorkflow(BuildContext context) {
    final double padding = 16.0;
    const double boxSeparation = 15.0;
    return Form(
      key: this._formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: [
            _inputField(),
            _buildForgotPassphrase(),
            _buildLoginButton(),
          ]..addAll(
              UnDecryptedLoginControl.getAllowLogUnDecrypted()
                  ? [
                      const SizedBox(height: boxSeparation),
                      Text('OR'),
                      const SizedBox(height: boxSeparation),
                      _buildUnDecrypt(),
                    ]
                  : [],
            ),
        ),
      ),
    );
  }

  Widget _inputField() {
    final double inputBoxEdgeRadious = 15.0;
    return TextFormField(
      enableIMEPersonalizedLearning: false,
      controller: passPhraseController,
      autofocus: true,
      obscureText: this._isHidden,
      decoration: _inputFieldDecoration(inputBoxEdgeRadious),
      keyboardType: TextInputType.visiblePassword,
      onEditingComplete: _loginController,
      validator: _passphraseValidator,
    );
  }

  String? _passphraseValidator(String? passphrase) {
    final wrongPhraseMsg = 'Wrong encryption Phrase!';

    return sha256.convert(utf8.encode(passphrase!)).toString() !=
            PreferencesStorage.getPassPhraseHash()
        ? wrongPhraseMsg
        : null;
  }

  InputDecoration _inputFieldDecoration(double inputBoxEdgeRadious) {
    return InputDecoration(
      hintText: 'Encrypton Phrase',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBoxEdgeRadious),
      ),
      prefixIcon: Icon(Icons.lock),
      suffixIcon: IconButton(
        icon: !this._isHidden
            ? Icon(Icons.visibility_off)
            : Icon(Icons.visibility),
        onPressed: _togglePasswordVisibility,
      ),
    );
  }

  void _togglePasswordVisibility() =>
      setState(() => this._isHidden = !this._isHidden);

  Widget _buildLoginButton() => ButtonWidget(
        text: 'LOGIN',
        onClicked: () async {
          _loginController();
        },
      );

  void _loginController() async {
    final form = this._formKey.currentState!;

    if (form.validate()) {
      final phrase = passPhraseController.text;
      if (sha256.convert(utf8.encode(phrase)).toString() ==
          PreferencesStorage.getPassPhraseHash()) {
        _snackBarMessage(context, 'Decrypting your notes!');

        PhraseHandler.initPass(phrase);
        UnDecryptedLoginControl.setNoDecryptionFlag(false);

        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => NotesPage()));
      } else {
        _snackBarMessage(context, 'Wrong Encryption Phrase!');
      }
    }
  }

  Widget _buildUnDecrypt() {
    return ButtonWidget(
      text: AppInfo.getUndecryptedLoginButtonText(),
      onClicked: () async {
        UnDecryptedLoginControl.setNoDecryptionFlag(true);
        await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => NotesPage()));
      },
    );
  }

  ScaffoldMessengerState _snackBarMessage(
      BuildContext context, String message) {
    return ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  Widget _buildForgotPassphrase() {
    final String cantRecoverPassphraseMsg = 'Can\'t decrypt without phrase!';
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        child: Text(cantRecoverPassphraseMsg),
        onPressed: () {},
      ),
    );
  }
}
