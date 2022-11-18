// Dart imports:
import 'dart:async';
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:crypto/crypto.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/dialogs/generic.dart';
import 'package:safenotes/models/session.dart';
import 'package:safenotes/utils/snack_message.dart';
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

class _EncryptionPhraseLoginPageState extends State<EncryptionPhraseLoginPage> {
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
  }

  @override
  void dispose() {
    passPhraseController.dispose();
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
          title: Text('Login'.tr()),
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
    final double topPadding = MediaQuery.of(context).size.height * 0.080;
    final double dimensions = MediaQuery.of(context).size.width * 0.45;

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
                'bruteForceTimer'
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
      keyboardType: TextInputType.visiblePassword,
      onEditingComplete: _loginController,
      validator: _passphraseValidator,
    );
  }

  String? _passphraseValidator(String? passphrase) {
    final numberOfAttemptExceded = 'Number of attempt exceeded'.tr();

    if (_noOfAllowedAttempts <= 0) {
      setState(() {
        this._isLocked = true;
      });
      return numberOfAttemptExceded;
    }

    if (sha256.convert(utf8.encode(passphrase!)).toString() !=
        PreferencesStorage.passPhraseHash) {
      _noOfAllowedAttempts--;
      final wrongPhraseMsg = 'noOfAttemptsLeftMessage'.tr(
          namedArgs: {'noOfAllowedAttempts': _noOfAllowedAttempts.toString()});

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

  void _loginController() async {
    final form = this._formKey.currentState!;
    final snackMsgDecryptingNotes = 'Decrypting your notes!'.tr();
    final snackMsgWrongEncryptionPhrase = 'Wrong passphrase!'.tr();

    if (form.validate()) {
      final phrase = passPhraseController.text;
      if (sha256.convert(utf8.encode(phrase)).toString() ==
          PreferencesStorage.passPhraseHash) {
        showSnackBarMessage(context, snackMsgDecryptingNotes);
        Session.login(phrase);

        // start listening for session inactivity on successful login
        widget.sessionStream.add(SessionState.startListening);

        await Navigator.pushReplacementNamed(
          context,
          '/home',
          arguments: widget.sessionStream,
        );
      } else
        showSnackBarMessage(context, snackMsgWrongEncryptionPhrase);
    } else
      showSnackBarMessage(context, snackMsgWrongEncryptionPhrase);
  }

  Widget _buildForgotPassphrase() {
    final String cantRecoverPassphraseMsg = 'cantDecryptMessage'.tr();

    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        child: Text(cantRecoverPassphraseMsg),
        onPressed: () {
          showGenericDialog(
            context: context,
            icon: Icons.info_outline,
            message: 'dialogForgotPassphrase'.tr(),
          );
        },
      ),
    );
  }
}

int _noOfAllowedAttempts = PreferencesStorage.noOfLogginAttemptAllowed;
int _lockoutTime = PreferencesStorage.bruteforceLockOutTime;
int _counter = 0;

Timer? _timer;
StreamController<String> _controller = StreamController<String>.broadcast();

void _startTimer(VoidCallback callback) {
  _counter = _lockoutTime;

  if (_timer != null) {
    _timer?.cancel();
  }

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
