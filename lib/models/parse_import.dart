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

// Project imports:
import 'package:safenotes/models/safenote.dart';

class ImportParser {
  final List<SafeNote> parsedNotes;
  final String importHandlerPhrase;
  final int totalNotes;
  final bool isNoteCountMissmatched;

  ImportParser({
    required this.parsedNotes,
    required this.importHandlerPhrase,
    required this.totalNotes,
    required this.isNoteCountMissmatched,
  });

  factory ImportParser.fromJson(Map<String, dynamic> json) {
    Iterable list = json['records'];
    List<SafeNote> notes = list.map((i) => SafeNote.fromJson(i)).toList();

    return ImportParser(
      parsedNotes: notes,
      importHandlerPhrase: json['recordHandlerHash'] as String,
      totalNotes: notes.length,
      isNoteCountMissmatched: json['total'] as int != notes.length,
    );
  }

  List<SafeNote> getAllNotes() {
    return this.parsedNotes;
  }

  int getTotalNotes() {
    return this.totalNotes;
  }
}
