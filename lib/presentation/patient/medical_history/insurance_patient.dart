import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/patient/insurance_notifier.dart';
import 'package:project_3_kawsay/model/patient/insurance.dart';
import 'package:project_3_kawsay/presentation/patient/medical_history/insurance_form_dialog.dart';

class InsurancePatient extends ConsumerWidget {
  final int patientId;

  const InsurancePatient({super.key, required this.patientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insuranceState = ref.watch(insuranceProvider(patientId));
    final insuranceNotifier = ref.read(insuranceProvider(patientId).notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con título y botón de agregar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seguros Médicos',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Información de seguros del paciente',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              FilledButton.icon(
                onPressed: () => _showCreateDialog(context, insuranceNotifier),
                icon: const Icon(Icons.add),
                label: const Text('Agregar'),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Mostrar error si existe
          if (insuranceState.error != null)
            Card(
              color: colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        insuranceState.error!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: insuranceNotifier.clearError,
                      icon: const Icon(Icons.close),
                      color: colorScheme.onErrorContainer,
                    ),
                  ],
                ),
              ),
            ),

          if (insuranceState.error != null) const SizedBox(height: 16),

          // Contenido principal
          Expanded(
            child: insuranceState.isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: colorScheme.primary),
                        const SizedBox(height: 16),
                        Text(
                          'Cargando seguros...',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  )
                : insuranceState.insurances.isEmpty
                ? _buildEmptyState(context, theme, colorScheme)
                : _buildInsuranceList(
                    context,
                    theme,
                    colorScheme,
                    insuranceState.insurances,
                    insuranceNotifier,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.shield_outlined,
              size: 64,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No hay seguros registrados',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Presiona "Agregar" para registrar un seguro médico',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInsuranceList(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    List<Insurance> insurances,
    InsuranceNotifier notifier,
  ) {
    return ListView.builder(
      itemCount: insurances.length,
      itemBuilder: (context, index) {
        final insurance = insurances[index];
        final isActive = _isInsuranceActive(insurance);
        final daysRemaining = _getDaysRemaining(insurance);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          child: InkWell(
            onTap: () =>
                _showInsuranceDetails(context, theme, colorScheme, insurance),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header con proveedor y estado
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? colorScheme.primaryContainer
                                    : colorScheme.errorContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.shield,
                                color: isActive
                                    ? colorScheme.onPrimaryContainer
                                    : colorScheme.onErrorContainer,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    insurance.provider,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.onSurface,
                                        ),
                                  ),
                                  Text(
                                    'Póliza: ${insurance.policyNumber}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurface.withValues(
                                        alpha: 0.7,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'details',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                const Text('Ver detalles'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  color: colorScheme.error,
                                ),
                                const SizedBox(width: 8),
                                const Text('Eliminar'),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 'details') {
                            _showInsuranceDetails(
                              context,
                              theme,
                              colorScheme,
                              insurance,
                            );
                          } else if (value == 'delete') {
                            _showDeleteDialog(
                              context,
                              theme,
                              colorScheme,
                              insurance,
                              notifier,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Estado y vigencia
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? colorScheme.primaryContainer
                              : colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isActive ? 'Activo' : 'Vencido',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isActive
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onErrorContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (isActive && daysRemaining <= 30)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Vence en $daysRemaining días',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Fechas
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Vigencia: ${_formatDate(insurance.startDate)} - ${_formatDate(insurance.endDate)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isInsuranceActive(Insurance insurance) {
    final now = DateTime.now();
    return now.isAfter(insurance.startDate) && now.isBefore(insurance.endDate);
  }

  int _getDaysRemaining(Insurance insurance) {
    final now = DateTime.now();
    return insurance.endDate.difference(now).inDays;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _showInsuranceDetails(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    Insurance insurance,
  ) {
    final isActive = _isInsuranceActive(insurance);
    final daysRemaining = _getDaysRemaining(insurance);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.shield, color: colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                insurance.provider,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
              context,
              theme,
              colorScheme,
              'Número de póliza',
              insurance.policyNumber,
              Icons.badge,
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              context,
              theme,
              colorScheme,
              'Fecha de inicio',
              _formatDate(insurance.startDate),
              Icons.play_arrow,
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              context,
              theme,
              colorScheme,
              'Fecha de vencimiento',
              _formatDate(insurance.endDate),
              Icons.stop,
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              context,
              theme,
              colorScheme,
              'Estado',
              isActive ? 'Activo' : 'Vencido',
              isActive ? Icons.check_circle : Icons.cancel,
            ),
            if (isActive && daysRemaining <= 30) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: colorScheme.onSecondaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'El seguro vence en $daysRemaining días',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCreateDialog(BuildContext context, InsuranceNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => InsuranceFormDialog(
        onSubmit: (insurance) {
          notifier.createInsurance(insurance);
          Navigator.of(context).pop();
        },
        patientId: patientId,
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    Insurance insurance,
    InsuranceNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: colorScheme.error),
            const SizedBox(width: 8),
            const Text('Confirmar eliminación'),
          ],
        ),
        content: Text(
          '¿Está seguro de que desea eliminar el seguro de "${insurance.provider}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              notifier.deleteInsurance(insurance.id!);
              Navigator.of(context).pop();
            },
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
