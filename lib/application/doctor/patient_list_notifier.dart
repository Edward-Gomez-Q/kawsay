import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/data/supabase/common/appointment_repository_sp.dart';
import 'package:project_3_kawsay/model/doctor/appointment_with_patient_model.dart';
import 'package:project_3_kawsay/state/doctor/patient_list_state.dart';

class PatientListNotifier extends StateNotifier<PatientListState> {
  final AppointmentRepositorySp _appointmentRepository;

  PatientListNotifier(this._appointmentRepository)
    : super(const PatientListState());

  Future<void> loadAppointments(int doctorId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final appointments = await _appointmentRepository.getAppointmentsByDoctor(
        doctorId,
      );
      state = state.copyWith(appointments: appointments, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar las citas: $e',
      );
    }
  }

  void searchPatients(String query) {
    state = state.copyWith(searchQuery: query);
  }

  List<AppointmentWithPatientModel> get filteredAppointments {
    if (state.searchQuery.isEmpty) {
      return state.appointments;
    }

    return state.appointments.where((appointment) {
      final fullName = appointment.fullPatientName.toLowerCase();
      final shareCode = appointment.shareCode.toLowerCase();
      final query = state.searchQuery.toLowerCase();

      return fullName.contains(query) || shareCode.contains(query);
    }).toList();
  }

  Future<void> refreshAppointments(int doctorId) async {
    await loadAppointments(doctorId);
  }
}

final patientListProvider =
    StateNotifierProvider<PatientListNotifier, PatientListState>((ref) {
      final appointmentRepository = AppointmentRepositorySp();
      return PatientListNotifier(appointmentRepository);
    });
