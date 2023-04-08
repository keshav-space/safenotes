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
import 'dart:math';

double estimateBruteforceStrength(String passphrase) {
  if (passphrase.isEmpty || passphrase.length < 8) return 0.0;
  // Check which types of characters are used and create an opinionated bonus.
  double charsetBonus;
  if (RegExp(r'^[a-z]*$').hasMatch(passphrase)) {
    charsetBonus = 1.0;
  } else if (RegExp(r'^[a-z0-9]*$').hasMatch(passphrase)) {
    charsetBonus = 1.2;
  } else if (RegExp(r'^[a-zA-Z]*$').hasMatch(passphrase)) {
    charsetBonus = 1.3;
  } else if (RegExp(r'^[a-z\-_!?]*$').hasMatch(passphrase)) {
    charsetBonus = 1.3;
  } else if (RegExp(r'^[a-zA-Z0-9]*$').hasMatch(passphrase)) {
    charsetBonus = 1.5;
  } else {
    charsetBonus = 1.8;
  }

  final logisticFunction = (double x) {
    return 1.0 / (1.0 + exp(-x));
  };
  final curve = (double x) {
    return logisticFunction((x / 3.0) - 4.0);
  };
  return curve(passphrase.length * charsetBonus);
}
