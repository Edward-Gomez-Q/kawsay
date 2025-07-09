import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project_3_kawsay/application/common/auth_notifier.dart';
import 'package:project_3_kawsay/application/core/router_notifier.dart';
import 'package:project_3_kawsay/config/routes/app_routes.dart';
import 'package:project_3_kawsay/presentation/common/error/error.dart';
import 'package:project_3_kawsay/presentation/common/login/login.dart';
import 'package:project_3_kawsay/presentation/common/signup/sign_up.dart';
import 'package:project_3_kawsay/presentation/common/splash/splash.dart';
import 'package:project_3_kawsay/presentation/common/welcome/welcome.dart';
import 'package:project_3_kawsay/presentation/doctor/diagnostitcs_list/diagnostics_list.dart';
import 'package:project_3_kawsay/presentation/doctor/home/home_doctor.dart';
import 'package:project_3_kawsay/presentation/doctor/patient_list/patient_list.dart';
import 'package:project_3_kawsay/presentation/doctor/profile_doctor/profile_doctor.dart';
import 'package:project_3_kawsay/presentation/doctor/receive_code/receive_code.dart';
import 'package:project_3_kawsay/presentation/patient/home_patient.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  final routerNotifier = ref.read(routerNotifierProvider.notifier);
  return GoRouter(
    navigatorKey: routerNotifier.navigatorKey,
    initialLocation: AppRoutes.welcome,
    refreshListenable: routerNotifier,
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isLoading = authState.isLoading;

      if (isLoading) {
        return AppRoutes.splash;
      }

      final publicRoutes = [
        AppRoutes.login,
        AppRoutes.splash,
        AppRoutes.welcome,
        AppRoutes.signUp,
      ];

      final isPublicRoute = publicRoutes.contains(state.matchedLocation);

      if (!isAuthenticated && !isPublicRoute) {
        return AppRoutes.welcome;
      }

      if (isAuthenticated &&
          (state.matchedLocation == AppRoutes.login ||
              state.matchedLocation == AppRoutes.splash)) {
        return authState.role == 1
            ? AppRoutes.homeDoctor
            : AppRoutes.homePatient;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const Welcome(),
      ),
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const Splash(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const Login(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUp(),
      ),
      //Patient Routes
      GoRoute(
        path: AppRoutes.homePatient,
        builder: (context, state) => const HomePatient(),
      ),
      //Doctor Routes
      GoRoute(
        path: AppRoutes.homeDoctor,
        builder: (context, state) => const HomeDoctor(),
      ),
      GoRoute(
        path: AppRoutes.patientList,
        builder: (context, state) => const PatientList(),
      ),
      GoRoute(
        path: AppRoutes.patientDiagnostics,
        builder: (context, state) => const DiagnosticsList(),
      ),
      GoRoute(
        path: AppRoutes.receiveCode,
        builder: (context, state) => const ReceiveCode(),
      ),
      GoRoute(
        path: AppRoutes.profileDoctor,
        builder: (context, state) => const ProfileDoctor(),
      ),
    ],
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
    debugLogDiagnostics: true,
  );
});
