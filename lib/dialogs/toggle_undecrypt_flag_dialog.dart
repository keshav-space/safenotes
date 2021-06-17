import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:safe_notes/databaseAndStorage/prefrence_sotorage_and_state_controls.dart';

class ToggleUndecryptionFlag extends StatefulWidget {
  @override
  _ToggleUndecryptionFlagState createState() =>
      new _ToggleUndecryptionFlagState();
}

class _ToggleUndecryptionFlagState extends State<ToggleUndecryptionFlag> {
  List<bool> isSelected = [
    AppSecurePreferencesStorage.getAllowUndecryptLoginFlag(),
    !AppSecurePreferencesStorage.getAllowUndecryptLoginFlag()
  ];
  @override
  Widget build(BuildContext context) {
    return new BackdropFilter(
        filter: ImageFilter.blur(),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 12),
                Text(
                  'Wanna See Encrypted data?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                SizedBox(height: 12),
                Text(
                  'Keeping this ON will allow you to see your data in encrypted form without decrypting it. Once ON, You\'ll need to choose the second option on the login screen to see your data in encrypted form.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 15),
                toggleButton(context),
              ],
            ),
          ),
        ));
  }

  Widget toggleButton(BuildContext context) => ToggleButtons(
        isSelected: isSelected,
        selectedColor: Colors.white,
        color: Colors.black,
        fillColor: Colors.lightBlue.shade900,
        borderColor: Colors.grey.withOpacity(0.8),
        selectedBorderColor: Colors.grey.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        splashColor: Colors.grey.withOpacity(0.5),
        highlightColor: Colors.grey.withOpacity(0.5),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('ON', style: TextStyle(fontSize: 18)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('OFF', style: TextStyle(fontSize: 18)),
          ),
        ],
        onPressed: (int newIndex) {
          setState(() {
            if (newIndex == 0) {
              AppSecurePreferencesStorage.setAllowUndecryptLoginFlag(true);
              isSelected[0] = true;
              isSelected[1] = false;
            } else {
              AppSecurePreferencesStorage.setAllowUndecryptLoginFlag(false);
              isSelected[0] = false;
              isSelected[1] = true;
            }

            Navigator.of(context).pop(true);
          });
        },
      );
}
