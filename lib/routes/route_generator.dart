// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:local_session_timeout/local_session_timeout.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/main.dart';
import 'package:safenotes/models/safenote.dart';
import 'package:safenotes/views/add_edit_note.dart';
import 'package:safenotes/views/home.dart';
import 'package:safenotes/views/login_views/login.dart';
import 'package:safenotes/views/login_views/set_passphrase.dart';
import 'package:safenotes/views/note_view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    final String? routName = settings.name;

    switch (routName) {
      case '/':
        return MaterialPageRoute(builder: (_) => SafeNotesApp());

      case '/login':
        if (args is StreamController<SessionState>) {
          return MaterialPageRoute(
            builder: (_) => EncryptionPhraseLoginPage(
              sessionStream: args,
            ),
          );
        }
        return _errorRoute(
            route: routName, argsType: 'StreamController<SessionState>');

      case '/signup':
        if (args is StreamController<SessionState>) {
          return MaterialPageRoute(
            builder: (_) => SetEncryptionPhrasePage(
              sessionStream: args,
            ),
          );
        }
        return _errorRoute(
            route: routName, argsType: 'StreamController<SessionState>');

      case '/authwall':
        if (args is StreamController<SessionState>) {
          if (PreferencesStorage.getPassPhraseHash() == null) {
            return MaterialPageRoute(
              builder: (_) => SetEncryptionPhrasePage(
                sessionStream: args,
              ),
            );
          } else {
            return MaterialPageRoute(
              builder: (_) => EncryptionPhraseLoginPage(
                sessionStream: args,
              ),
            );
          }
        }
        return _errorRoute(
            route: routName, argsType: 'StreamController<SessionState>');

      case '/home':
        if (args is StreamController<SessionState>) {
          return MaterialPageRoute(
            builder: (_) => HomePage(
              sessionStateStream: args,
            ),
          );
        }
        return _errorRoute(
            route: routName, argsType: 'StreamController<SessionState>');

      case '/viewnote':
        if (args is SafeNote) {
          SafeNote note = args;
          return MaterialPageRoute(
              builder: (_) => NoteDetailPage(noteId: note.id!));
        }
        return _errorRoute(route: routName, argsType: 'SafeNotes');

      case '/addnote':
        return MaterialPageRoute(builder: (_) => AddEditNotePage());

      case '/editnote':
        if (args is SafeNote) {
          SafeNote note = args;
          return MaterialPageRoute(builder: (_) => AddEditNotePage(note: note));
        }
        return _errorRoute(route: routName, argsType: 'SafeNotes');

      default:
        return _errorRoute(route: routName);
    }
  }

  static Route<dynamic> _errorRoute(
      {required String? route, String? argsType}) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Route Error'),
        ),
        body: Center(
          child: argsType == null
              ? Text('No route: ' + route!)
              : Text(argsType + ', Needed for route: ' + route!),
        ),
      );
    });
  }
}
