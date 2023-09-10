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
  static String _supabaseApiUrl = '';
  static String _supabaseAnonKey = '';

  static String? _iFrameSource;

  static Environment get environment => _environment;
  static String get supabaseApiUrl => _supabaseApiUrl;
  static String get supabaseAnonKey => _supabaseAnonKey;

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
        if (part.startsWith('SUPABASE_API_URL=')) {
          _supabaseApiUrl = part.substring('SUPABASE_API_URL='.length);
          continue;
        }
        if (part.startsWith('SUPABASE_ANON_KEY=')) {
          _supabaseAnonKey = part.substring('SUPABASE_ANON_KEY='.length);
          continue;
        }
      }
    }
  }
}
