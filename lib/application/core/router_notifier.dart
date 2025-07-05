import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RouterNotifier extends ChangeNotifier {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void pushNamed(String name, {Map<String, String> pathParameters = const {}}) {
    GoRouter.of(
      navigatorKey.currentContext!,
    ).pushNamed(name, pathParameters: pathParameters);
  }

  void pushReplacementNamed(
    String name, {
    Map<String, String> pathParameters = const {},
  }) {
    GoRouter.of(
      navigatorKey.currentContext!,
    ).pushReplacementNamed(name, pathParameters: pathParameters);
  }

  void pop() {
    GoRouter.of(navigatorKey.currentContext!).pop();
  }

  bool canPop() {
    return GoRouter.of(navigatorKey.currentContext!).canPop();
  }

  void goNamed(String name, {Map<String, String> pathParameters = const {}}) {
    GoRouter.of(
      navigatorKey.currentContext!,
    ).goNamed(name, pathParameters: pathParameters);
  }
}

final routerNotifierProvider = ChangeNotifierProvider<RouterNotifier>(
  (ref) => RouterNotifier(),
);
