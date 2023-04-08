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
import 'dart:ui' as ui;

// Package imports:
import 'package:intl/intl.dart' as intl;

bool isRTL(String text) => intl.Bidi.detectRtlDirectionality(text);

getTextDirecton(String text) =>
    isRTL(text) ? ui.TextDirection.rtl : ui.TextDirection.ltr;
