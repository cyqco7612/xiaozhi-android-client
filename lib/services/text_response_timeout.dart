import 'dart:async';

// Cold server initialization, intent detection and TTS can exceed 15 seconds.
const textResponseTimeout = Duration(seconds: 90);

Future<String> waitForTextResponse(Future<String> response) {
  return response.timeout(
    textResponseTimeout,
    onTimeout: () => Future<String>.error('请求超时'),
  );
}
