import 'package:url_launcher/url_launcher.dart';

Future<void> makeCall(String mobile) async {
  final Uri uri = Uri(scheme: 'tel', path: mobile);
  await launchUrl(uri);
}

Future<void> sendSms(String mobile) async {
  final Uri uri = Uri(scheme: 'sms', path: mobile);
  await launchUrl(uri);
}
