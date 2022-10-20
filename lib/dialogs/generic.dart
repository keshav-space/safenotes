// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_nord_theme/flutter_nord_theme.dart';

// Project imports:
import 'package:safenotes/utils/style.dart';

class GenericDialog extends StatelessWidget {
  final IconData icon;
  final String message;

  GenericDialog({Key? key, required this.icon, required this.message})
      : super(key: key);

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
              _buildIcon(context),
              _body(context),
              _buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Icon(
        this.icon,
        size: 50,
        color: NordColors.frost.darkest,
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Text(
        this.message,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
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
        color: Style.buttonTextStyle().color,
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
    );
  }
}

showGenericDialog(
    {required BuildContext context,
    required IconData icon,
    required String message}) async {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return GenericDialog(
        icon: icon,
        message: message,
      );
    },
  );
}
