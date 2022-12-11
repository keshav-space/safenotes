// Dart imports:
import 'dart:ui' as ui;

// Package imports:
import 'package:intl/intl.dart' as intl;

bool isRTL(String text) => intl.Bidi.detectRtlDirectionality(text);

getTextDirecton(String text) =>
    isRTL(text) ? ui.TextDirection.rtl : ui.TextDirection.ltr;
