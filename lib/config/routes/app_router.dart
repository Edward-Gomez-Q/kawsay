import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project_3_kawsay/application/common/auth_notifier.dart';
import 'package:project_3_kawsay/application/core/router_notifier.dart';
import 'package:project_3_kawsay/config/routes/app_routes.dart';
import 'package:project_3_kawsay/presentation/common/error/error.dart';
import 'package:project_3_kawsay/presentation/common/login/login.dart';
import 'package:project_3_kawsay/presentation/common/splash/splash.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  final routerNotifier = ref.read(routerNotifierProvider.notifier);
  return GoRouter(
    navigatorKey: routerNotifier.navigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: routerNotifier,
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isLoading = authState.isLoading;

      if (isLoading) {
        return AppRoutes.splash;
      }

      // Rutas públicas
      final publicRoutes = [AppRoutes.login, AppRoutes.splash];

      final isPublicRoute = publicRoutes.contains(state.matchedLocation);

      if (!isAuthenticated && !isPublicRoute) {
        return AppRoutes.login;
      }

      if (isAuthenticated &&
          (state.matchedLocation == AppRoutes.login ||
              state.matchedLocation == AppRoutes.splash)) {
        return authState.isPatient
            ? AppRoutes.homePatient
            : AppRoutes.homeDoctor;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const Splash(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const Login(),
      ),

      /*// Rutas anidadas ejemplo
      ShellRoute(
        builder: (context, state, child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
            routes: [
              GoRoute(
                path: 'analytics',
                builder: (context, state) => const AnalyticsScreen(),
              ),
              GoRoute(
                path: 'reports',
                builder: (context, state) => const ReportsScreen(),
              ),
            ],
          ),
        ],
      ),*/
    ],
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
    debugLogDiagnostics: true,
  );
});
