import 'package:flutter/material.dart';

showSnackBarMessage(BuildContext context, String? message) {
  if (message != null)
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
}
