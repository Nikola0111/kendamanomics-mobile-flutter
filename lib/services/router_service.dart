import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:kiwi/kiwi.dart';

class RouterService {
  late final GoRouter _goRouter;
  String? _rememberedRoute;
  GoRouter get router => _goRouter;

  final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');
  final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  // ignore: unnecessary_getters_setters
  String? get rememberedRoute => _rememberedRoute;

  set rememberedRoute(String? value) {
    _rememberedRoute = value;
  }

  RouterService() {
    _buildRouter();
  }

  void _buildRouter() {
    _goRouter = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/',
      redirect: (context, state) {
        return null;
      },
      routes: [],
    );
  }
}
