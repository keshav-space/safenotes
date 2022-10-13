// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:intl/intl.dart';

// Project imports:
import '../models/safenote.dart';

final _lightColors = [
  NordColors.frost.darkest,
  NordColors.aurora.orange,
  NordColors.aurora.green,
  NordColors.aurora.purple,
  NordColors.frost.darker,
];

class NoteTileWidget extends StatelessWidget {
  const NoteTileWidget({
    Key? key,
    required this.note,
    required this.index,
  }) : super(key: key);

  final SafeNote note;
  final int index;

  @override
  Widget build(BuildContext context) {
    /// Pick colors from the accent colors based on index
    final color = _lightColors[index % _lightColors.length];
    final time = DateFormat.yMMMd().format(note.createdTime);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(5), color: color),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note.title.length > 30
                ? (note.title.substring(0, 30).replaceAll("\n", " ") + '...')
                : note.title.replaceAll("\n", " "),
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox.square(
            dimension: 5,
          ),
          Text(
            time,
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          SizedBox.square(
            dimension: 5,
          ),
          Text(
            note.description.length > 90
                ? (note.description.substring(0, 90).replaceAll("\n", " ") +
                    '...')
                : note.description.replaceAll("\n", " "),
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              //fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
