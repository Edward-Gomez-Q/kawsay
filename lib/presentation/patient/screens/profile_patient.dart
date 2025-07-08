import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePatient extends ConsumerWidget {
  const ProfilePatient({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text(
          'Perfil del Paciente',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
