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

// Project imports:
import 'package:safenotes/data/database_handler.dart';
import 'package:safenotes/models/safenote.dart';

class NoteEditorState {
  static SafeNote? original;
  static String title = '';
  static String description = '';

  static bool wasNoteSaveAttempted = false;
  static setSaveAttempted(bool flag) => wasNoteSaveAttempted = flag;

// to be called everytime content of note in editor is changes
  static setState(SafeNote? note, String titleNew, String descriptionNew) {
    original = note;
    title = titleNew;
    description = descriptionNew;
    wasNoteSaveAttempted = false;
  }

  static destroyValue() {
    original = null;
    title = description = '';
    wasNoteSaveAttempted = false;
  }

// to be called during inactivity timeOut
  Future<void> handleUngracefulNoteExit() async {
    // if note content was changed and note editor was closed(due to inactivity)
    // without user opting for saving or discarding
    if (wasNoteSaveAttempted == false &&
        (title.isNotEmpty || description.isNotEmpty)) {
      await addOrUpdateNote();
    }
  }

  Future<void> addOrUpdateNote() async {
    // if atleast one of the field is non empty save note
    if (title.isNotEmpty || description.isNotEmpty) {
      // fill empty title or description with
      title = title.isEmpty ? ' ' : title;
      description = description.isEmpty ? ' ' : description;

      final isUpdating = original != null;
      if (isUpdating) {
        if (original!.title != title || original!.description != description)
          await updateNote();
      } else {
        await addNote();
      }
    }
    destroyValue();
  }

  Future addNote() async {
    final note = SafeNote(
      title: title,
      description: description,
      createdTime: DateTime.now(),
    );
    await NotesDatabase.instance.encryptAndStore(note);
  }

  Future updateNote() async {
    final note = original!.copy(
      title: title,
      description: description,
      createdTime: DateTime.now(),
    );
    await NotesDatabase.instance.encryptAndUpdate(note);
  }
}
