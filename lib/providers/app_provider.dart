import 'package:flutter/cupertino.dart';

class AppProvider extends ChangeNotifier {
  final bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  void init() {}
}
