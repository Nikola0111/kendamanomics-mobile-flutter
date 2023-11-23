import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class LoggerService {
  Logger? _logger;
  late String _loggerPath;
  bool _init = false;

  LoggerService() {
    _initLogger();
  }

  Future<void> _checkLoggerSizeAndResetIfNeeded() async {
    File file = File(_loggerPath);
    if (file.existsSync()) {
      int length = await file.length();
      if (length > 10 * 1024 * 1024) {
        // if file > 10 MB
        debugPrint('clear log file');
        await clearLogs();
      }
    }
  }

  Future<void> _initLogger() async {
    if (_init) return;
    Directory directory = await getApplicationSupportDirectory();
    _loggerPath = '${directory.path}/logger.txt';
    await _checkLoggerSizeAndResetIfNeeded();
    _logger = Logger(
      filter: ProductionFilter(),
      printer: SimplePrinter(printTime: true),
      output: FileOutput(file: File(_loggerPath)),
    );
    _init = true;
  }

  void log(String text, Level level) async {
    if (_logger == null) {
      await _initLogger();
    }
    _logger!.log(level, '$text\n');
  }

  String readAllLogs() {
    return File(_loggerPath).readAsStringSync();
  }

  Future<void> clearLogs() async {
    File file = File(_loggerPath);
    if (file.existsSync()) {
      file.deleteSync();
    }
    await _initLogger();
  }

  String getLogFilePath() => _loggerPath;
}

LoggerService _loggerService = KiwiContainer().resolve<LoggerService>();

void log(String text, {Level level = Level.info}) {
  return _loggerService.log(text, level);
}

String readLogs() {
  return _loggerService.readAllLogs();
}

String getLogFilePath() {
  return _loggerService.getLogFilePath();
}

Future<void> clearLogs() async {
  await _loggerService.clearLogs();
}

class FileOutput extends LogOutput {
  final File file;
  final bool overrideExisting;
  final Encoding encoding;
  IOSink? _sink;

  FileOutput({
    required this.file,
    this.overrideExisting = false,
    this.encoding = utf8,
  });

  @override
  Future<void> init() async {
    _sink = file.openWrite(
      mode: overrideExisting ? FileMode.writeOnly : FileMode.writeOnlyAppend,
      encoding: encoding,
    );
  }

  @override
  void output(OutputEvent event) {
    _sink?.writeAll(event.lines, '\n');
  }

  @override
  Future<void> destroy() async {
    await _sink?.flush();
    await _sink?.close();
  }
}
