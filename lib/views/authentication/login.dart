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
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:after_layout/after_layout.dart';
import 'package:crypto/crypto.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/dialogs/generic.dart';
import 'package:safenotes/models/biometric_auth.dart';
import 'package:safenotes/models/session.dart';
import 'package:safenotes/utils/snack_message.dart';
import 'package:safenotes/utils/styles.dart';
import 'package:safenotes/widgets/footer.dart';
import 'package:safenotes/widgets/login_button.dart';

class EncryptionPhraseLoginPage extends StatefulWidget {
  final StreamController<SessionState> sessionStream;
  final bool? isKeyboardFocused;

  const EncryptionPhraseLoginPage({
    Key? key,
    required this.sessionStream,
    this.isKeyboardFocused,
  }) : super(key: key);

  @override
  _EncryptionPhraseLoginPageState createState() =>
      _EncryptionPhraseLoginPageState();
}

class _EncryptionPhraseLoginPageState extends State<EncryptionPhraseLoginPage>
    with AfterLayoutMixin<EncryptionPhraseLoginPage> {
  // BiometricAuth:
  final LocalAuthentication auth = LocalAuthentication();
  _BiometricState _supportState = _BiometricState.unknown;
  bool forcePassphraseInput =
      PreferencesStorage.biometricAttemptAllTimeCount % 5 == 0;

  //ClassicLogin:
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final passPhraseController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool? _isKeyboardFocused;
  bool _isHidden = true;
  bool _isLocked = false;

  @override
  void initState() {
    super.initState();
    _noOfAllowedAttempts = PreferencesStorage.noOfLogginAttemptAllowed;
    _isKeyboardFocused = widget.isKeyboardFocused ?? true;

    // BiometricAuth:
    this.auth.isDeviceSupported().then(
      (bool isSupported) {
        setState(() => _supportState = isSupported
            ? _BiometricState.supported
            : _BiometricState.unsupported);
      },
    );
  }

  @override
  void dispose() {
    passPhraseController.dispose();
    super.dispose();
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    if (PreferencesStorage.isBiometricAuthEnabled &&
        (widget.isKeyboardFocused ?? true)) {
      await _authenticate();
    }
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
            'Login'.tr(),
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
                    _buildLoginWorkflow(context: context),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
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

  void scrollToBottomIfOnScreenKeyboard() {
    try {
      if (MediaQuery.of(context).viewInsets.bottom > 0)
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
    } catch (e) {}
  }

  Widget _buildTopLogo() {
    final double topPadding = MediaQuery.of(context).size.height * 0.050;
    final double dimensions =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.width * 0.40
            : MediaQuery.of(context).size.height * 0.40;

    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Center(
        child: Container(
          width: dimensions,
          height: dimensions,
          child: Image.asset(
            SafeNotesConfig.appLogoPath,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginWorkflow({required BuildContext context}) {
    final double padding = 16.0;

    return Form(
      key: this._formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: [
            _buildTimeOut(),
            _inputField(),
            _buildForgotPassphrase(),
            _buildLoginButton(),
            _buildBiometricAuthButton(context),
          ],
        ),
      ),
    );
  }

  _buildTimeOut() {
    if (_isLocked) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      passPhraseController.clear();

      _startTimer(
        () {
          setState(
            () {
              this._isLocked = false;
              this._isKeyboardFocused = true;
              this._formKey = GlobalKey<FormState>();
            },
          );
        },
      );

      return StreamBuilder(
        stream: _controller.stream,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          String? timeLeft =
              snapshot.hasData ? snapshot.data : _lockoutTime.toString();
          return Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Exceeded number of attempts, try after {timeLeft} seconds'
                    .tr(namedArgs: {'timeLeft': timeLeft.toString()}),
                style: TextStyle(
                  color: NordColors.aurora.red,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      );
    }
    return SizedBox(height: 20);
  }

  Widget _inputField() {
    final double inputBoxEdgeRadious = 10.0;

    return TextFormField(
      enabled: !_isLocked,
      enableIMEPersonalizedLearning: false,
      controller: passPhraseController,
      autofocus: this._isKeyboardFocused!,
      obscureText: this._isHidden,
      decoration: _inputFieldDecoration(inputBoxEdgeRadious),
      autofillHints: [AutofillHints.password],
      keyboardType: TextInputType.visiblePassword,
      onEditingComplete: _loginController,
      validator: _passphraseValidator,
    );
  }

  String? _passphraseValidator(String? passphrase) {
    final numberOfAttemptExceded = 'Number of attempt exceeded'.tr();

    if (_noOfAllowedAttempts <= 1) {
      setState(() {
        this._isLocked = true;
      });
      return numberOfAttemptExceded;
    }

    if (sha256.convert(utf8.encode(passphrase!)).toString() !=
        PreferencesStorage.passPhraseHash) {
      _noOfAllowedAttempts--;
      final wrongPhraseMsg =
          'Wrong passphrase {noOfAllowedAttempts} attempts left!'.tr(
              namedArgs: {
            'noOfAllowedAttempts': _noOfAllowedAttempts.toString()
          });

      return _noOfAllowedAttempts == 0
          ? numberOfAttemptExceded
          : wrongPhraseMsg;
    }

    return null;
  }

  InputDecoration _inputFieldDecoration(double inputBoxEdgeRadious) {
    final String hintText = 'Enter Passphrase'.tr();

    return InputDecoration(
      hintText: hintText,
      label: Text('Passphrase'.tr()),
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

  void _togglePasswordVisibility() {
    setState(() => this._isHidden = !this._isHidden);
  }

  Widget _buildLoginButton() {
    final String loginText = 'Login'.tr();

    return ButtonWidget(
      text: loginText,
      onClicked: this._isLocked ? null : () async => _loginController(),
    );
  }

  Widget _buildBiometricAuthButton(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            'OR'.tr(),
            style: TextStyle(fontSize: 15),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(top: 10, bottom: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shadowColor: PreferencesStorage.isThemeDark
                    ? NordColors.snowStorm.lightest
                    : NordColors.polarNight.darkest,
                minimumSize: Size(200, 50), //Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 5.0,
              ),
              child: Wrap(
                children: <Widget>[
                  Icon(
                    Icons.fingerprint,
                    size: 30.0,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Biometric'.tr(),
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              onPressed: (PreferencesStorage.isBiometricAuthEnabled &&
                      !this.forcePassphraseInput &&
                      !this._isLocked)
                  ? _authenticate
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  void _loginController() async {
    final form = this._formKey.currentState!;
    final snackMsgWrongEncryptionPhrase = 'Wrong passphrase!'.tr();

    if (form.validate()) {
      final phrase = passPhraseController.text;
      await _login(phrase);
    } else
      showSnackBarMessage(context, snackMsgWrongEncryptionPhrase);
  }

  Future<void> _login(String passphrase) async {
    final snackMsgDecryptingNotes = 'Decrypting your notes!'.tr();
    final snackMsgWrongEncryptionPhrase = 'Wrong passphrase!'.tr();
    if (sha256.convert(utf8.encode(passphrase)).toString() ==
        PreferencesStorage.passPhraseHash) {
      showSnackBarMessage(context, snackMsgDecryptingNotes);
      Session.login(passphrase);

      // re-enable biometric auth
      if (this.forcePassphraseInput)
        PreferencesStorage.incrementBiometricAttemptAllTimeCount();

      // start listening for session inactivity on successful login
      widget.sessionStream.add(SessionState.startListening);

      await Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: widget.sessionStream,
      );
    } else
      showSnackBarMessage(context, snackMsgWrongEncryptionPhrase);
  }

  Widget _buildForgotPassphrase() {
    final String cantRecoverPassphraseMsg =
        "Can't decrypt without phrase!".tr();
    double fontSize = 10;

    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        child: Text(
          cantRecoverPassphraseMsg,
          style: TextStyle(
            fontSize: fontSize,
          ),
        ),
        onPressed: () {
          showGenericDialog(
            context: context,
            icon: Icons.info_outline,
            message:
                'There is no way to decrypt these notes without the passphrase. With great security comes the great responsibility of remembering the passphrase!'
                    .tr(),
          );
        },
      ),
    );
  }

  Future<bool> _authenticate() async {
    bool authenticated = false;
    print(PreferencesStorage.biometricAttemptAllTimeCount);
    if (this._supportState == _BiometricState.unsupported) {
      showGenericDialog(
        context: context,
        icon: Icons.error_outline,
        message:
            "No biometrics found. Go to your device settings to enroll your biometric."
                .tr(),
      );
    } else if (this.forcePassphraseInput) {
      showGenericDialog(
        context: context,
        icon: Icons.info_outline,
        message:
            "Still remember your passphrase? Use passphrase to login this time."
                .tr(),
      );
    } else {
      PreferencesStorage.incrementBiometricAttemptAllTimeCount();
      try {
        authenticated = await this.auth.authenticate(
              localizedReason: 'Login using your biometric credential',
              options: const AuthenticationOptions(stickyAuth: true),
            );
      } catch (e) {
        //print(e);
      }
      if (authenticated) await _login(await BiometricAuth.authKey);
    }
    setState(() {
      this.forcePassphraseInput =
          PreferencesStorage.biometricAttemptAllTimeCount % 5 == 0;
    });
    return authenticated;
  }
}

int _noOfAllowedAttempts = PreferencesStorage.noOfLogginAttemptAllowed;
int _lockoutTime = PreferencesStorage.bruteforceLockOutTime;
int _counter = 0;

Timer? _timer;
StreamController<String> _controller = StreamController<String>.broadcast();

void _startTimer(VoidCallback callback) {
  _counter = _lockoutTime;

  if (_timer != null) _timer?.cancel();

  _timer = Timer.periodic(
    Duration(seconds: 1),
    (timer) {
      (_counter > 0) ? _counter-- : _timer?.cancel();
      _controller.add(_counter.toString().padLeft(2, '0'));
      if (_counter <= 0) {
        _noOfAllowedAttempts = PreferencesStorage.noOfLogginAttemptAllowed;
        callback();
      }
    },
  );
}

enum _BiometricState { unknown, supported, unsupported }
