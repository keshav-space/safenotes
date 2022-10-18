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
      await PreferencesStorage.init();
      String validChoosenDirectory =
          await PreferencesStorage.getBackupDestination();

      if (validChoosenDirectory.isNotEmpty) {
        String jsonOutputContent =
            await FileHandler.encryptedOutputBackupContent();
        final String fileName = '${SafeNotesConfig.getExportFileName()}.txt';
        var jsonFile = File('${validChoosenDirectory}/${fileName}');
        jsonFile.writeAsStringSync(jsonOutputContent);
        await PreferencesStorage.setLastBackupTime();
      }
    } catch (err) {
      Logger().e(err.toString());
      throw Exception(err);
    }
  }
}
