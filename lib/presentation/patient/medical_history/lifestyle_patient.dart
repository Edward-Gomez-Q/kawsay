import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LifestylePatient extends ConsumerWidget {
  const LifestylePatient({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text(
          'Estilo de Vida del Paciente',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
