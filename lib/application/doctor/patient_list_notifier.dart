import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/data/supabase/common/appointment_repository_sp.dart';
import 'package:project_3_kawsay/data/supabase/common/medical_consultation_repository_sp.dart';
import 'package:project_3_kawsay/model/doctor/appointment_with_patient_model.dart';
import 'package:project_3_kawsay/state/doctor/patient_list_state.dart';

class PatientListNotifier extends StateNotifier<PatientListState> {
  final AppointmentRepositorySp _appointmentRepository;
  final MedicalConsultationRepositorySp _medicalConsultationRepositorySp;

  PatientListNotifier(
    this._appointmentRepository,
    this._medicalConsultationRepositorySp,
  ) : super(const PatientListState());

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

  Future<void> loadConsultations(int idAppointment) async {
    state = state.copyWith(isLoadingConsultations: true, consultations: []);
    try {
      final consultations = await _medicalConsultationRepositorySp
          .getMedicalConsultationByAppointmentId(idAppointment);
      state = state.copyWith(
        consultations: consultations,
        isLoadingConsultations: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingConsultations: false,
        error: 'Error al cargar las consultas médicas: $e',
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

  // vaciar la lista de consultas médicas
  void clearConsultations() {
    state = state.copyWith(consultations: []);
  }
}

final patientListProvider =
    StateNotifierProvider<PatientListNotifier, PatientListState>((ref) {
      final appointmentRepository = AppointmentRepositorySp();
      final medicalConsultationRepository = MedicalConsultationRepositorySp();
      return PatientListNotifier(
        appointmentRepository,
        medicalConsultationRepository,
      );
    });
