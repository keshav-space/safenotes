import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:safenotes/models/app_theme.dart';
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/views/login_views/set_passphrase.dart';
import 'package:safenotes/views/login_views/login.dart';

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
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppInfo.getAppName(),
          //Theming out
          themeMode: themeProvider.themeMode,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,

          home: AppSecurePreferencesStorage.getPassPhraseHash() != null
              ? EncryptionPhraseLoginPage()
              : SetEncryptionPhrasePage(),
        );
      },
    );
  }
}
