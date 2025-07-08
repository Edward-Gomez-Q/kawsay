import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShareDataPatient extends ConsumerWidget {
  const ShareDataPatient({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text(
          'Funcionalidad de compartir datos del paciente aún no implementada.',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
