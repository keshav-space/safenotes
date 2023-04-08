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

// Flutter imports:
import 'package:flutter/material.dart';

showSnackBarMessage(BuildContext context, String? message) {
  if (message != null) {
    final double width = MediaQuery.of(context).size.width * 0.80;

    return ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          width: width,
          content: Text(
            message,
            textAlign: TextAlign.center,
          ),
          elevation: 6.0,
          duration: Duration(milliseconds: 2000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
