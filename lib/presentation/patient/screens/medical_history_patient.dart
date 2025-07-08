import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/patient/patient_screens_notifier.dart';

class MedicalHistoryPatient extends ConsumerWidget {
  const MedicalHistoryPatient({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selecciona una categoría para ver los detalles',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),

          // Lista de categorías del historial médico
          _buildMedicalHistoryCategories(context, ref),
        ],
      ),
    );
  }

  Widget _buildMedicalHistoryCategories(BuildContext context, WidgetRef ref) {
    final categories = [
      {
        'title': 'Información Crítica',
        'subtitle': 'Tipo de sangre, embarazo, implantes',
        'icon': Icons.warning_amber_rounded,
        'color': Colors.red,
        'goTo': 11,
      },
      {
        'title': 'Alergias Médicas',
        'subtitle': 'Alergenos, reacciones y severidad',
        'icon': Icons.healing_rounded,
        'color': Colors.orange,
        'goTo': 12,
      },
      {
        'title': 'Condiciones Crónicas',
        'subtitle': 'Enfermedades crónicas y control',
        'icon': Icons.medical_services_rounded,
        'color': Colors.blue,
        'goTo': 13,
      },
      {
        'title': 'Historial Quirúrgico',
        'subtitle': 'Cirugías y complicaciones',
        'icon': Icons.local_hospital_rounded,
        'color': Colors.green,
        'goTo': 14,
      },
      {
        'title': 'Hospitalizaciones',
        'subtitle': 'Ingresos hospitalarios',
        'icon': Icons.local_hotel_rounded,
        'color': Colors.purple,
        'goTo': 15,
      },
      {
        'title': 'Vacunas',
        'subtitle': 'Historial de vacunación',
        'icon': Icons.vaccines_rounded,
        'color': Colors.teal,
        'goTo': 16,
      },
      {
        'title': 'Antecedentes Familiares',
        'subtitle': 'Historial médico familiar',
        'icon': Icons.family_restroom_rounded,
        'color': Colors.indigo,
        'goTo': 17,
      },
      {
        'title': 'Estilo de Vida',
        'subtitle': 'Hábitos de salud y ejercicio',
        'icon': Icons.fitness_center_rounded,
        'color': Colors.amber,
        'goTo': 18,
      },
      {
        'title': 'Seguro Médico',
        'subtitle': 'Información de cobertura',
        'icon': Icons.shield_rounded,
        'color': Colors.cyan,
        'goTo': 19,
      },
      {
        'title': 'Contactos de Emergencia',
        'subtitle': 'Familiares y médicos de cabecera',
        'icon': Icons.emergency_rounded,
        'color': Colors.deepOrange,
        'goTo': 20,
      },
    ];

    return Column(
      children: categories
          .map(
            (category) => _buildCategoryCard(
              context,
              category['title'] as String,
              category['subtitle'] as String,
              category['icon'] as IconData,
              category['color'] as Color,
              onTap: () {
                ref
                    .read(patientScreensProvider.notifier)
                    .goToStep((category['goTo'] as int));
              },
            ),
          )
          .toList(),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color, {
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey[400],
          size: 18,
        ),
        onTap: onTap,
      ),
    );
  }
}
