// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_nord_theme/flutter_nord_theme.dart';

// Project imports:
import 'package:safenotes/models/editor_state.dart';

class ImportConfirm extends StatefulWidget {
  final int importCount;

  ImportConfirm({
    Key? key,
    required this.importCount,
  }) : super(key: key);

  @override
  _ImportConfirmState createState() => _ImportConfirmState();
}

class _ImportConfirmState extends State<ImportConfirm> {
  @override
  Widget build(BuildContext context) {
    final double paddingAllAround = 10.0;
    final double dialogRadius = 10.0;

    return BackdropFilter(
      filter: ImageFilter.blur(),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(dialogRadius),
        ),
        child: Padding(
          padding: EdgeInsets.all(paddingAllAround),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _title(context, paddingAllAround),
              _body(context, paddingAllAround),
              _buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(BuildContext context, double padding) {
    final String title = 'Confirm Import!';
    final double titleFontSize = 22.0;
    final double topSpacing = 10.0;

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
            top: topSpacing, left: padding + 5), //, right: 100),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: titleFontSize,
          ),
        ),
      ),
    );
  }

  Widget _body(BuildContext context, double padding) {
    final String cautionMessage =
        'Do you want to import ${widget.importCount} new notes?';
    final double topSpacing = 15.0;
    final double bodyFontSize = 16.0;

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
            top: topSpacing, left: padding + 5, bottom: padding),
        child: Text(
          cautionMessage,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: bodyFontSize,
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    final double paddingAroundLR = 15.0;
    final double paddingAroundTB = 10.0;
    final double buttonSeparation = 25.0;
    final double buttonTextFontSize = 16.0;
    final String cancelButtonText = 'Cancel';
    final String confirmButtonText = 'Confirm';

    return Container(
      padding: EdgeInsets.fromLTRB(
          paddingAroundLR, paddingAroundTB, paddingAroundLR, paddingAroundTB),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(NordColors.aurora.red),
            ),
            child: _buttonText(cancelButtonText, buttonTextFontSize),
            onPressed: () {
              // User was warned about unsaved change, and user choose to
              // discard the changes hence the NoteEditorState().handleUngracefulExit() won't save the notes
              NoteEditorState.setSaveAttempted(true);
              Navigator.of(context).pop(false);
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: buttonSeparation),
            child: ElevatedButton(
              child: _buttonText(confirmButtonText, buttonTextFontSize),
              onPressed: () => Navigator.of(context)
                  .pop(true), // return false to dialog caller
            ),
          )
        ],
      ),
    );
  }

  Widget _buttonText(String text, double fontSize) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
    );
  }
}
