import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/patient/hospitalization_notifier.dart';
import 'package:project_3_kawsay/model/patient/hospitalization.dart';
import 'package:project_3_kawsay/presentation/patient/medical_history/hospitalization_form_dialog.dart';

class HospitalizationPatient extends ConsumerWidget {
  final int patientId;

  const HospitalizationPatient({super.key, required this.patientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hospitalizationState = ref.watch(hospitalizationProvider(patientId));
    final hospitalizationNotifier = ref.read(
      hospitalizationProvider(patientId).notifier,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con título y botón de agregar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hospitalizaciones',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              ElevatedButton.icon(
                onPressed: () =>
                    _showCreateDialog(context, hospitalizationNotifier),
                icon: const Icon(Icons.add),
                label: const Text('Agregar'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Mostrar error si existe
          if (hospitalizationState.error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.error, color: Colors.red.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      hospitalizationState.error!,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),
                  IconButton(
                    onPressed: hospitalizationNotifier.clearError,
                    icon: const Icon(Icons.close),
                    color: Colors.red.shade700,
                  ),
                ],
              ),
            ),

          // Contenido principal
          Expanded(
            child: hospitalizationState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : hospitalizationState.hospitalizations.isEmpty
                ? _buildEmptyState()
                : _buildHospitalizationList(
                    hospitalizationState.hospitalizations,
                    hospitalizationNotifier,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_hospital, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No hay hospitalizaciones registradas',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Presiona "Agregar" para registrar una nueva hospitalización',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalizationList(
    List<Hospitalization> hospitalizations,
    HospitalizationNotifier notifier,
  ) {
    return ListView.builder(
      itemCount: hospitalizations.length,
      itemBuilder: (context, index) {
        final hospitalization = hospitalizations[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Icon(Icons.local_hospital, color: Colors.blue.shade700),
            ),
            title: Text(
              hospitalization.reason,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ingreso: ${_formatDate(hospitalization.admissionDate)}'),
                Text('Alta: ${_formatDate(hospitalization.dischargeDate)}'),
                Text(
                  'Duración: ${_calculateDuration(hospitalization.admissionDate, hospitalization.dischargeDate)}',
                ),
              ],
            ),
            trailing: IconButton(
              onPressed: () =>
                  _showDeleteDialog(context, hospitalization, notifier),
              icon: Icon(Icons.delete, color: Colors.red.shade600),
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _calculateDuration(DateTime start, DateTime end) {
    final duration = end.difference(start);
    final days = duration.inDays;
    return days == 1 ? '1 día' : '$days días';
  }

  void _showCreateDialog(
    BuildContext context,
    HospitalizationNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => HospitalizationFormDialog(
        onSubmit: (hospitalization) {
          notifier.createHospitalization(hospitalization);
          Navigator.of(context).pop();
        },
        patientId: patientId,
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    Hospitalization hospitalization,
    HospitalizationNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
          '¿Está seguro de que desea eliminar la hospitalización por "${hospitalization.reason}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              notifier.deleteHospitalization(hospitalization.id!);
              Navigator.of(context).pop();
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
}
