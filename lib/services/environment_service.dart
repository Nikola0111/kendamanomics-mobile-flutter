import 'package:flutter/services.dart';

enum Environment {
  dev('dev'),
  qa('qa'),
  test('test'),
  prod('prod');

  final String value;

  const Environment(this.value);

  factory Environment.from(String value) {
    if (value == dev.value) {
      return Environment.dev;
    } else if (value == qa.value) {
      return Environment.qa;
    } else if (value == prod.value) {
      return Environment.prod;
    } else if (value == test.value) {
      return Environment.test;
    }
    throw ('theme not found for string: $value');
  }
}

class EnvironmentService {
  static bool _init = false;
  static Environment _environment = Environment.dev;
  static String scheme = '';
  static String host = '';
  static int? port;

  static String? _iFrameSource;

  static Environment get environment => _environment;
  static String? get iFrameSource => _iFrameSource;

  static Future<void> init() async {
    if (!_init) {
      _init = true;
      String config = await rootBundle.loadString('assets/config/config.conf');
      List<String> split = config.split('\n').map((String s) => s.trim()).toList();

      for (String part in split) {
        if (part.startsWith('ENV=')) {
          final env = part.substring('ENV='.length).toLowerCase();
          _environment = Environment.from(env);
          continue;
        }
        if (part.startsWith('HOST=')) {
          host = part.substring('HOST='.length).toLowerCase();
          continue;
        }
        if (part.startsWith('SCHEME=')) {
          scheme = part.substring('SCHEME='.length).toLowerCase();
          continue;
        }
        if (part.startsWith('PORT=')) {
          port = int.tryParse(part.substring('PORT='.length).toLowerCase());
          continue;
        }
      }
    }
  }
}
