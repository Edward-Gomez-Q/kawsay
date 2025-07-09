import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/common/auth_notifier.dart';
import 'package:project_3_kawsay/application/common/navigation_service.dart';
import 'package:project_3_kawsay/application/doctor/patient_list_notifier.dart';
import 'package:project_3_kawsay/model/common/medical_consultation_model.dart';
import 'package:project_3_kawsay/model/doctor/appointment_with_patient_model.dart';
import 'package:project_3_kawsay/state/doctor/patient_list_state.dart';

class PatientList extends ConsumerStatefulWidget {
  const PatientList({super.key});

  @override
  ConsumerState<PatientList> createState() => _PatientListState();
}

class _PatientListState extends ConsumerState<PatientList> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final idDoctor = ref.read(authProvider).doctor!.id;
      ref.read(patientListProvider.notifier).loadAppointments(idDoctor);
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigation = ref.watch(navigationServiceProvider);
    final idDoctor = ref.watch(authProvider).doctor!.id;
    final patientListState = ref.watch(patientListProvider);
    final patientListNotifier = ref.read(patientListProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de Pacientes',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => patientListNotifier.refreshAppointments(idDoctor),
          ),
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              navigation.goToHomeDoctor();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: patientListNotifier.searchPatients,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o código...',
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
          Expanded(
            child: _buildContent(
              context,
              patientListState,
              patientListNotifier,
              idDoctor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    PatientListState state,
    PatientListNotifier notifier,
    int idDoctor,
  ) {
    if (state.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Cargando citas...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              state.error!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => notifier.refreshAppointments(
                ref.read(authProvider).doctor!.id,
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    final filteredAppointments = notifier.filteredAppointments;

    if (filteredAppointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              state.searchQuery.isEmpty
                  ? 'No hay citas registradas'
                  : 'No se encontraron resultados',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          notifier.refreshAppointments(ref.read(authProvider).doctor!.id),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filteredAppointments.length,
        itemBuilder: (context, index) {
          final appointment = filteredAppointments[index];
          return _buildAppointmentCard(
            context,
            appointment,
            state,
            notifier,
            idDoctor,
          );
        },
      ),
    );
  }

  Widget _buildAppointmentCard(
    BuildContext context,
    AppointmentWithPatientModel appointment,
    PatientListState state,
    PatientListNotifier notifier,
    int idDoctor,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    appointment.fullPatientName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStatusChip(context, appointment.appointmentStatus),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDate(appointment.appointmentDate),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Icon(
                  Icons.code,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  'Código: ${appointment.shareCode}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    // Acción para ver detalles
                    _showAppointmentDetails(context, appointment);
                  },
                  child: const Text('Ver detalles'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    notifier.loadConsultations(appointment.id);
                    _showDiagnostics(context, appointment.id);
                  },
                  child: const Text('Ver Diagnósticos'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    Color chipColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'programada':
        chipColor = Theme.of(context).colorScheme.primary;
        textColor = Theme.of(context).colorScheme.onPrimary;
        break;
      case 'completada':
        chipColor = Colors.green;
        textColor = Colors.white;
        break;
      case 'cancelada':
        chipColor = Theme.of(context).colorScheme.error;
        textColor = Theme.of(context).colorScheme.onError;
        break;
      default:
        chipColor = Theme.of(context).colorScheme.surface;
        textColor = Theme.of(context).colorScheme.onSurfaceVariant;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showAppointmentDetails(
    BuildContext context,
    AppointmentWithPatientModel appointment,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Detalles de la Cita',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Paciente: ${appointment.fullPatientName}'),
            Text('ID Cita: ${appointment.id}'),
            Text('Código: ${appointment.shareCode}'),
            Text('Fecha: ${_formatDate(appointment.appointmentDate)}'),
            Text('Estado: ${appointment.appointmentStatus}'),
            Text('Tipo: ${appointment.consultationType}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showDiagnostics(BuildContext context, int appointmentId) {
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(patientListProvider);

          return AlertDialog(
            title: Text(
              'Diagnósticos',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            content: _buildDialogContent(context, state),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDialogContent(BuildContext context, PatientListState state) {
    if (state.isLoadingConsultations) {
      return const SizedBox(
        height: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Cargando diagnósticos...'),
            ],
          ),
        ),
      );
    }

    if (state.error != null) {
      return SizedBox(
        height: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 8),
              Text(
                'Error al cargar diagnósticos',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                state.error!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final consultations = state.consultations ?? [];

    if (consultations.isEmpty) {
      return SizedBox(
        height: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.assignment_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 8),
              Text(
                'No hay diagnósticos disponibles.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      width: double.maxFinite,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: consultations.length,
        itemBuilder: (context, index) {
          final consultation = consultations[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                consultation.diagnosis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Fecha: ${_formatDate(consultation.followUpDate)}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailSection(
                        context,
                        'Motivo de Consulta',
                        consultation.chiefComplaint,
                        Icons.chat_bubble_outline,
                      ),
                      _buildDetailSection(
                        context,
                        'Examen Físico',
                        consultation.physicalExamination,
                        Icons.medical_services_outlined,
                      ),
                      _buildDetailSection(
                        context,
                        'Signos Vitales',
                        consultation.vitalSigns,
                        Icons.favorite_outline,
                      ),
                      _buildDetailSection(
                        context,
                        'Plan de Tratamiento',
                        consultation.treatmentPlan,
                        Icons.healing_outlined,
                      ),
                      _buildDetailSection(
                        context,
                        'Observaciones',
                        consultation.observations,
                        Icons.note_outlined,
                      ),
                      _buildDetailSection(
                        context,
                        'Instrucciones de Seguimiento',
                        consultation.followUpInstructions,
                        Icons.info_outline,
                      ),
                      const SizedBox(height: 12),
                      _buildFollowUpCard(context, consultation),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailSection(
    BuildContext context,
    String title,
    String content,
    IconData icon,
  ) {
    if (content.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(content, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildFollowUpCard(
    BuildContext context,
    MedicalConsultationModel consultation,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: consultation.nextAppointmentRecommended
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            consultation.nextAppointmentRecommended
                ? Icons.event_available
                : Icons.event_busy,
            color: consultation.nextAppointmentRecommended
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Próxima Cita',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  consultation.nextAppointmentRecommended
                      ? 'Recomendada para ${_formatDate(consultation.followUpDate)}'
                      : 'No recomendada',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
