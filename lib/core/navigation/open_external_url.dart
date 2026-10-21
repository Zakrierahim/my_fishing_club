import 'package:url_launcher/url_launcher.dart';

/// Opens an https link, such as a Google Maps search, outside the app.
Future<bool> openExternalUrl(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null || uri.scheme != 'https') {
    return false;
  }
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}
