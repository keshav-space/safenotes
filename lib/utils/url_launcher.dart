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
import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrlExternal(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}

Future<void> launchUrlInapp(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
    throw 'Could not launch $url';
  }
}
