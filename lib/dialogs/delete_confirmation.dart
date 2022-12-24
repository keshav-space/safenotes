// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';

// Project imports:
import 'package:safenotes/utils/styles.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback callback;
  DeleteConfirmationDialog({required this.callback});

  @override
  Widget build(BuildContext context) {
    final double dialogBordeRadious = 10.0;

    return BackdropFilter(
      filter: ImageFilter.blur(),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(dialogBordeRadious),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _cautionIcon(context),
              _title(context),
              _body(context),
              _buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cautionIcon(BuildContext context) {
    return Icon(
      Icons.warning_rounded,
      size: MediaQuery.of(context).size.width * 0.17,
      color: NordColors.aurora.yellow,
    );
  }

  Widget _title(BuildContext context) {
    final String title = 'Caution!'.tr();

    return Padding(
      padding: EdgeInsets.only(top: 12),
      child: Text(
        title,
        style: dialogHeadTextStyle,
      ),
    );
  }

  Widget _body(BuildContext context) {
    final String cautionMessage =
        "You're about to delete this note. This action cannot be undone.".tr();

    return Padding(
      padding: EdgeInsets.only(top: 12),
      child: Text(
        cautionMessage,
        textAlign: TextAlign.center,
        style: dialogBodyTextStyle,
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    final double paddingAroundButtonRowLR = 15.0;
    final double paddingAroundButtonRowTop = 20.0;
    final double buttonTextFontSize = 14.0;
    final String cancelButtonText = 'Cancel'.tr();
    final String deleteButtonText = 'Delete'.tr();

    return Container(
      padding: EdgeInsets.fromLTRB(paddingAroundButtonRowLR,
          paddingAroundButtonRowTop, paddingAroundButtonRowLR, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            child: _buttonText(cancelButtonText, buttonTextFontSize),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(NordColors.aurora.red),
            ),
            child: _buttonText(deleteButtonText, buttonTextFontSize),
            onPressed: this.callback,
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
