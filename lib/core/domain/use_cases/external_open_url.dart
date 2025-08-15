import 'package:url_launcher/url_launcher.dart';

import '../../../common/common.dart';

class ExternalOpenUrl {
  final ILogger _logger;

  const ExternalOpenUrl(this._logger);

  Future<bool> call(String url) async {
    if (url.isEmpty) return false;

    final uri = Uri.tryParse(url);

    if (uri == null) {
      return false;
    }

    if (await launchUrl(uri)) {
      return true;
    }

    _logger.log(LogLevel.error, 'Could not launch $url');
    return false;
  }
}
