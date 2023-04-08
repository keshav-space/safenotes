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
import 'dart:io';

// Package imports:
import 'package:media_scanner/media_scanner.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/models/file_handler.dart';

// Package imports:
// import 'package:logger/logger.dart';

class ScheduledTask {
  static backup() async {
    await PreferencesStorage.init();
    int maxAttempt = PreferencesStorage.maxBackupRetryAttempts;
    for (var attempt = 1; attempt <= maxAttempt; attempt++)
      if (await unitBackupAttempt() == true) break;
  }

  // return true on successful backup
  static Future<bool> unitBackupAttempt() async {
    try {
      String validChoosenDirectory = SafeNotesConfig.backupDirectory;
      //await PreferencesStorage.getBackupDestination();

      if (validChoosenDirectory.isNotEmpty) {
        String jsonOutputContent =
            await FileHandler.encryptedOutputBackupContent();
        final String fileName = SafeNotesConfig.backupFileName;
        var jsonFile = File('${validChoosenDirectory}/${fileName}');
        jsonFile.writeAsStringSync(jsonOutputContent, mode: FileMode.write);
        MediaScanner.loadMedia(path: jsonFile.path);
        await PreferencesStorage.setLastBackupTime();
      }
      return true;
    } catch (err) {
      if (err is FileSystemException &&
          (err.osError?.errorCode == 17 || err.osError?.errorCode == 13)) {
        /*
        User has deleted the backup file and android privacy-friendly API won't allow 
        creating the file with same name unless MANAGE_EXTERNAL_STORAGE permission is used, 
        which isn't so privacy-friendly. Hence, use Redundancy Counter to change backup
        file name in such scenarios
        */
        await PreferencesStorage.incrementBackupRedundancyCounter();
      }
      // Logger().e(err.toString());
      // throw Exception(err);
      return false;
    }
  }
}
