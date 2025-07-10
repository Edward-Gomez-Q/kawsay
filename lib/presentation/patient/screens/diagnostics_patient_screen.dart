import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/common/auth_notifier.dart';
import 'package:project_3_kawsay/application/patient/diagnostics_patient_notifier.dart';
import 'package:project_3_kawsay/model/common/medical_consultation_model.dart';
import 'package:project_3_kawsay/model/patient/appointment_with_doctor_model.dart';
import 'package:project_3_kawsay/state/patient/diagnostics_patient_state.dart';

class DiagnosticsPatientScreen extends ConsumerStatefulWidget {
  const DiagnosticsPatientScreen({super.key});

  @override
  ConsumerState<DiagnosticsPatientScreen> createState() =>
      _DiagnosticsPatientScreenState();
}

class _DiagnosticsPatientScreenState
    extends ConsumerState<DiagnosticsPatientScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final idPatient = ref.read(authProvider).patientId!.id;
      ref.read(diagnosticsPatientProvider.notifier).loadAppointments(idPatient);
    });
  }

  @override
  Widget build(BuildContext context) {
    final idPatient = ref.watch(authProvider).patientId!.id ?? 0;
    final patientListState = ref.watch(diagnosticsPatientProvider);
    final patientListNotifier = ref.read(diagnosticsPatientProvider.notifier);

    return Column(
      children: [
        Expanded(
          child: _buildContent(
            context,
            patientListState,
            patientListNotifier,
            idPatient,
          ),
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    DiagnosticsPatientState state,
    DiagnosticsPatientNotifier notifier,
    int idPatient,
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
                ref.read(authProvider).patientId!.id,
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: state.appointments.length,
        itemBuilder: (context, index) {
          final appointment = state.appointments[index];
          return _buildAppointmentCard(
            context,
            appointment,
            state,
            notifier,
            idPatient,
          );
        },
      ),
    );
  }

  Widget _buildAppointmentCard(
    BuildContext context,
    AppointmentWithDoctorModel appointment,
    DiagnosticsPatientState state,
    DiagnosticsPatientNotifier notifier,
    int idPatient,
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
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        appointment.doctorFirstLastName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showDiagnostics(BuildContext context, int appointmentId) {
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final state = ref.watch(diagnosticsPatientProvider);

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

  Widget _buildDialogContent(
    BuildContext context,
    DiagnosticsPatientState state,
  ) {
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
        color: Theme.of(context).colorScheme.surface,
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
            : Theme.of(context).colorScheme.surface,
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
