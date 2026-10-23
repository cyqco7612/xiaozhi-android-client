import 'dart:async';

import 'package:ai_assistant/services/text_response_timeout.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('accepts the first reply after the old 15-second deadline', () {
    fakeAsync((clock) {
      final response = Completer<String>();
      String? result;
      Object? error;
      waitForTextResponse(response.future).then<void>(
        (value) {
          result = value;
        },
        onError: (Object value) {
          error = value;
        },
      );

      clock.elapse(const Duration(seconds: 30));
      expect(error, isNull);
      response.complete('连接正常');
      clock.flushMicrotasks();

      expect(result, '连接正常');
      expect(clock.nonPeriodicTimerCount, 0);
    });
  });

  test('reports a timeout only after 90 seconds without a reply', () {
    fakeAsync((clock) {
      final response = Completer<String>();
      Object? error;
      waitForTextResponse(response.future).catchError((Object value) {
        error = value;
        return '';
      });

      clock.elapse(const Duration(seconds: 89));
      expect(error, isNull);
      clock.elapse(const Duration(seconds: 1));
      expect(error, '请求超时');
      expect(clock.nonPeriodicTimerCount, 0);
    });
  });

  test('reports server errors immediately instead of waiting 90 seconds', () {
    fakeAsync((clock) {
      final response = Completer<String>();
      Object? error;
      waitForTextResponse(response.future).catchError((Object value) {
        error = value;
        return '';
      });

      response.completeError('服务不可用');
      clock.flushMicrotasks();
      expect(error, '服务不可用');
      expect(clock.nonPeriodicTimerCount, 0);
    });
  });

  test('does not complete twice when a reply arrives after a timeout', () {
    fakeAsync((clock) {
      final response = Completer<String>();
      var replies = 0;
      var errors = 0;
      waitForTextResponse(response.future).then(
        (_) => replies++,
        onError: (Object _) => errors++,
      );

      clock.elapse(const Duration(seconds: 90));
      response.complete('迟到的回答');
      clock.flushMicrotasks();
      expect(replies, 0);
      expect(errors, 1);
    });
  });
}
