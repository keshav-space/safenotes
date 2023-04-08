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

String sanitize(String inputString) {
  final multipleSpaces = RegExp(' +'); // replace with ' '
  final emptylines = RegExp(r'(?:[\t ]*(?:\r?\n|\r))+'); // replace with '\n'

  return inputString
      .trim()
      .replaceAll(multipleSpaces, ' ')
      .replaceAll(emptylines, '\n');
}
