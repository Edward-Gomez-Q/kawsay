import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/patient/patient_screens_notifier.dart';

class HomeScreenPatient extends ConsumerWidget {
  const HomeScreenPatient({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(patientScreensProvider.notifier);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildQuickActionsSection(context, notifier)],
      ),
    );
  }

  Widget _buildQuickActionsSection(
    BuildContext context,
    PatientScreensNotifier state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.speed, size: 20),
            const SizedBox(width: 8),
            Text(
              'Acciones rápidas',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(context, '📝', 'Historial\nmédico', () {
                state.goToStep(1);
              }),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                context,
                '📤',
                'Compartir\ncon médico',
                () {
                  state.goToStep(2);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                '👥',
                'Contactos de\nemergencia',
                () {
                  state.goToStep(20);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(context, '🌳', 'Estilo de\nvida', () {
                state.goToStep(18);
              }),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                '📜',
                'Historial de\ncódigos',
                () {
                  state.goToStep(21);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                context,
                '🩺',
                'Diagnósticos\nmédicos',
                () {
                  state.goToStep(22);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String emoji,
    String title,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
