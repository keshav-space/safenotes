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

// Dart imports:
import 'dart:async';
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';
import 'package:safenotes/utils/styles.dart';

StreamController<String> _controller = StreamController<String>.broadcast();
int _timeoutSeconds = PreferencesStorage.preInactivityLogoutCounter;
int _counter = 0;
Timer? _timer;

class PreInactivityLogOff extends StatelessWidget {
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
          padding: EdgeInsets.all(paddingAllAround),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _title(),
              _body(paddingAllAround),
              _buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title() {
    final String title = 'Logging Off'.tr();
    final double topSpacing = 10.0;

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(top: topSpacing), //, right: 100),
        child: Text(
          title,
          style: dialogHeadTextStyle,
        ),
      ),
    );
  }

  Widget _body(double padding) {
    final initialCounterValue = _timeoutSeconds.toString().padLeft(2, '0');
    final double topSpacing = 15.0;

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(top: topSpacing, bottom: padding),
        child: StreamBuilder(
          stream: _controller.stream,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            var countDownTime = snapshot.hasData
                ? '00:${snapshot.data}'
                : ' 00:${initialCounterValue}';

            return Text(
              'There was no user activity for quite a while. You will be logged off unless you cancel within {countDownTime} seconds.'
                  .tr(namedArgs: {'countDownTime': countDownTime}),
              style: dialogBodyTextStyle,
            );
          },
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    final double buttonTextFontSize = 15.0;
    final String yesButtonText = 'Logout'.tr();
    final String noButtonText = 'Cancel'.tr();

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(NordColors.aurora.red),
              ),
              child: _buttonText(yesButtonText, buttonTextFontSize),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.06),
          Expanded(
            child: ElevatedButton(
              child: _buttonText(noButtonText, buttonTextFontSize),
              onPressed: () => Navigator.of(context)
                  .pop(true), // return false to dialog caller
            ),
          )
        ],
      ),
    );
  }

  Widget _buttonText(String text, double fontSize) {
    return AutoSizeText(
      text,
      textAlign: TextAlign.center,
      minFontSize: 8,
      maxLines: 1,
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
