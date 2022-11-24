// Dart imports:
import 'dart:async';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';

StreamController<String> _controller = StreamController<String>.broadcast();
int _timeoutSeconds = PreferencesStorage.preInactivityLogoutCounter;
int _counter = 0;
Timer? _timer;

class PreInactivityLogOff extends StatelessWidget {
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
    final String title = 'Logging Off'.tr();
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
    final initialCounterValue = _timeoutSeconds.toString().padLeft(2, '0');
    final double topSpacing = 15.0;
    final double bodyFontSize = 15.0;

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
            top: topSpacing, left: padding + 5, bottom: padding),
        child: StreamBuilder(
          stream: _controller.stream,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            var countDownTime = snapshot.hasData
                ? '00:${snapshot.data}'
                : ' 00:${initialCounterValue}';

            return Text(
              'There was no user activity for quite a while. You will be logged off unless you cancel within {countDownTime} seconds.'
                  .tr(namedArgs: {'countDownTime': countDownTime}),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: bodyFontSize,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    final double paddingAroundLR = 15.0;
    final double paddingAroundTB = 10.0;
    final double buttonSeparation = 30.0;
    final double buttonTextFontSize = 16.0;
    final String yesButtonText = 'LogOut'.tr();
    final String noButtonText = 'Cancel'.tr();

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
            child: _buttonText(yesButtonText, buttonTextFontSize),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          Padding(
            padding: EdgeInsets.only(left: buttonSeparation),
            child: ElevatedButton(
              child: _buttonText(noButtonText, buttonTextFontSize),
              onPressed: () => Navigator.of(context)
                  .pop(true), // return false to dialog caller
            ),
          ),
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

void _startTimer(BuildContext context) {
  _counter = _timeoutSeconds;

  if (_timer != null) {
    _timer?.cancel();
  }

  _timer = Timer.periodic(
    Duration(seconds: 1),
    (timer) {
      (_counter > 0) ? _counter-- : _timer?.cancel();
      _controller.add(_counter.toString().padLeft(2, '0'));
      if (_counter == 0) {
        Navigator.of(context).pop();
      }
    },
  );
}

Future<bool?> preInactivityLogOffAlert(BuildContext context) async {
  bool? isUserActive = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      _startTimer(context); // start filling the stream with coutndown data
      return PreInactivityLogOff();
    },
  );

  if (_timer!.isActive) {
    // if timer is active i.e user user choose
    // some option which already pop out the dialoge
    // so disable timer to prevent re-trigger of pop
    _timer!.cancel();
  }
  return isUserActive;
}
