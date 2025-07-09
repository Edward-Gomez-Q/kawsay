import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/common/auth_notifier.dart';
import 'package:project_3_kawsay/application/common/navigation_service.dart';

class ProfileDoctor extends ConsumerWidget {
  const ProfileDoctor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigation = ref.read(navigationServiceProvider);
    final authState = ref.watch(authProvider);
    final themeData = Theme.of(context);

    final person = authState.person!;
    final doctor = authState.doctor!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil del Doctor'),
        backgroundColor: themeData.colorScheme.primary,
        foregroundColor: themeData.colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => navigation.goToHomeDoctor(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Datos Personales', themeData),
            const SizedBox(height: 8),
            _buildInfoRow('Nombres', person.names),
            _buildInfoRow('Apellido Paterno', person.firstLastName),
            _buildInfoRow('Apellido Materno', person.secondLastName),
            _buildInfoRow('Cédula de Identidad', person.documentId),
            _buildInfoRow('Teléfono', person.personalPhoneNumber),
            _buildInfoRow('Género', person.gender),
            _buildInfoRow('Fecha de Nacimiento', _formatDate(person.birthDate)),
            const SizedBox(height: 16),

            _buildSectionTitle('Dirección', themeData),
            const SizedBox(height: 8),
            _buildInfoRow('País', person.country),
            _buildInfoRow('Ciudad', person.city),
            _buildInfoRow('Barrio', person.neighborhood),
            _buildInfoRow('Dirección', person.address),
            const SizedBox(height: 16),

            _buildSectionTitle('Información Profesional', themeData),
            const SizedBox(height: 8),
            _buildInfoRow('Especialidad', doctor.specialization),
            _buildInfoRow('Colegio Médico', doctor.medicalCollege),
            _buildInfoRow('Años de Experiencia', '${doctor.yearsExperience}'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(flex: 5, child: Text(value)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}
