import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/common/navigation_service.dart';
import 'package:project_3_kawsay/application/common/sign_up_notifier.dart';
import 'package:project_3_kawsay/model/common/user_model.dart';
import 'package:project_3_kawsay/state/common/sign_up_user_credentials_state.dart';

class UserCredentialsStep extends ConsumerWidget {
  const UserCredentialsStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final credentialsState = ref.watch(userFormProvider);
    final signUpState = ref.read(signUpProvider.notifier);
    final signUpNotifier = ref.watch(signUpProvider);
    final navigation = ref.read(navigationServiceProvider);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: credentialsState.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: credentialsState.email,
                      decoration: const InputDecoration(
                        labelText: 'Correo Electrónico',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu correo electrónico';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Por favor ingresa un correo válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: credentialsState.password,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            credentialsState.obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            ref
                                .read(userFormProvider.notifier)
                                .state = credentialsState.copyWith(
                              obscurePassword:
                                  !credentialsState.obscurePassword,
                            );
                          },
                        ),
                      ),
                      obscureText: credentialsState.obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa una contraseña';
                        }
                        if (value.length < 8) {
                          return 'La contraseña debe tener al menos 8 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: credentialsState.confirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirmar Contraseña',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            credentialsState.obscureConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            ref
                                .read(userFormProvider.notifier)
                                .state = credentialsState.copyWith(
                              obscureConfirmPassword:
                                  !credentialsState.obscureConfirmPassword,
                            );
                          },
                        ),
                      ),
                      obscureText: credentialsState.obscureConfirmPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor confirma tu contraseña';
                        }
                        if (value != credentialsState.confirmPassword.text) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                if (credentialsState.password.text !=
                    credentialsState.confirmPassword.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Las contraseñas no coinciden'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                if (credentialsState.formKey.currentState!.validate()) {
                  final credentials = UserModel(
                    id: 0,
                    email: credentialsState.email.text,
                    password: credentialsState.password.text,
                    personId: 0,
                  );
                  signUpState.updateUserCredentials(credentials);
                  await signUpState.completeRegistration();
                  if (signUpNotifier.error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(signUpNotifier.error!),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cuenta creada exitosamente'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    navigation.goToLogin();
                  }
                }
              },
              child: signUpNotifier.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Crear Cuenta'),
            ),
          ],
        ),
      ),
    );
  }
}
