import 'package:safenotes/model/safe_note.dart';

class ImportParser {
  final List<SafeNote> parsedNotes;
  final String importHandlerPhrase;
  final int totalNotes;

  ImportParser({
    required this.parsedNotes,
    required this.importHandlerPhrase,
    required this.totalNotes,
  });

  factory ImportParser.fromJson(Map<String, dynamic> json) {
    Iterable list = json['records'];
    List<SafeNote> notes = list.map((i) => SafeNote.fromJson(i)).toList();

    return ImportParser(
        parsedNotes: notes,
        importHandlerPhrase: json['recordHandlerHash'] as String,
        totalNotes: json['total'] as int);
  }

  List<SafeNote> getAllNotes() {
    return parsedNotes;
  }
}
