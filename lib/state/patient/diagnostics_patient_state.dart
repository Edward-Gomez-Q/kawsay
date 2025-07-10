import 'package:project_3_kawsay/model/common/medical_consultation_model.dart';
import 'package:project_3_kawsay/model/patient/appointment_with_doctor_model.dart';

class DiagnosticsPatientState {
  final List<AppointmentWithDoctorModel> appointments;
  final List<MedicalConsultationModel>? consultations;
  final bool isLoading;
  final bool isLoadingConsultations;
  final String? error;
  final String searchQuery;

  const DiagnosticsPatientState({
    this.appointments = const [],
    this.isLoading = false,
    this.isLoadingConsultations = false,
    this.consultations = const [],
    this.error,
    this.searchQuery = '',
  });

  DiagnosticsPatientState copyWith({
    List<AppointmentWithDoctorModel>? appointments,
    bool? isLoading,
    bool? isLoadingConsultations,
    String? error,
    String? searchQuery,
    List<MedicalConsultationModel>? consultations,
  }) {
    return DiagnosticsPatientState(
      appointments: appointments ?? this.appointments,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
      consultations: consultations ?? this.consultations,
      isLoadingConsultations:
          isLoadingConsultations ?? this.isLoadingConsultations,
    );
  }
}
