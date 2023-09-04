import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:kendamanomics_mobile/pages/login_page.dart';
import 'package:kendamanomics_mobile/pages/register_page.dart';

class RouterService {
  late final GoRouter _goRouter;
  GoRouter get router => _goRouter;

  final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');
  final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  RouterService() {
    _init();
  }

  void _init() {
    _goRouter = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/${RegisterPage.pageName}',
      redirect: (context, state) {
        return null;
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/${LoginPage.pageName}',
          name: LoginPage.pageName,
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const LoginPage(),
          ),
        ),
        GoRoute(
          path: '/${RegisterPage.pageName}',
          name: RegisterPage.pageName,
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const RegisterPage(),
          ),
        ),
        // ShellRoute(
        //   navigatorKey: _shellNavigatorKey,
        //   builder: (context, state, child) {
        //     return MainPageContainer(child: child);
        //   },
        //   routes: <RouteBase>[
        //     GoRoute(
        //       path: '/${RegisterPage.pageName}',
        //       name: RegisterPage.pageName,
        //       pageBuilder: (context, state) => NoTransitionPage<void>(
        //         key: state.pageKey,
        //         child: const RegisterPage(),
        //       ),
        //     ),
        //   ],
        // )
      ],
    );
  }
}
