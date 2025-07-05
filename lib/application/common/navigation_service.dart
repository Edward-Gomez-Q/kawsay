import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project_3_kawsay/application/core/router_notifier.dart';
import 'package:project_3_kawsay/config/routes/app_router.dart';
import 'package:project_3_kawsay/config/routes/app_routes.dart';

class NavigationService {
  final Ref ref;
  NavigationService(this.ref);

  GoRouter get router => ref.read(routerProvider);
  RouterNotifier get routerNotifier =>
      ref.read(routerNotifierProvider.notifier);

  void goToLogin() => router.go(AppRoutes.login);
}

final navigationServiceProvider = Provider<NavigationService>(
  (ref) => NavigationService(ref),
);
