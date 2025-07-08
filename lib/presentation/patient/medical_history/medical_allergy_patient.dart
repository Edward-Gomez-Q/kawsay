import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/patient/medical_allergy_notifier.dart';
import 'package:project_3_kawsay/model/patient/medical_allergy.dart';
import 'package:project_3_kawsay/presentation/patient/medical_history/create_allergy_dialog.dart';
import 'package:project_3_kawsay/state/patient/medical_allergy_state.dart';

class MedicalAllergyPatient extends ConsumerStatefulWidget {
  final int patientId;

  const MedicalAllergyPatient({super.key, required this.patientId});

  @override
  ConsumerState<MedicalAllergyPatient> createState() =>
      _MedicalAllergyPatientState();
}

class _MedicalAllergyPatientState extends ConsumerState<MedicalAllergyPatient> {
  @override
  void initState() {
    super.initState();

    // Cargar alergias al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(medicalAllergyProvider.notifier).loadAllergies(widget.patientId);
    });
  }

  void _showCreateAllergyDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateAllergyDialog(patientId: widget.patientId),
    );
  }

  void _showDeleteConfirmation(MedicalAllergy allergy) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
          '¿Está seguro de que desea eliminar la alergia a "${allergy.allergen}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref
                  .read(medicalAllergyProvider.notifier)
                  .deleteAllergy(allergy.id!);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(medicalAllergyProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado con botón de agregar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Alergias Médicas',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showCreateAllergyDialog,
                icon: const Icon(Icons.add),
                label: const Text('Agregar'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Mostrar error si existe
          if (state.error != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                border: Border.all(color: Colors.red.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.error!,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () {
                      ref.read(medicalAllergyProvider.notifier).clearError();
                    },
                  ),
                ],
              ),
            ),

          // Contenido principal
          Expanded(child: _buildContent(state)),
        ],
      ),
    );
  }

  Widget _buildContent(MedicalAllergyState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.allergies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medical_services_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No hay alergias registradas',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'Toca el botón "Agregar" para registrar una nueva alergia',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: state.allergies.length,
      itemBuilder: (context, index) {
        final allergy = state.allergies[index];
        return _buildAllergyCard(allergy);
      },
    );
  }

  Widget _buildAllergyCard(MedicalAllergy allergy) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado de la tarjeta
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    allergy.allergen,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteConfirmation(allergy),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Información detallada
            _buildInfoRow(
              icon: Icons.source,
              label: 'Origen',
              value: allergy.allergenFrom,
              color: Colors.blue,
            ),

            if (allergy.reaction != null && allergy.reaction!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                icon: Icons.warning,
                label: 'Reacción',
                value: allergy.reaction!,
                color: Colors.orange,
              ),
            ],

            if (allergy.severity != null && allergy.severity!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                icon: Icons.priority_high,
                label: 'Severidad',
                value: allergy.severity!,
                color: _getSeverityColor(allergy.severity!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'leve':
        return Colors.green;
      case 'moderada':
        return Colors.orange;
      case 'severa':
      case 'grave':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
