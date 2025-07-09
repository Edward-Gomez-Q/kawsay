import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/data/supabase/common/medical_consultation_repository_sp.dart';
import 'package:project_3_kawsay/state/doctor/diagnostics_state.dart';

class DiagnosticsNotifier extends StateNotifier<DiagnosticsState> {
  final MedicalConsultationRepositorySp _repository;
  DiagnosticsNotifier(this._repository) : super(const DiagnosticsState());

  Future<void> loadDiagnosticsByDoctor(int doctorId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final consultations = await _repository.getMedicalConsultationsByDoctorId(
        doctorId,
      );
      state = state.copyWith(consultations: consultations, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar diagnósticos: $e',
      );
    }
  }
}

final diagnosticsProvider =
    StateNotifierProvider<DiagnosticsNotifier, DiagnosticsState>((ref) {
      final repository = MedicalConsultationRepositorySp();
      return DiagnosticsNotifier(repository);
    });
