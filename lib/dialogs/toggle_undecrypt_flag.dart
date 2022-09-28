import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:safenotes/data/preference_and_config.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';

class ToggleUndecryptionFlag extends StatefulWidget {
  @override
  _ToggleUndecryptionFlagState createState() => _ToggleUndecryptionFlagState();
}

class _ToggleUndecryptionFlagState extends State<ToggleUndecryptionFlag> {
  List<bool> _isSelected = [
    AppSecurePreferencesStorage.getAllowUndecryptLoginFlag(),
    !AppSecurePreferencesStorage.getAllowUndecryptLoginFlag()
  ];

  @override
  Widget build(BuildContext context) {
    final double paddingAllAround = 20.0;
    final double dialogRadius = 10.0;

    return BackdropFilter(
      filter: ImageFilter.blur(),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(dialogRadius),
        ),
        child: Padding(
          padding:
              EdgeInsets.only(left: paddingAllAround, bottom: paddingAllAround),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _closeButton(context),
              _title(paddingAllAround),
              _description(paddingAllAround),
              _toggleButton(context, paddingAllAround),
            ],
          ),
        ),
      ),
    );
  }

  Widget _closeButton(BuildContext context) {
    final double iconPaddingTR = 6.0;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: EdgeInsets.only(top: iconPaddingTR, right: iconPaddingTR),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Icon(Icons.close),
        ),
      ),
    );
  }

  Widget _title(double paddingAllAround) {
    final String titleText = 'Wanna See Encrypted data?';
    final double titleFontSize = 23.0;

    return Padding(
      padding: EdgeInsets.only(right: paddingAllAround),
      child: Text(
        titleText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: titleFontSize,
        ),
      ),
    );
  }

  Widget _description(double paddingAllAround) {
    final String descriptionText =
        '''Keeping this ON will allow you to see your data in encrypted form without decrypting it. 
Once ON, You'll need to choose the second option on the login screen to see your data in encrypted form.''';
    final double descriptionFontSize = 16.0;
    final double seprationPadding = 12.0;

    return Padding(
      padding: EdgeInsets.only(top: seprationPadding, right: paddingAllAround),
      child: Text(
        descriptionText,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: descriptionFontSize),
      ),
    );
  }

  Widget _toggleButton(BuildContext context, double paddingAllAround) {
    final double buttonTopPadding = 25.0;
    final double buttonBottomPadding = 15.0;
    final double buttonTextPadding = 15.0;
    final double buttonTextFontSize = 18.0;
    final String onText = 'ON';
    final String offText = 'OFF';

    return Padding(
      padding: EdgeInsets.only(
        top: buttonTopPadding,
        bottom: buttonBottomPadding,
        right: paddingAllAround,
      ),
      child: ToggleButtons(
        isSelected: this._isSelected,
        selectedColor: Colors.white,
        //color: Colors.black,
        color: Colors.grey,
        fillColor: Colors.lightBlue.shade900,
        borderColor: AppSecurePreferencesStorage.getIsThemeDark()
            ? NordColors.snowStorm.darkest
            : Colors.grey.withOpacity(0.8),
        selectedBorderColor: AppSecurePreferencesStorage.getIsThemeDark()
            ? NordColors.snowStorm.darkest
            : Colors.grey.withOpacity(0.8),
        borderRadius: BorderRadius.circular(5),
        splashColor: Colors.grey.withOpacity(0.6),
        highlightColor: Colors.grey.withOpacity(0.6),

        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: buttonTextPadding),
            child: Text(onText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: buttonTextFontSize,
                )),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: buttonTextPadding),
            child: Text(offText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: buttonTextFontSize,
                )),
          ),
        ],
        onPressed: _onPressed,
      ),
    );
  }

  void _onPressed(int selectdIndex) {
    setState(() {
      if (selectdIndex == 0) {
        this._isSelected[0] = true;
        this._isSelected[1] = false;
      } else {
        this._isSelected[0] = false;
        this._isSelected[1] = true;
      }
      AppSecurePreferencesStorage.setAllowUndecryptLoginFlag(
          this._isSelected[0]);
    });
  }
}
