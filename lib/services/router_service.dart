import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:kendamanomics_mobile/pages/change_password_page.dart';
import 'package:kendamanomics_mobile/pages/forgot_password_page.dart';
import 'package:kendamanomics_mobile/pages/leaderboard.dart';
import 'package:kendamanomics_mobile/pages/login_page.dart';
import 'package:kendamanomics_mobile/pages/main_page_container.dart';
import 'package:kendamanomics_mobile/pages/profile.dart';
import 'package:kendamanomics_mobile/pages/register_shell.dart';
import 'package:kendamanomics_mobile/pages/tamas_page.dart';
import 'package:kendamanomics_mobile/pages/tricks_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RouterService {
  late final GoRouter _goRouter;
  GoRouter get router => _goRouter;

  final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');
  final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  void init({required String initialRoute}) {
    _goRouter = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/$initialRoute',
      redirect: (context, state) {
        final session = Supabase.instance.client.auth.currentSession;
        if (session != null && state.matchedLocation == '/${LoginPage.pageName}') {
          return '/${TamasPage.pageName}';
        }
        return null;
      },
      routes: <RouteBase>[
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: '/${LoginPage.pageName}',
          name: LoginPage.pageName,
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const LoginPage(),
          ),
        ),
        GoRoute(
          path: '/${ForgotPasswordPage.pageName}',
          name: ForgotPasswordPage.pageName,
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const ForgotPasswordPage(),
          ),
        ),
        GoRoute(
          path: '/${ChangePasswordPage.pageName}',
          name: ChangePasswordPage.pageName,
          pageBuilder: (context, state) {
            final email = state.extra as String;
            return NoTransitionPage<void>(
              key: state.pageKey,
              child: ChangePasswordPage(email: email),
            );
          },
        ),
        GoRoute(
          path: '/${RegisterShell.pageName}',
          name: RegisterShell.pageName,
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const RegisterShell(),
          ),
        ),
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return MainPageContainer(child: child);
          },
          routes: <RouteBase>[
            GoRoute(
              path: '/${Leaderboard.pageName}',
              name: Leaderboard.pageName,
              pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: const Leaderboard(),
              ),
            ),
            GoRoute(
              path: '/${TamasPage.pageName}',
              name: TamasPage.pageName,
              pageBuilder: (context, state) {
                return NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const TamasPage(),
                );
              },
              routes: <RouteBase>[
                GoRoute(
                  path: TricksPage.pageName,
                  name: TricksPage.pageName,
                  pageBuilder: (context, state) {
                    final tamaId = state.extra as String?;
                    return NoTransitionPage<void>(
                      key: state.pageKey,
                      child: TricksPage(tamaId: tamaId),
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              path: '/${Profile.pageName}',
              name: Profile.pageName,
              pageBuilder: (context, state) => NoTransitionPage<void>(
                key: state.pageKey,
                child: const Profile(),
              ),
            ),
          ],
        )
      ],
    );
  }
}
