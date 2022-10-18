// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:intl/intl.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/models/safenote.dart';
import 'package:safenotes/utils/color.dart';

class NoteCardWidget extends StatelessWidget {
  final SafeNote note;
  final int index;
  //final bool isColorful;

  NoteCardWidget({
    Key? key,
    required this.note,
    required this.index,
    //required this.isColorful,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Pick colors from the accent colors based on index
    final color = NotesColor.getNoteColor(notIndex: index);
    final fontColor = getFontColorForBackground(color);

    final time = DateFormat.yMMMd().format(note.createdTime);
    final minHeight = getMinHeight(index);

    return Card(
      shadowColor:
          PreferencesStorage.getIsThemeDark() ? Colors.white : Colors.black,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title.length > 30
                  ? (note.title
                      .substring(0, 30)
                      .replaceAll("\n", " ")) // + '...')
                  : note.title.replaceAll("\n", " "),
              style: TextStyle(
                color: fontColor,
                //color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: fontColor,
                //color: Colors.black,
              ),
            ),
            SizedBox(height: 6),
            Text(
              note.description.length > 60
                  ? ((minHeight == 150)
                      ? (note.description
                          .substring(0, 60)
                          .replaceAll("\n", " ")) // +'...')
                      : (note.description
                          .substring(0, 40)
                          .replaceAll("\n", " "))) // + '...'))
                  : note.description.replaceAll("\n", " "),
              style: TextStyle(
                color: fontColor,
                //color: Colors.black,
                fontSize: 16,
                //fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// To return different height for different widgets
  double getMinHeight(int index) {
    switch (index % 4) {
      case 0:
        return 100;
      case 1:
        return 150;
      case 2:
        return 150;
      case 3:
        return 100;
      default:
        return 100;
    }
  }
}
