import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import 'package:safe_notes/page/safe_notes_page.dart';
import 'package:safe_notes/widget/login_widget/login_button_widget.dart';
import 'package:safe_notes/databaseAndStorage/prefrence_sotorage_and_state_controls.dart';

class EncryptionPhraseLoginPage extends StatefulWidget {
  @override
  _EncryptionPhraseLoginPageState createState() =>
      _EncryptionPhraseLoginPageState();
}

class _EncryptionPhraseLoginPageState extends State<EncryptionPhraseLoginPage> {
  final formKey = GlobalKey<FormState>();
  bool isHidden = true;

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
            Padding(
              padding: const EdgeInsets.only(top: 110.0),
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
                child: UnDecryptedLoginControl.getAllowLogUnDecrypted()
                    ? columnAllowNonDecrypt()
                    : columnDefault(),
              ),
            ),
          ],
        ),
      ));

  Widget columnAllowNonDecrypt() => Column(
        children: [
          buildField(),
          //const SizedBox(height: 10),
          buildForgotPassword(),
          //const SizedBox(height: 10),
          buildLogInButton(),
          const SizedBox(height: 15),
          Text('OR'),
          const SizedBox(height: 15),
          buildUnDecrypt(),
          //buildNoAccount(),
        ],
      );

  Widget columnDefault() => Column(
        children: [
          buildField(),
          const SizedBox(height: 16),
          buildForgotPassword(),
          const SizedBox(height: 16),
          buildLogInButton(),
        ],
      );

  Widget buildField() => TextFormField(
      controller: passPhraseController,
      autofocus: true,
      obscureText: isHidden,
      decoration: InputDecoration(
          hintText: 'Encrypton Phrase',
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
      validator: (password) =>
          sha256.convert(utf8.encode(password!)).toString() !=
                  AppSecurePreferencesStorage.getPassPhraseHash()
              ? 'Wrong encryption Phrase!'
              : null);
  void togglePasswordVisibility() => setState(() => isHidden = !isHidden);

  Widget buildLogInButton() => ButtonWidget(
        text: 'LOGIN',
        onClicked: () async {
          loginController();
        },
      );

  void loginController() async {
    final form = formKey.currentState!;

    if (form.validate()) {
      final phrase = passPhraseController.text;
      if (sha256.convert(utf8.encode(phrase)).toString() ==
          AppSecurePreferencesStorage.getPassPhraseHash()) {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text('Decrypting your notes!'),
          ));
        PhraseHandler.initPass(phrase);
        UnDecryptedLoginControl.setNoDecryptionFlag(false);

        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => NotesPage()));
      } else {
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text('Wrong Encryption Phrase!'),
          ));
      }
    }
  }

  Widget buildUnDecrypt() => ButtonWidget(
        text: AppInfo.getUndecryptedLoginButtonText(),
        onClicked: () async {
          UnDecryptedLoginControl.setNoDecryptionFlag(true);
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => NotesPage()));
        },
      );

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
          child: Text('Can\'t decrypt without phrase!'),
          onPressed: () {},
        ),
      );
}
