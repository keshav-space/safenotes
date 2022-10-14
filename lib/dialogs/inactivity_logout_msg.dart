// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_nord_theme/flutter_nord_theme.dart';

class InactivityLogoutInfo extends StatelessWidget {
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
      Icons.info_rounded,
      size: 60,
      color: NordColors.frost.darkest,
    );
  }

  Widget _body(BuildContext context) {
    final String cautionMessage =
        'You were logged out due to extended inactivity. \nThis is to protect your privacy.';

    return Padding(
      padding: EdgeInsets.only(top: 12, left: 5, right: 5),
      child: Text(
        cautionMessage,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    final double paddingAroundButtonRowLR = 15.0;
    final double paddingAroundButtonRowTop = 20.0;
    final double buttonTextFontSize = 16.0;
    final String okButtonText = 'OK';

    return Container(
      padding: EdgeInsets.fromLTRB(paddingAroundButtonRowLR,
          paddingAroundButtonRowTop, paddingAroundButtonRowLR, 0),
      child: ElevatedButton(
        child: _buttonText(okButtonText, buttonTextFontSize),
        onPressed: () => Navigator.of(context).pop(),
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

showInactivityDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return InactivityLogoutInfo();
    },
  );
}
