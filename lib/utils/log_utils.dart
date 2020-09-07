import 'package:flutter/services.dart';
import 'package:quick_log/quick_log.dart';

class LogUtils {
  LogUtils._();

  static const isDebug = true;

  static const String TAG = 'locker';

  static const bool _isPrintLog = true;

  static const Logger _logger = Logger('locker');

  static void i(String tag, String msg) {
    if (isDebug) {
      _logger.info('$tag: $msg');
    }
  }

  static void d(String tag, String msg) {
    if (isDebug) {
      _logger.debug('$tag: $msg');
    }
  }

  static void w(String tag, String msg) {
    if (isDebug) {
      _logger.warning('$tag: $msg');
    }
  }

  static void e(String tag, String msg) {
    if (isDebug) {
      _logger.error('$tag: $msg');
    }
  }
}
