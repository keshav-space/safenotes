// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';

// Project imports:
import 'package:safenotes/models/safenote.dart';
import 'package:safenotes/utils/notes_color.dart';
import 'package:safenotes/utils/string_utils.dart';
import 'package:safenotes/utils/text_direction_util.dart';

class NoteTileWidgetCompact extends StatelessWidget {
  final SafeNote note;
  final int index;

  const NoteTileWidgetCompact({
    Key? key,
    required this.note,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Pick colors from the accent colors based on index
    final color = NotesColor.getNoteColor(notIndex: index);
    final fontColor = getFontColorForBackground(color);
    final previewText = note.title == ' ' ? note.description : note.title;

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color,
      ),
      child: AutoSizeText(
        sanitize(previewText),
        textDirection: getTextDirecton(previewText),
        style: TextStyle(
          color: fontColor,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        minFontSize: 15,
        maxLines: 2,
        overflow: TextOverflow.clip,
      ),
    );
  }
}
