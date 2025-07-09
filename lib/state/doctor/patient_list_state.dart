import 'package:project_3_kawsay/model/common/medical_consultation_model.dart';
import 'package:project_3_kawsay/model/doctor/appointment_with_patient_model.dart';

class PatientListState {
  final List<AppointmentWithPatientModel> appointments;
  final List<MedicalConsultationModel>? consultations;
  final bool isLoading;
  final bool isLoadingConsultations;
  final String? error;
  final String searchQuery;

  const PatientListState({
    this.appointments = const [],
    this.isLoading = false,
    this.isLoadingConsultations = false,
    this.consultations = const [],
    this.error,
    this.searchQuery = '',
  });

  PatientListState copyWith({
    List<AppointmentWithPatientModel>? appointments,
    bool? isLoading,
    bool? isLoadingConsultations,
    String? error,
    String? searchQuery,
    List<MedicalConsultationModel>? consultations,
  }) {
    return PatientListState(
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
