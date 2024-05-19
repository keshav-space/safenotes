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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoSwitchListTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget title;
  final Widget? subtitle;
  final Widget? secondary;
  final bool isThreeLine;
  final bool dense;
  final EdgeInsetsGeometry contentPadding;
  final bool selected;

  const CupertinoSwitchListTile({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.secondary,
    this.isThreeLine = false,
    this.dense = false,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 15.0),
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: ListTile(
        onTap: () {
          onChanged(!value);
        },
        leading: secondary,
        title: title,
        subtitle: subtitle,
        trailing: CupertinoSwitch(
          value: value,
          onChanged: onChanged,
        ),
        isThreeLine: isThreeLine,
        dense: dense,
        contentPadding: contentPadding,
        selected: selected,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

class CupertinoCheckListTile extends StatelessWidget {
  final Widget title;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final EdgeInsetsGeometry contentPadding;

  const CupertinoCheckListTile({
    Key? key,
    required this.title,
    required this.value,
    this.onChanged,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 15.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isEnabled = onChanged != null;
    return CupertinoButton(
      padding: contentPadding,
      onPressed: () {
        if (onChanged != null) onChanged!(!value);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          title,
          CupertinoCheckboxIcon(
            value: value,
            isEnabled: isEnabled,
          ),
        ],
      ),
    );
  }
}

class CupertinoCheckboxIcon extends StatelessWidget {
  final bool value;
  final bool isEnabled;

  const CupertinoCheckboxIcon({
    Key? key,
    required this.value,
    required this.isEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fillColor =
        isEnabled ? CupertinoColors.activeBlue : CupertinoColors.inactiveGray;
    const double iconCircleSize = 30;
    const double iconCheckSize = 18;

    return value
        ? _buildCheckedIcon(
            fillColor,
            iconCircleSize,
            iconCheckSize,
          )
        : _buildUncheckedIcon(iconCircleSize);
  }

  Widget _buildCheckedIcon(
    Color fillColor,
    double iconCircleSize,
    double iconCheckSize,
  ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          CupertinoIcons.circle_filled,
          color: fillColor,
          size: iconCircleSize,
        ),
        Icon(
          CupertinoIcons.check_mark,
          color: CupertinoColors.white,
          size: iconCheckSize,
        ),
      ],
    );
  }

  Widget _buildUncheckedIcon(double iconCircleSize) {
    return Icon(
      CupertinoIcons.circle,
      color: CupertinoColors.inactiveGray,
      size: iconCircleSize,
    );
  }
}
