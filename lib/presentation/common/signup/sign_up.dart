import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/common/navigation_service.dart';
import 'package:project_3_kawsay/application/common/sign_up_notifier.dart';
import 'package:project_3_kawsay/state/common/user_sign_up_data_state.dart';
import 'package:project_3_kawsay/presentation/common/signup/steps/doctor_data_step.dart';
import 'package:project_3_kawsay/presentation/common/signup/steps/personal_data_step.dart';
import 'package:project_3_kawsay/presentation/common/signup/steps/user_credentials_step.dart';
import 'package:project_3_kawsay/presentation/common/signup/steps/user_type_selection_step.dart';
import 'package:project_3_kawsay/state/common/sign_up_state.dart';

class SignUp extends ConsumerWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpState = ref.watch(signUpProvider);
    final signUpNotifier = ref.read(signUpProvider.notifier);
    final navigation = ref.watch(navigationServiceProvider);
    return Scaffold(
      body: Container(
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
        child: SafeArea(
          child: Column(
            children: [
              // Header personalizado
              _buildCustomHeader(
                context,
                signUpState,
                signUpNotifier,
                navigation,
              ),

              // Indicador de progreso mejorado
              _buildProgressIndicator(context, signUpState),

              // Contenido del paso actual
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  child: Card(
                    elevation: 8,
                    shadowColor: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: _buildCurrentStep(signUpState),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomHeader(
    BuildContext context,
    SignUpState state,
    dynamic signUpNotifier,
    dynamic navigation,
  ) {
    return Container(
      padding: const EdgeInsets.all(3),
      child: Column(
        children: [
          // Logo y título
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'logo',
                child: Image.asset(
                  'assets/images/logo_light.png',
                  width: 30,
                  height: 30,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Kawsay',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Subtítulo y navegación
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Botón de regreso
              if (state.currentStep > 0)
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      signUpNotifier.previousStep();
                    },
                  ),
                )
              else
                // Botón para volver al welcome cuando está en el primer paso
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.home_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      navigation.goToWelcome();
                    },
                  ),
                ),

              // Título del paso
              Expanded(
                child: Text(
                  _getStepTitle(state),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Información del paso
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${state.currentStep + 1}/${_getMaxSteps(state)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context, SignUpState state) {
    final maxSteps = _getMaxSteps(state);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        children: [
          // Barra de progreso principal
          Row(
            children: List.generate(maxSteps, (index) {
              final isActive = index <= state.currentStep;
              final isCompleted = index < state.currentStep;
              final isCurrent = index == state.currentStep;

              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 6,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? Theme.of(context).colorScheme.primary
                        : isCurrent
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 6),

          // Etiquetas de los pasos
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(maxSteps, (index) {
              final isActive = index <= state.currentStep;

              return Expanded(
                child: Column(
                  children: [
                    // Etiqueta del paso
                    Text(
                      _getStepLabel(index, state),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isActive
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep(SignUpState state) {
    switch (state.currentStep) {
      case 0:
        return const UserTypeSelectionStep();
      case 1:
        return const PersonalDataStep();
      case 2:
        if (state.registrationData?.userType == UserType.doctor) {
          return const DoctorDataStep();
        } else {
          return const UserCredentialsStep();
        }
      case 3:
        return const UserCredentialsStep();
      default:
        return const UserTypeSelectionStep();
    }
  }

  // Métodos auxiliares
  String _getStepTitle(SignUpState state) {
    switch (state.currentStep) {
      case 0:
        return 'Tipo de Usuario';
      case 1:
        return 'Información Personal';
      case 2:
        if (state.registrationData?.userType == UserType.doctor) {
          return 'Datos Profesionales';
        } else {
          return 'Credenciales';
        }
      case 3:
        return 'Credenciales';
      default:
        return 'Registro';
    }
  }

  String _getStepLabel(int index, SignUpState state) {
    final isDoctor = state.registrationData?.userType == UserType.doctor;

    switch (index) {
      case 0:
        return 'Tipo';
      case 1:
        return 'Personal';
      case 2:
        return isDoctor ? 'Profesional' : 'Credenciales';
      case 3:
        return 'Credenciales';
      default:
        return 'Paso ${index + 1}';
    }
  }

  int _getMaxSteps(SignUpState state) {
    return state.registrationData?.userType == UserType.doctor ? 4 : 3;
  }
}
