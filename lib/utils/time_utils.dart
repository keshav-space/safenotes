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
