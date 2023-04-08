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

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:safenotes/authwall.dart';
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/models/app_theme.dart';
import 'package:safenotes/routes/route_generator.dart';
import 'package:safenotes/utils/notes_color.dart';

class App extends StatelessWidget {
  final StreamController<SessionState> sessionStateStream;
  final GlobalKey<NavigatorState> navigatorKey;

  App({Key? key, required this.sessionStateStream, required this.navigatorKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<NotesColor>(create: (_) => NotesColor()),
      ],
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          initialRoute: '/',
          onGenerateRoute: RouteGenerator.generateRoute,
          title: SafeNotesConfig.appName,
          themeMode: themeProvider.themeMode,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: AuthWall(sessionStateStream: sessionStateStream),
        );
      },
    );
  }
}
