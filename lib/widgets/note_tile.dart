// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:intl/intl.dart';

// Project imports:
import 'package:safenotes/models/safenote.dart';
import 'package:safenotes/utils/color.dart';

class NoteTileWidget extends StatelessWidget {
  final SafeNote note;
  final int index;

  const NoteTileWidget({
    Key? key,
    required this.note,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Pick colors from the accent colors based on index
    final color = NotesColor.getNoteColor(notIndex: index);
    final fontColor = getFontColorForBackground(color);
    final time = DateFormat.yMMMd().format(note.createdTime);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            note.title.length > 30
                ? (note.title.substring(0, 30).replaceAll("\n", " "))
                : note.title.replaceAll("\n", " "),
            style: TextStyle(
              color: fontColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox.square(dimension: 5),
          Text(
            time,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: fontColor,
            ),
          ),
          SizedBox.square(dimension: 5),
          Text(
            note.description.length > 90
                ? (note.description.substring(0, 90).replaceAll("\n", " "))
                : note.description.replaceAll("\n", " "),
            style: TextStyle(
              color: fontColor,
              fontSize: 16,
              //fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
