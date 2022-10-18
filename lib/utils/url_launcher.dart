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
