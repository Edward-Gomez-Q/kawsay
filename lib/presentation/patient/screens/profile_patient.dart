import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_3_kawsay/application/common/auth_notifier.dart';
import 'package:project_3_kawsay/model/common/person_model.dart';

class ProfilePatient extends ConsumerWidget {
  const ProfilePatient({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final themeData = Theme.of(context);

    final person = authState.person;

    if (person == null) {
      return CircularProgressIndicator();
    }

    return RefreshIndicator(
      onRefresh: () async {},
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar y nombre destacado
            _buildProfileHeader(person, themeData),
            const SizedBox(height: 24),

            // Datos personales
            _buildSection(
              title: 'Datos Personales',
              icon: Icons.person,
              themeData: themeData,
              children: [
                _buildInfoCard('Nombres', person.names),
                _buildInfoCard('Apellido Paterno', person.firstLastName),
                _buildInfoCard('Apellido Materno', person.secondLastName),
                _buildInfoCard('Cédula de Identidad', person.documentId),
                _buildInfoCard('Teléfono', person.personalPhoneNumber),
                _buildInfoCard('Género', person.gender),
                _buildInfoCard(
                  'Fecha de Nacimiento',
                  _formatDate(person.birthDate),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Dirección
            _buildSection(
              title: 'Dirección',
              icon: Icons.location_on,
              themeData: themeData,
              children: [
                _buildInfoCard('País', person.country),
                _buildInfoCard('Ciudad', person.city),
                _buildInfoCard('Barrio', person.neighborhood),
                _buildInfoCard('Dirección', person.address),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(PersonModel person, ThemeData themeData) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              themeData.colorScheme.primary.withValues(alpha: 0.1),
              themeData.colorScheme.primary.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${person.names} ',
                    style: themeData.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: themeData.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${person.firstLastName} ${person.secondLastName}',
                    style: themeData.textTheme.bodyLarge?.copyWith(
                      color: themeData.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required ThemeData themeData,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title, icon, themeData),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String label, String? value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value ?? 'No especificado',
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'No especificado';
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
