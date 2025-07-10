import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/data/supabase/common/appointment_repository_sp.dart';
import 'package:project_3_kawsay/data/supabase/common/medical_consultation_repository_sp.dart';
import 'package:project_3_kawsay/state/patient/diagnostics_patient_state.dart';

class DiagnosticsPatientNotifier
    extends StateNotifier<DiagnosticsPatientState> {
  final AppointmentRepositorySp _appointmentRepository;
  final MedicalConsultationRepositorySp _medicalConsultationRepositorySp;

  DiagnosticsPatientNotifier(
    this._appointmentRepository,
    this._medicalConsultationRepositorySp,
  ) : super(const DiagnosticsPatientState());

  Future<void> loadAppointments(int patientId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final appointments = await _appointmentRepository
          .getAppointmentsByPatient(patientId);
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

  Future<void> refreshAppointments(int patientId) async {
    state = state.copyWith(isLoading: true, error: null);
    await loadAppointments(patientId);
  }
}

final diagnosticsPatientProvider =
    StateNotifierProvider<DiagnosticsPatientNotifier, DiagnosticsPatientState>((
      ref,
    ) {
      final appointmentRepository = AppointmentRepositorySp();
      final medicalConsultationRepository = MedicalConsultationRepositorySp();
      return DiagnosticsPatientNotifier(
        appointmentRepository,
        medicalConsultationRepository,
      );
    });
