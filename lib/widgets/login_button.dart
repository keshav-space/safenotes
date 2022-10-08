// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_nord_theme/flutter_nord_theme.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double topSpacing = 10.0;

    return Padding(
      padding: EdgeInsets.only(top: topSpacing),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shadowColor: PreferencesStorage.getIsThemeDark()
              ? NordColors.snowStorm.lightest
              : NordColors.polarNight.darkest,
          minimumSize: Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5.0, //StadiumBorder(),
        ),
        child: FittedBox(
          child: Text(
            text,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        onPressed: onClicked,
      ),
    );
  }
}
