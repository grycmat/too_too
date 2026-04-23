import 'dart:async';
import 'package:app_links/app_links.dart';

class OAuthCallbackHandler {
  final AppLinks _appLinks = AppLinks();
  final _codeController = StreamController<String>.broadcast();

  Stream<String> get onAuthCode => _codeController.stream;

  StreamSubscription<Uri>? _linkSubscription;

  void startListening() {
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      if (uri.scheme == 'neon' && uri.host == 'oauth-callback') {
        final code = uri.queryParameters['code'];
        if (code != null && code.isNotEmpty) {
          _codeController.add(code);
        }
      }
    });
  }

  void stopListening() {
    _linkSubscription?.cancel();
    _linkSubscription = null;
  }

  void dispose() {
    stopListening();
    _codeController.close();
  }
}
