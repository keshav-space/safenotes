import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:safe_notes/model/app_theme.dart';
import 'package:safe_notes/databaseAndStorage/prefrence_sotorage_and_state_controls.dart';
import 'package:safe_notes/page/login_page/set_encryption_phrase_page.dart';
import 'package:safe_notes/page/login_page/encryption_phrase_login_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await AppSecurePreferencesStorage.init();
  runApp(SafeNotes());
}

class SafeNotes extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppInfo.getAppName(),
          //Themaing out
          themeMode: themeProvider.themeMode,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,

          home: AppSecurePreferencesStorage.getPassPhraseHash() != null
              ? EncryptionPhraseLoginPage()
              : SetEncryptionPhrasePage(),
        );
      });
}
