// Dart imports:
import 'dart:io';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/models/file_handler.dart';

// Package imports:
// import 'package:logger/logger.dart';


class ScheduledTask {
  static backup() async {
    await PreferencesStorage.init();
    int maxattempt = PreferencesStorage.getMaxBackupRetryAttempts();
    for (var attempt = 1; attempt <= maxattempt; attempt++)
      if (await unitBackupAttempt() == true) break;
  }

  // return true on successful backup
  static Future<bool> unitBackupAttempt() async {
    try {
      String validChoosenDirectory =
          await PreferencesStorage.getBackupDestination();

      if (validChoosenDirectory.isNotEmpty) {
        String jsonOutputContent =
            await FileHandler.encryptedOutputBackupContent();
        final String fileName = SafeNotesConfig.getBackupFileName();
        var jsonFile = File('${validChoosenDirectory}/${fileName}');
        jsonFile.writeAsStringSync(jsonOutputContent, mode: FileMode.write);
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
