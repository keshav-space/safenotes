// Dart imports:
import 'dart:io';

// Package imports:
import 'package:logger/logger.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/models/file_handler.dart';

class ScheduledTask {
  static backup() async {
    try {
      //await Permission.manageExternalStorage.request();
      await PreferencesStorage.init();
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
    } catch (err) {
      if (err is FileSystemException && err.osError?.errorCode == 17) {
        /*
        User has deleted the backup file and android privacy-friendly API won't allow 
        creating the file with same name unless MANAGE_EXTERNAL_STORAGE permission is used, 
        which isn't so privacy-friendly. Hence, use Redundancy Counter to change backup
        file name in such scenarios
        */
        await PreferencesStorage.incrementBackupRedundancyCounter();
      }
      Logger().e(err.toString());
      throw Exception(err);
    }
  }
}
