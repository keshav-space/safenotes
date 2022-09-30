// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/encryption/aes_encryption_handler.dart';

final String tableNotes = 'safe_notes';

class NoteFields {
  static final List<String> values = [id, title, description, time];

  static final String id = '_id';
  static final String title = 'title';
  static final String description = 'description';
  static final String time = 'time';
}

class SafeNote {
  final int? id;
  final String title;
  final String description;
  final DateTime createdTime;

  const SafeNote({
    this.id,
    required this.title,
    required this.description,
    required this.createdTime,
  });

  SafeNote copy({
    int? id,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      SafeNote(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
      );

  static SafeNote fromJsonAndDecrypt(Map<String, dynamic> json) => SafeNote(
        id: json[NoteFields.id] as int?,

        title: UnDecryptedLoginControl.getNoDecryptionFlag()
            ? json[NoteFields.title] as String
            : decryptAES(json[NoteFields.title] as String,
                PhraseHandler.getPass()), //json[NoteFields.title] as String,

        description: UnDecryptedLoginControl.getNoDecryptionFlag()
            ? json[NoteFields.description] as String
            : decryptAES(
                json[NoteFields.description] as String,
                PhraseHandler
                    .getPass()), //json[NoteFields.description] as String,

        createdTime: DateTime.parse(json[NoteFields.time] as String),
      );

  Map<String, dynamic> toJsonAndEncrypted() => {
        NoteFields.id: id,
        NoteFields.title: encryptAES(title, PhraseHandler.getPass()), //title,
        NoteFields.description:
            encryptAES(description, PhraseHandler.getPass()), //description,
        NoteFields.time: createdTime.toIso8601String(),
      };

  Map<String, dynamic> toJson() {
    final bool isExportEncrypted =
        ExportEncryptionControl.getIsExportEncrypted();
    return {
      //"${NoteFields.id}": this.id,
      NoteFields.title: isExportEncrypted
          ? '${encryptAES(this.title, PhraseHandler.getPass())}'
          : '${this.title}',
      NoteFields.description: isExportEncrypted
          ? '${encryptAES(this.description, PhraseHandler.getPass())}'
          : '${this.description}',
      NoteFields.time: '${this.createdTime.toIso8601String()}',
    };
  }

  static SafeNote fromJson(Map<String, dynamic> json) {
    final bool isImportEncrypted =
        ImportEncryptionControl.getIsImportEncrypted();
    return SafeNote(
      title: isImportEncrypted
          ? decryptAES(json[NoteFields.title] as String,
              ImportPassPhraseHandler.getImportPassPhrase())
          : json[NoteFields.title] as String,
      description: isImportEncrypted
          ? decryptAES(json[NoteFields.description] as String,
              ImportPassPhraseHandler.getImportPassPhrase())
          : json[NoteFields.description] as String,
      createdTime: DateTime.parse(json[NoteFields.time] as String),
    );
  }
}
