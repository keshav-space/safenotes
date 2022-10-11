// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:local_session_timeout/local_session_timeout.dart';

// Project imports:
import 'package:safenotes/authwall.dart';
import 'package:safenotes/main.dart';
import 'package:safenotes/models/safenote.dart';
import 'package:safenotes/models/session.dart';
import 'package:safenotes/views/add_edit_note.dart';
import 'package:safenotes/views/auth_views/login.dart';
import 'package:safenotes/views/auth_views/set_passphrase.dart';
import 'package:safenotes/views/home.dart';
import 'package:safenotes/views/note_view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    var args = settings.arguments;
    final String? routeName = settings.name;

    switch (routeName) {
      case '/':
        return MaterialPageRoute(builder: (_) => SafeNotesApp());

      case '/login':
        if (args is SessionArguments) {
          return MaterialPageRoute(
            builder: (_) => EncryptionPhraseLoginPage(
              sessionStream: args.sessionStream,
              isKeyboardFocused: args.isKeyboardFocused,
            ),
          );
        }
        return _errorRoute(
            route: routeName, argsType: 'StreamController<SessionState>');

      case '/signup':
        if (args is SessionArguments) {
          return MaterialPageRoute(
            builder: (_) => SetEncryptionPhrasePage(
              sessionStream: args.sessionStream,
              isKeyboardFocused: args.isKeyboardFocused,
            ),
          );
        }
        return _errorRoute(
            route: routeName, argsType: 'StreamController<SessionState>');

      case '/authwall':
        if (args is SessionArguments) {
          return MaterialPageRoute(
            builder: (_) => AuthWall(
              sessionStateStream: args.sessionStream,
              isKeyboardFocused: args.isKeyboardFocused,
            ),
          );
        }
        return _errorRoute(
            route: routeName, argsType: 'StreamController<SessionState>');

      case '/home':
        if (args is StreamController<SessionState>) {
          return MaterialPageRoute(
            builder: (_) => HomePage(
              sessionStateStream: args,
            ),
          );
        }
        return _errorRoute(
            route: routeName, argsType: 'StreamController<SessionState>');

      case '/viewnote':
        if (args is SafeNote) {
          SafeNote note = args;
          return MaterialPageRoute(
              builder: (_) => NoteDetailPage(noteId: note.id!));
        }
        return _errorRoute(route: routeName, argsType: 'SafeNotes');

      case '/addnote':
        return MaterialPageRoute(builder: (_) => AddEditNotePage());

      case '/editnote':
        if (args is SafeNote) {
          SafeNote note = args;
          return MaterialPageRoute(builder: (_) => AddEditNotePage(note: note));
        }
        return _errorRoute(route: routeName, argsType: 'SafeNotes');

      default:
        return _errorRoute(route: routeName);
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
              ? Text('No route: ${route}')
              : Text('${argsType}, Needed for route: ${route}'),
        ),
      );
    });
  }
}
