import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:project_3_kawsay/application/common/sign_up_notifier.dart';
import 'package:project_3_kawsay/state/common/user_sign_up_data_state.dart';

class UserTypeSelectionStep extends ConsumerWidget {
  const UserTypeSelectionStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpNotifier = ref.read(signUpProvider.notifier);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '¿Qué tipo de usuario eres?',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          _buildUserTypeCard(
            context,
            title: 'Paciente',
            subtitle: 'Busco atención médica',
            icon: Icons.person,
            onTap: () {
              signUpNotifier.setUserType(UserType.patient);
              signUpNotifier.nextStep();
            },
          ),

          const SizedBox(height: 20),

          _buildUserTypeCard(
            context,
            title: 'Doctor',
            subtitle: 'Soy un profesional de la salud',
            icon: Icons.medical_services,
            onTap: () {
              signUpNotifier.setUserType(UserType.doctor);
              signUpNotifier.nextStep();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserTypeCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Icon(icon, size: 48, color: Theme.of(context).iconTheme.color),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
