import 'package:timeago/timeago.dart' as timeago;

String humanTime({required DateTime time, required String localeString}) {
  // set local for all supported language
  timeago.setLocaleMessages('en', timeago.EnMessages());
  timeago.setLocaleMessages('zh_CN', timeago.ZhCnMessages());
  timeago.setLocaleMessages('fr_short', timeago.FrMessages());
  timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());

  if (localeString == 'en_US') return timeago.format(time, locale: 'en');
  if (localeString == 'fr') return timeago.format(time, locale: 'fr_short');
  return timeago.format(time, locale: localeString);
}
