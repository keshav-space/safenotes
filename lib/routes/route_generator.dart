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
import 'package:page_transition/page_transition.dart';

// Project imports:
import 'package:safenotes/authwall.dart';
import 'package:safenotes/main.dart';
import 'package:safenotes/models/safenote.dart';
import 'package:safenotes/models/session.dart';
import 'package:safenotes/views/add_edit_note.dart';
import 'package:safenotes/views/authentication/login.dart';
import 'package:safenotes/views/authentication/set_passphrase.dart';
import 'package:safenotes/views/change_passphrase.dart';
import 'package:safenotes/views/home.dart';
import 'package:safenotes/views/note_view.dart';
import 'package:safenotes/views/settings/autorotate_settings.dart';
import 'package:safenotes/views/settings/backup_setting.dart';
import 'package:safenotes/views/settings/biometric_setting.dart';
import 'package:safenotes/views/settings/inactivity_setting.dart';
import 'package:safenotes/views/settings/language_setting.dart';
import 'package:safenotes/views/settings/notes_color_setting.dart';
import 'package:safenotes/views/settings/secure_display_setting.dart';
import 'package:safenotes/views/settings/settings.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    var args = settings.arguments;
    final String? routeName = settings.name;
    const transitionDuration = 300;
    const transitionType = PageTransitionType.leftToRight;

    switch (routeName) {
      case '/':
        return PageTransition(
          child: SafeNotesApp(),
          duration: const Duration(milliseconds: transitionDuration),
          type: transitionType,
        );

      case '/login':
        if (args is SessionArguments) {
          return PageTransition(
            child: EncryptionPhraseLoginPage(
              sessionStream: args.sessionStream,
              isKeyboardFocused: args.isKeyboardFocused,
            ),
            duration: const Duration(milliseconds: transitionDuration),
            type: transitionType,
          );
        }
        return _errorRoute(
            route: routeName, argsType: 'StreamController<SessionState>');

      case '/signup':
        if (args is SessionArguments) {
          return PageTransition(
            child: SetEncryptionPhrasePage(
              sessionStream: args.sessionStream,
              isKeyboardFocused: args.isKeyboardFocused,
            ),
            duration: const Duration(milliseconds: transitionDuration),
            type: transitionType,
          );
        }
        return _errorRoute(
            route: routeName, argsType: 'StreamController<SessionState>');

      case '/authwall':
        if (args is SessionArguments) {
          return PageTransition(
            child: AuthWall(
              sessionStateStream: args.sessionStream,
              isKeyboardFocused: args.isKeyboardFocused,
            ),
            duration: const Duration(milliseconds: transitionDuration),
            type: transitionType,
          );
        }
        return _errorRoute(
            route: routeName, argsType: 'StreamController<SessionState>');

      case '/home':
        if (args is StreamController<SessionState>) {
          return PageTransition(
            child: HomePage(sessionStateStream: args),
            duration: const Duration(milliseconds: transitionDuration),
            type: transitionType,
          );
        }
        return _errorRoute(
            route: routeName, argsType: 'StreamController<SessionState>');

      case '/viewnote':
        if (args is NoteDetailPageArguments) {
          //SafeNote note = args;
          return PageTransition(
            child: NoteDetailPage(
              noteId: args.note.id!,
              sessionStateStream: args.sessionStream,
            ),
            duration: const Duration(milliseconds: transitionDuration),
            type: transitionType,
          );
        }
        return _errorRoute(route: routeName, argsType: 'SafeNotes');

      case '/addnote':
        if (args is StreamController<SessionState>) {
          return PageTransition(
            child: AddEditNotePage(sessionStateStream: args),
            duration: const Duration(milliseconds: transitionDuration),
            type: transitionType,
          );
        }
        return _errorRoute(
            route: routeName, argsType: 'StreamController<SessionState>');

      case '/editnote':
        if (args is AddEditNoteArguments) {
          return PageTransition(
            child: AddEditNotePage(
              sessionStateStream: args.sessionStream,
              note: args.note,
            ),
            duration: const Duration(milliseconds: transitionDuration),
            type: transitionType,
          );
        }
        return _errorRoute(route: routeName, argsType: 'SafeNotes');

      case '/backup':
        return PageTransition(
          child: const BackupSetting(),
          duration: const Duration(milliseconds: transitionDuration),
          type: transitionType,
        );

      case '/changepassphrase':
        return PageTransition(
          child: const ChangePassphrase(),
          duration: const Duration(milliseconds: transitionDuration),
          type: transitionType,
        );

      case '/settings':
        if (args is StreamController<SessionState>) {
          return PageTransition(
            child: SettingsScreen(sessionStateStream: args),
            duration: const Duration(milliseconds: transitionDuration),
            type: transitionType,
          );
        }
        return _errorRoute(
            route: routeName, argsType: 'StreamController<SessionState>');

      case '/chooseColorSettings':
        return PageTransition(
          child: const ColorPallet(),
          duration: const Duration(milliseconds: transitionDuration),
          type: transitionType,
        );

      case '/inactivityTimerSettings':
        return PageTransition(
          child: const InactivityTimerSetting(),
          duration: const Duration(milliseconds: transitionDuration),
          type: transitionType,
        );

      case '/chooseLanguageSettings':
        return PageTransition(
          child: const LanguageSetting(),
          duration: const Duration(milliseconds: transitionDuration),
          type: transitionType,
        );

      case '/secureDisplaySetting':
        return PageTransition(
          child: const SecureDisplaySetting(),
          duration: const Duration(milliseconds: transitionDuration),
          type: transitionType,
        );

      case '/biometricSetting':
        return PageTransition(
          child: const BiometricSetting(),
          duration: const Duration(milliseconds: transitionDuration),
          type: transitionType,
        );

      case '/autoRotateSettings':
        return PageTransition(
          child: const AutoRotationSetting(),
          duration: const Duration(milliseconds: transitionDuration),
          type: transitionType,
        );

      default:
        return _errorRoute(route: routeName);
    }
  }

  static Route<dynamic> _errorRoute(
      {required String? route, String? argsType}) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: Text('Route Error'.tr())),
        body: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Center(
            child: argsType == null
                ? Text('No route: {route}'
                    .tr(namedArgs: {'route': route.toString()}))
                : Text(
                    '{argsType}, Needed for route: {route}'.tr(namedArgs: {
                      'argsType': argsType,
                      'route': route.toString()
                    }),
                  ),
          ),
        ),
      );
    });
  }
}

class AddEditNoteArguments {
  final StreamController<SessionState> sessionStream;
  final SafeNote? note;

  AddEditNoteArguments({
    required this.sessionStream,
    this.note,
  });
}

class NoteDetailPageArguments {
  final StreamController<SessionState> sessionStream;
  final SafeNote note;

  NoteDetailPageArguments({
    required this.sessionStream,
    required this.note,
  });
}
