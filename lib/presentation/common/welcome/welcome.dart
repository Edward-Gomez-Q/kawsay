import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/common/navigation_service.dart';
import 'package:project_3_kawsay/presentation/common/widgets/app_button.dart';
import 'package:project_3_kawsay/presentation/themes/button_styles.dart';

class Welcome extends ConsumerWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigation = ref.read(navigationServiceProvider);
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
              ],
            ),
          ),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo_light.png',
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Kawsay',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Tu salud, tu control.',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/welcome_logo.png',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 20),
                Text(
                  'Mantén tu historial médico seguro y bajo control.',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppButton(
                      text: "Crear Cuenta",
                      onPressed: () {
                        navigation.goToSignUp();
                      },
                      type: ButtonType.elevated,
                      size: ButtonSize.extraLarge,
                    ),
                    AppButton(
                      text: "Iniciar Sesión",
                      onPressed: () {
                        navigation.goToLogin();
                      },
                      type: ButtonType.outlined,
                      size: ButtonSize.extraLarge,
                      variant: ButtonVariant.secondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
