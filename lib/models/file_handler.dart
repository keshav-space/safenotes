// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:crypto/crypto.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';

// Project imports:
import 'package:safenotes/data/database_handler.dart';
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/dialogs/backup_passphrase.dart';
import 'package:safenotes/dialogs/confirm_import.dart';
import 'package:safenotes/models/import_file_parser.dart';
import 'package:safenotes/models/safenote.dart';

class FileHandler {
  Future<String?> fileSave() async {
    String? snackBackMsg;
    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory != null) {
        final String fileName = SafeNotesConfig.getExportFileName();
        String? selectedFolderName = selectedDirectory.split('/').last;
        var jsonFile = new File('${selectedDirectory}/${fileName}');
        String jsonOutputContent = await encryptedOutputBackupContent();

        jsonFile.writeAsStringSync(jsonOutputContent);
        snackBackMsg = 'fileSavedMessage'
            .tr(namedArgs: {'selectedFolderName': selectedFolderName});
      } else {
        snackBackMsg = 'Destination folder not chosen!'.tr();
      }
    } catch (e) {}
    return snackBackMsg;
  }

  static Future<String> encryptedOutputBackupContent() async {
    final String passHash = PreferencesStorage.getPassPhraseHash().toString();
    String record = await NotesDatabase.instance.exportAllEncrypted();
    int totalCountOfNotes = '{'.allMatches(record).length;

    String content =
        '{ "records" : ${record}, "recordHandlerHash" : "${passHash}", "total" : ${totalCountOfNotes.toString()} }';
    return content;
  }

  Future<String?> selectFileAndDoImport(BuildContext context) async {
    /*
    Attention: Starting v2.0 unencrypted export is removed, 
    however user are allowed to import their unencrypted backup until v3.0 
    */
    String? dataFromFileAsString = await getFileAsString();
    String? currentPassHash = PreferencesStorage.getPassPhraseHash();

    if (dataFromFileAsString == null) {
      return "File not picked!".tr();
    } else if (dataFromFileAsString == "unrecognized") {
      return "Unrecognized File!".tr();
    }

    try {
      var jsonDecodedData = jsonDecode(dataFromFileAsString);
      String importFileKeyHash = jsonDecodedData['recordHandlerHash'] as String;
      ImportParser? parsedImportData;

      if (importFileKeyHash == "null") {
        ImportEncryptionControl.setIsImportEncrypted(false);
      } else {
        ImportEncryptionControl.setIsImportEncrypted(true);
        if (importFileKeyHash != currentPassHash) {
          // Set import passphrasehash to be used for validating user input passphrase
          ImportPassPhraseHandler.setImportPassPhraseHash(importFileKeyHash);
          try {
            await getImportPassphraseDialog(context);
          } catch (e) {
            return "Failed to get key for import data".tr();
          }
        } else {
          ImportPassPhraseHandler.setImportPassPhrase(PhraseHandler.getPass());
        }

        String userInputPassHashForImportNotes = sha256
            .convert(utf8.encode(ImportPassPhraseHandler.getImportPassPhrase()))
            .toString();
        if (userInputPassHashForImportNotes != importFileKeyHash) {
          destroyImportCredentials();
          return "Wrong passphrase!".tr();
        }
      }

      parsedImportData = ImportParser.fromJson(jsonDecodedData);
      destroyImportCredentials();
      if (await confirmImportDialog(context, parsedImportData.totalNotes)) {
        await inserNotes(parsedImportData.getAllNotes());
      } else {
        return "Import cancelled!".tr();
      }
    } catch (e) {
      return "Failed to import file!".tr();
    }
    return "Notes successfully imported!".tr();
  }

  void destroyImportCredentials() {
    ImportPassPhraseHandler.setImportPassPhrase("null");
    ImportPassPhraseHandler.setImportPassPhraseHash(null);
  }

  getImportPassphraseDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => ImportPassPhraseDialog(),
    );
  }

  Future<bool> confirmImportDialog(BuildContext context, int totalNotes) async {
    return await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => ImportConfirm(importCount: totalNotes),
        ) ??
        false;
  }

  Future<String?> getFileAsString() async {
    try {
      if (Platform.isAndroid) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: [
            SafeNotesConfig.getAllowedFileExtensionsForImport()
          ],
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
