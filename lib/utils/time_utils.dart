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

// Package imports:
import 'package:timeago/timeago.dart' as timeago;

// Project imports:
import 'package:safenotes/data/preference_and_config.dart';

String humanTime({
  required DateTime time,
  required String localeString,
}) {
  // set local for all supported language
  SafeNotesConfig.setTimeagoLocale();

  if (localeString == 'en_US') return timeago.format(time, locale: 'en');
  if (localeString == 'fr') return timeago.format(time, locale: 'fr_short');
  return timeago.format(time, locale: localeString);
}
