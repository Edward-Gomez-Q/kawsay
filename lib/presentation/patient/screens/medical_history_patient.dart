import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MedicalHistoryPatient extends ConsumerWidget {
  const MedicalHistoryPatient({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text(
          'Historial Médico del Paciente',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
