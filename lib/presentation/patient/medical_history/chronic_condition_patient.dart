import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/patient/chronic_condition_notifier.dart';
import 'package:project_3_kawsay/model/patient/chronic_condition.dart';
import 'package:project_3_kawsay/presentation/patient/medical_history/create_condition_dialog.dart';
import 'package:project_3_kawsay/state/patient/chronic_condition_state.dart';

class ChronicConditionPatient extends ConsumerStatefulWidget {
  final int patientId;

  const ChronicConditionPatient({super.key, required this.patientId});

  @override
  ConsumerState<ChronicConditionPatient> createState() =>
      _ChronicConditionPatientState();
}

class _ChronicConditionPatientState
    extends ConsumerState<ChronicConditionPatient> {
  @override
  void initState() {
    super.initState();

    // Cargar condiciones crónicas al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(chronicConditionProvider.notifier)
          .loadConditions(widget.patientId);
    });
  }

  void _showCreateConditionDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateConditionDialog(patientId: widget.patientId),
    );
  }

  void _showDeleteConfirmation(ChronicCondition condition) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
          '¿Está seguro de que desea eliminar la condición "${condition.condition}"?',
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
                  .read(chronicConditionProvider.notifier)
                  .deleteCondition(condition.id!);
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
    final state = ref.watch(chronicConditionProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado con botón de agregar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Condiciones Crónicas',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showCreateConditionDialog,
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
                      ref.read(chronicConditionProvider.notifier).clearError();
                    },
                  ),
                ],
              ),
            ),

          // Contenido principal
          _buildContent(state),
        ],
      ),
    );
  }

  Widget _buildContent(ChronicConditionState state) {
    if (state.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.conditions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.health_and_safety_outlined,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'No hay condiciones crónicas registradas',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              Text(
                'Toca el botón "Agregar" para registrar una nueva condición crónica',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.conditions.length,
      itemBuilder: (context, index) {
        final condition = state.conditions[index];
        return _buildConditionCard(condition);
      },
    );
  }

  Widget _buildConditionCard(ChronicCondition condition) {
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
                    condition.condition,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Indicador de estado controlado
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: condition.controlled
                            ? Colors.green.shade100
                            : Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        condition.controlled ? 'Controlada' : 'No controlada',
                        style: TextStyle(
                          color: condition.controlled
                              ? Colors.green.shade700
                              : Colors.orange.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _showDeleteConfirmation(condition),
                    ),
                  ],
                ),
              ],
            ),

            if (condition.diagnosisDate != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow(
                icon: Icons.calendar_today,
                label: 'Fecha de diagnóstico',
                value: _formatDate(condition.diagnosisDate!),
                color: Colors.blue,
              ),
            ],

            const SizedBox(height: 8),

            _buildInfoRow(
              icon: condition.controlled ? Icons.check_circle : Icons.warning,
              label: 'Estado',
              value: condition.controlled ? 'Controlada' : 'No controlada',
              color: condition.controlled ? Colors.green : Colors.orange,
            ),
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
