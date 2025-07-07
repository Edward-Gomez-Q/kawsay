import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/common/auth_notifier.dart';
import 'package:project_3_kawsay/application/common/login_notifier.dart';
import 'package:project_3_kawsay/application/common/navigation_service.dart';
import 'package:project_3_kawsay/presentation/common/widgets/custom_form_fields.dart';
import 'package:project_3_kawsay/state/common/login_state.dart';

class Login extends ConsumerWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigation = ref.read(navigationServiceProvider);
    final loginState = ref.watch(loginProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Hero(
                            tag: 'logo',
                            child: Image.asset(
                              'assets/images/logo_light.png',
                              width: 45,
                              height: 45,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Kawsay',
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Bienvenido de vuelta',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                      ),

                      const SizedBox(height: 40),
                      Card(
                        elevation: 8,
                        shadowColor: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Form(
                            key: loginState.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Iniciar Sesión',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 32),

                                // Campo de email con animación
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  child: CustomFormFields.buildTextField(
                                    context: context,
                                    controller: loginState.emailController,
                                    label: 'Email',
                                    icon: Icons.email_outlined,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, ingresa tu email';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Campo de contraseña con mejor diseño
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  child: TextFormField(
                                    controller: loginState.passwordController,
                                    obscureText: loginState.obscurePassword,
                                    decoration: InputDecoration(
                                      labelText: 'Contraseña',
                                      prefixIcon: Icon(
                                        Icons.lock_outline,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.outline,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          width: 2,
                                        ),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          loginState.obscurePassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        onPressed: () {
                                          ref
                                              .read(loginStateProvider.notifier)
                                              .state = loginState.copyWith(
                                            obscurePassword:
                                                !loginState.obscurePassword,
                                          );
                                        },
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, ingresa tu contraseña';
                                      }
                                      return null;
                                    },
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Botón de login mejorado
                                SizedBox(
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: loginState.isLoading
                                        ? null
                                        : () async {
                                            await ref
                                                .watch(loginProvider.notifier)
                                                .login();
                                            final updatedLoginState = ref.read(
                                              loginProvider,
                                            );
                                            if (updatedLoginState.error ==
                                                null) {
                                              ref
                                                  .watch(authProvider.notifier)
                                                  .login(
                                                    updatedLoginState.userId!,
                                                    updatedLoginState.role!,
                                                    updatedLoginState.person,
                                                    updatedLoginState.doctor,
                                                  );

                                              print(
                                                'AuthProvider - UserId: ${ref.read(authProvider).userId}, Role: ${ref.read(authProvider).role}',
                                              );
                                              if (loginState.role == 1) {
                                                print(
                                                  'Navegando a Home Doctor',
                                                );
                                                navigation.goToHomeDoctor();
                                              } else {
                                                print(
                                                  'Navegando a Home Patient',
                                                );
                                                navigation.goToHomePatient();
                                              }
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      foregroundColor: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 2,
                                    ),
                                    child: loginState.isLoading
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(
                                                        Theme.of(
                                                          context,
                                                        ).colorScheme.onPrimary,
                                                      ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              const Text('Iniciando sesión...'),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.login),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Iniciar Sesión',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),

                                // Mensaje de error con mejor presentación
                                if (loginState.error != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.errorContainer,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.error,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              loginState.error!,
                                              style: TextStyle(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.error,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Botón de regreso mejorado
                      OutlinedButton.icon(
                        onPressed: () {
                          navigation.goToWelcome();
                        },
                        icon: Icon(Icons.arrow_back_outlined),
                        label: Text('Volver al inicio'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
