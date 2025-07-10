import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/data/supabase/common/appointment_repository_sp.dart';
import 'package:project_3_kawsay/data/supabase/common/medical_consultation_repository_sp.dart';
import 'package:project_3_kawsay/state/doctor/home_doctor_state.dart';

class HomeDoctorNotifier extends StateNotifier<HomeDoctorState> {
  final AppointmentRepositorySp _appointmentRepository =
      AppointmentRepositorySp();
  final MedicalConsultationRepositorySp _medicalConsultationRepository =
      MedicalConsultationRepositorySp();
  final int doctorId;
  HomeDoctorNotifier(this.doctorId) : super(const HomeDoctorState()) {
    loadCounts(doctorId);
  }

  void updateAppointmentCount(int count) {
    state = state.copyWith(appointmentCount: count);
  }

  void updateDiagnosticsCount(int count) {
    state = state.copyWith(diagnosticsCount: count);
  }

  void resetCounts() {
    state = const HomeDoctorState();
  }

  Future<void> loadCounts(int doctorId) async {
    if (doctorId <= 0) {
      return;
    }
    try {
      final appointments = await _appointmentRepository.getAppointmentsByDoctor(
        doctorId,
      );
      final diagnostics = await _medicalConsultationRepository
          .getMedicalConsultationsByDoctorId(doctorId);

      updateAppointmentCount(appointments.length);
      updateDiagnosticsCount(diagnostics.length);
    } catch (e) {
      print('Error loading counts: $e');
    }
  }
}

final homeDoctorProvider =
    StateNotifierProvider.family<HomeDoctorNotifier, HomeDoctorState, int>(
      (ref, doctorId) => HomeDoctorNotifier(doctorId),
    );
