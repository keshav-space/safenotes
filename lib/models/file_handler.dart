// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';

// Project imports:
import 'package:safenotes/data/database_handler.dart';
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/dialogs/imported_file_passphrase.dart';
import 'package:safenotes/models/import_file_parser.dart';
import 'package:safenotes/models/safenote.dart';

class FileHandler {
  Future<String?> fileSave() async {
    String? snackBackMsg;
    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory != null) {
        final String fileName = SafeNotesConfig.getExportFileName();
        final String passHash =
            PreferencesStorage.getPassPhraseHash().toString();
        String record = await NotesDatabase.instance.exportAllEncrypted();
        String? selectedFolderName = selectedDirectory.split('/').last;
        int totalCountOfNotes = '{'.allMatches(record).length;
        String jsonOutputContent =
            '{ "records" : ${record}, "recordHandlerHash" : "${passHash}", "total" : ${totalCountOfNotes.toString()} }';

        var jsonFile = new File('${selectedDirectory}/${fileName}');
        jsonFile.writeAsStringSync(jsonOutputContent);
        snackBackMsg = 'File saved in "${selectedFolderName}" folder!';
      } else {
        snackBackMsg = 'Destination folder not chosen!';
      }
    } catch (e) {}
    return snackBackMsg;
  }

  Future<String?> selectFileAndDoImport(BuildContext context) async {
    String? dataFromFileAsString = await getFileAsString();
    String? currentPassHash = PreferencesStorage.getPassPhraseHash();

    if (dataFromFileAsString == null) {
      return "File not picked!";
    } else if (dataFromFileAsString == "unrecognized") {
      return "Unrecognized File!";
    }

    try {
      var jsonDecodedData = jsonDecode(dataFromFileAsString);
      String importFileKeyHash = jsonDecodedData['recordHandlerHash'] as String;

      if (importFileKeyHash == "null") {
        ImportEncryptionControl.setIsImportEncrypted(false);
        await inserNotes(ImportParser.fromJson(jsonDecodedData).getAllNotes());
      } else {
        ImportEncryptionControl.setIsImportEncrypted(true);
        if (importFileKeyHash != currentPassHash) {
          // Set import passphrashhash to be used for validating user input passphrase
          ImportPassPhraseHandler.setImportPassPhraseHash(importFileKeyHash);
          try {
            await getImportPassphraseDialog(context);
          } catch (e) {
            return "Failed to get Key for import Notes";
          }
        } else {
          ImportPassPhraseHandler.setImportPassPhrase(PhraseHandler.getPass());
        }

        String userInputPassHashForImportNotes = sha256
            .convert(utf8.encode(ImportPassPhraseHandler.getImportPassPhrase()))
            .toString();

        if (userInputPassHashForImportNotes == importFileKeyHash) {
          await inserNotes(
              ImportParser.fromJson(jsonDecodedData).getAllNotes());
          ImportPassPhraseHandler.setImportPassPhrase("null");
          ImportPassPhraseHandler.setImportPassPhraseHash(null);
        } else {
          ImportPassPhraseHandler.setImportPassPhrase("null");
          ImportPassPhraseHandler.setImportPassPhraseHash(null);
          return "Wrong Passphrase!";
        }
      }
    } catch (e) {
      return "Failed to import file!";
    }
    return "Notes successfully imported!";
  }

  getImportPassphraseDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => ImportPassPhraseDialog(),
    );
  }

  Future<String?> getFileAsString() async {
    try {
      if (Platform.isAndroid) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: [SafeNotesConfig.getExportFileExtension()],
          allowMultiple: false,
        );
        if (result != null) {
          PlatformFile file = result.files.first;
          if (file.size == 0) return null;
          var jsonFile = new File(file.path!);
          String content = jsonFile.readAsStringSync();
          return content;
        }
      } else if (Platform.isIOS) {
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        if (result != null) {
          PlatformFile file = result.files.first;
          if (file.size == 0 ||
              file.extension != SafeNotesConfig.getExportFileExtension())
            return null;
          var jsonFile = new File(file.path!);
          String content = jsonFile.readAsStringSync();
          return content;
        }
      }
    } catch (e) {
      return "unrecognized";
    }
    return null;
  }

  inserNotes(List<SafeNote> imported) async {
    for (final note in imported) {
      await NotesDatabase.instance.encryptAndStore(note);
    }
  }
}
