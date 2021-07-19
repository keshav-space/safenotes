import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import 'package:safe_notes/page/safe_notes_page.dart';
import 'package:safe_notes/widget/login_widget/login_button_widget.dart';
import 'package:safe_notes/databaseAndStorage/prefrence_sotorage_and_state_controls.dart';

class SetEncryptionPhrasePage extends StatefulWidget {
  @override
  _SetEncryptionPhrasePageState createState() =>
      _SetEncryptionPhrasePageState();
}

class _SetEncryptionPhrasePageState extends State<SetEncryptionPhrasePage> {
  final formKey = GlobalKey<FormState>();
  final passPhraseController = TextEditingController();
  final passPhraseControllerConfirm = TextEditingController();
  bool isHidden = false;

  @override
  void dispose() {
    passPhraseController.dispose();
    passPhraseControllerConfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(AppInfo.getFirstLoginPageName()),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 90.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 200,
                    child: Image.asset(AppInfo.getAppLogoPath())),
              ),
            ),
            Form(
              key: formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    inputFieldFirst(node),
                    const SizedBox(height: 10),
                    inputFieldSecond(),
                    buildForgotPassword(),
                    //const SizedBox(height: 16),
                    buildButton(),
                    //buildNoAccount(),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget inputFieldFirst(node) => TextFormField(
        controller: passPhraseController,
        autofocus: true,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Encryption Phrase',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(Icons.lock),
        ),
        keyboardType: TextInputType.visiblePassword,
        onEditingComplete: () => node.nextFocus(),
        validator: (password) => password != null && password.length < 8
            ? 'Must be at least 8 characters long!'
            : (estimateBruteforceStrength(password!) < 0.6)
                ? 'Passphrase is too weak!'
                : null,
      );

  Widget inputFieldSecond() => TextFormField(
      controller: passPhraseControllerConfirm,
      obscureText: isHidden,
      decoration: InputDecoration(
          hintText: 'Confirm Encryption Phrase',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: (isHidden
                ? Icon(Icons.visibility_off)
                : Icon(Icons.visibility)),
            onPressed: togglePasswordVisibility,
          )),
      keyboardType: TextInputType.visiblePassword,
      onEditingComplete: loginController,
      validator: (password) => password != passPhraseController.text
          ? 'Encryption Phrase mismatch!'
          : null);

  void togglePasswordVisibility() => setState(() => isHidden = !isHidden);

  Widget buildButton() => ButtonWidget(
        text: 'LOGIN',
        onClicked: () async {
          loginController();
        },
      );

  void loginController() async {
    final form = formKey.currentState!;

    if (form.validate()) {
      final phrase1 = passPhraseController.text;
      final phrase2 = passPhraseControllerConfirm.text;
      if (phrase2 == phrase1) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text('Encryption Phrase set!'),
          ));
        // Setting passhash phrase in share prefrences

        AppSecurePreferencesStorage.setPassPhraseHash(
            sha256.convert(utf8.encode(phrase2)).toString());
        PhraseHandler.initPass(phrase2);

        UnDecryptedLoginControl.setNoDecryptionFlag(false);

        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => NotesPage()));
      } else {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text('Encryption Phrase missmach!'),
          ));
      }
    }
  }

  double estimateBruteforceStrength(String password) {
    if (password.isEmpty || password.length < 8) return 0.0;

    // Check which types of characters are used and create an opinionated bonus.
    double charsetBonus;
    if (RegExp(r'^[a-z]*$').hasMatch(password)) {
      charsetBonus = 1.0;
    } else if (RegExp(r'^[a-z0-9]*$').hasMatch(password)) {
      charsetBonus = 1.2;
    } else if (RegExp(r'^[a-zA-Z]*$').hasMatch(password)) {
      charsetBonus = 1.3;
    } else if (RegExp(r'^[a-z\-_!?]*$').hasMatch(password)) {
      charsetBonus = 1.3;
    } else if (RegExp(r'^[a-zA-Z0-9]*$').hasMatch(password)) {
      charsetBonus = 1.5;
    } else {
      charsetBonus = 1.8;
    }

    final logisticFunction = (double x) {
      return 1.0 / (1.0 + exp(-x));
    };

    final curve = (double x) {
      return logisticFunction((x / 3.0) - 4.0);
    };

    return curve(password.length * charsetBonus);
  }

/*   Widget buildNoAccount() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Don\'t have an account?'),
          TextButton(
            child: Text('SIGN UP'),
            onPressed: () {},
          ),
        ],
      ); */

  Widget buildForgotPassword() => Container(
        alignment: Alignment.centerRight,
        child: TextButton(
          child: Text('Use Strong Phrase!'),
          onPressed: () {},
        ),
      );
}
