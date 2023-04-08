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
import 'package:safenotes/models/parse_import.dart';
import 'package:safenotes/models/safenote.dart';
import 'package:safenotes/utils/cache_manager.dart';
import 'package:safenotes/utils/device_info.dart';

//import 'package:media_scanner/media_scanner.dart';

//import 'package:safenotes/utils/storage_permission.dart';

class FileHandler {
  // Future<String?> fileSave() async {
  //   String? snackBackMsg;
  //   try {
  //     String downloadDirectory = SafeNotesConfig.downloadDirectory;

  //     if (await handleStoragePermission() &&
  //         await Directory(downloadDirectory).existsSync()) {
  //       String exportFileFullPathName =
  //           downloadDirectory + SafeNotesConfig.exportFileName;

  //       var jsonFile = new File(exportFileFullPathName);
  //       String jsonOutputContent = await encryptedOutputBackupContent();

  //       jsonFile.writeAsStringSync(jsonOutputContent);
  //       MediaScanner.loadMedia(path: jsonFile.path);

  //       snackBackMsg = "File saved at '{exportFileFullPathName}'"
  //           .tr(namedArgs: {'exportFileFullPathName': exportFileFullPathName});
  //     } else {
  //       snackBackMsg = 'Destination folder not chosen!'.tr();
  //     }
  //   } catch (e) {}
  //   return snackBackMsg;
  // }

  static Future<String> encryptedOutputBackupContent() async {
    final String passHash = PreferencesStorage.passPhraseHash.toString();
    String record = await NotesDatabase.instance.exportAllEncrypted();
    int totalCountOfNotes = '{'.allMatches(record).length;

    String content =
        '{ "records" : ${record}, "recordHandlerHash" : "${passHash}", "total" : ${totalCountOfNotes.toString()} }';
    return content;
  }

  Future<String?> selectFileAndImport(BuildContext context) async {
    /*
    Attention: Starting v2.0 unencrypted export is removed, 
    however user are allowed to import their unencrypted backup until v3.0 
    */
    String? dataFromFileAsString = await getFileAsString();
    String? currentPassHash = PreferencesStorage.passPhraseHash;

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
          ImportPassPhraseHandler.setImportPassPhrase(PhraseHandler.getPass);
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
      barrierDismissible: false,
      builder: (_) => ImportPassPhraseDialog(),
    );
  }

  Future<bool> confirmImportDialog(BuildContext context, int totalNotes) async {
    return await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => ImportConfirm(importCount: totalNotes),
        ) ??
        false;
  }

  Future<String?> getFileAsString() async {
    try {
      if (Platform.isAndroid) {
        // emptpyCache to prevent filepicker from picking old cached version
        // starting Android 11 all files are provided through cache mechanism and not directly
        await CacheManager.emptyCache();
        FilePickerResult? result;

        if (await isAndroidSdkVersionAbove(29))
          result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: [SafeNotesConfig.importFileExtension],
            allowMultiple: false,
          );
        else
          result = await FilePicker.platform.pickFiles(
            type: FileType.any,
            allowMultiple: false,
          );
        if (result != null) {
          PlatformFile file = result.files.first;
          if (file.size == 0) return null;
          var jsonFile = new File(file.path!);
          //   MediaScanner.loadMedia(path: jsonFile.path);

          String content = jsonFile.readAsStringSync();
          return content;
        }
      } else if (Platform.isIOS) {
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        if (result != null) {
          PlatformFile file = result.files.first;
          if (file.size == 0 ||
              file.extension != SafeNotesConfig.exportFileExtension)
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
