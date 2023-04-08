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
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:local_session_timeout/local_session_timeout.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/dialogs/unsaved_note_alert.dart';
import 'package:safenotes/models/editor_state.dart';
import 'package:safenotes/models/safenote.dart';
import 'package:safenotes/widgets/note_widget.dart';

class AddEditNotePage extends StatefulWidget {
  final StreamController<SessionState> sessionStateStream;
  final SafeNote? note;

  const AddEditNotePage({Key? key, this.note, required this.sessionStateStream})
      : super(key: key);

  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();

  late String title;
  late String description;

  @override
  void initState() {
    super.initState();
    this.title = widget.note?.title ?? '';
    this.description = widget.note?.description ?? '';
    this.title = this.title == ' ' ? '' : this.title;
    this.description = this.description == ' ' ? '' : this.description;
    NoteEditorState.setSaveAttempted(false);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(actions: [buildButton()]),
          body: SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottom),
              child: _buildBody(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Form(
      key: _formKey,
      child: NoteFormWidget(
        title: title,
        description: description,
        sessionStateStream: widget.sessionStateStream,
        onChangedTitle: (title) => setState(() {
          this.title = title;
          NoteEditorState.setState(
            widget.note,
            this.title,
            this.description,
          );
        }),
        onChangedDescription: (description) => setState(() {
          this.description = description;
          NoteEditorState.setState(
            widget.note,
            this.title,
            this.description,
          );
        }),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    if (isNoteNewOrContentChanged()) return await _warnDiscardChangeDialog();
    return true;
  }

  Future<bool> _warnDiscardChangeDialog() async {
    return await showDialog(
          context: context,
          builder: (context) {
            return UnsavedAlert();
          },
        ) ??
        false; // return false if tapped anywhere else on screen.
  }

  Widget buildButton() {
    final isFormValid = title.isNotEmpty || description.isNotEmpty;
    final double buttonFontSize = 17.0;
    final String buttonText = 'Save'.tr();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isFormValid
              ? (PreferencesStorage.isThemeDark
                  ? null
                  : NordColors.polarNight.darkest)
              : Colors.grey.shade700,
        ),
        onPressed: onSaveCallback,
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: buttonFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> onSaveCallback() async {
    await NoteEditorState()
        .addOrUpdateNote(); // this will also set NoteEditorState.setSaveAttempted = true
    Navigator.of(context).pop();
  }

  bool isNoteNewOrContentChanged() {
    if (widget.note == null) {
      //New Note and content is not empty
      if (this.title.isNotEmpty || this.description.isNotEmpty) return true;
    } else {
      // Old Note but content is changed
      if (widget.note?.title != this.title && this.title != '' ||
          widget.note?.description != this.description &&
              this.description != '') return true;
    }
    return false;
  }
}
