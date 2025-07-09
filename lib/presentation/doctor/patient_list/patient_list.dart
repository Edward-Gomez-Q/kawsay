import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/common/auth_notifier.dart';
import 'package:project_3_kawsay/application/common/navigation_service.dart';
import 'package:project_3_kawsay/application/doctor/patient_list_notifier.dart';
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
          return _buildAppointmentCard(context, appointment);
        },
      ),
    );
  }

  Widget _buildAppointmentCard(
    BuildContext context,
    AppointmentWithPatientModel appointment,
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
                    // Acción para abrir consulta
                    _openConsultation(context, appointment);
                  },
                  child: const Text('Consultar'),
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

  void _openConsultation(
    BuildContext context,
    AppointmentWithPatientModel appointment,
  ) {
    // Aquí puedes navegar a la pantalla de consulta
    // navigation.pushNamed('/consultation', arguments: appointment);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Abriendo consulta para ${appointment.fullPatientName}'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
