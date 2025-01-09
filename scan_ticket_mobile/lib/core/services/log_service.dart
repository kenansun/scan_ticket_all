import 'package:logger/logger.dart';

class LogService {
  static final LogService _instance = LogService._internal();
  factory LogService() => _instance;
  LogService._internal();

  final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  static const String _tag = '[ScanTicket]';

  void debug(String message, {String? tag}) {
    _logger.d('${tag ?? _tag} $message');
  }

  void info(String message, {String? tag}) {
    _logger.i('${tag ?? _tag} $message');
  }

  void warning(String message, {String? tag}) {
    _logger.w('${tag ?? _tag} $message');
  }

  void error(String message, {dynamic error, StackTrace? stackTrace, String? tag}) {
    _logger.e('${tag ?? _tag} $message', error: error, stackTrace: stackTrace);
  }

  void verbose(String message, {String? tag}) {
    _logger.v('${tag ?? _tag} $message');
  }

  void wtf(String message, {String? tag}) {
    _logger.wtf('${tag ?? _tag} $message');
  }
}
