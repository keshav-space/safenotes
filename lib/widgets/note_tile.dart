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

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';

// Project imports:
import 'package:safenotes/models/safenote.dart';
import 'package:safenotes/utils/notes_color.dart';
import 'package:safenotes/utils/string_utils.dart';
import 'package:safenotes/utils/text_direction_util.dart';
import 'package:safenotes/utils/time_utils.dart';

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

    DateTime now = DateTime.now();
    DateTime todayDate = DateTime(now.year, now.month, now.day);
    DateTime noteDate = DateTime(
        note.createdTime.year, note.createdTime.month, note.createdTime.day);
    String time = (todayDate == noteDate)
        ? humanTime(
            time: note.createdTime,
            localeString: context.locale.toString(),
          )
        : DateFormat.yMMMd().format(note.createdTime);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        //crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoSizeText(
            sanitize(note.title),
            textDirection: getTextDirecton(note.title),
            style: TextStyle(
              color: fontColor,
              fontSize: 20,
              height: 1.2,
              fontWeight: FontWeight.bold,
              fontFamily: 'MerriweatherBlack',
            ),
            minFontSize: 20,
            maxLines: 1,
            overflow: TextOverflow.clip,
          ),
          SizedBox.square(dimension: 5),
          Text(
            time,
            textDirection: getTextDirecton(time),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: fontColor,
            ),
          ),
          SizedBox.square(dimension: 5),
          AutoSizeText(
            sanitize(note.description),
            textDirection: getTextDirecton(note.description),
            style: TextStyle(
              color: fontColor,
              fontSize: 16,
              height: 1.2,
            ),
            minFontSize: 16,
            maxLines: 2,
            overflow: TextOverflow.clip,
          ),
        ],
      ),
    );
  }
}
