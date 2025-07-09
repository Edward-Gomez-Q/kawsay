import 'package:project_3_kawsay/model/doctor/appointment_with_patient_model.dart';

class PatientListState {
  final List<AppointmentWithPatientModel> appointments;
  final bool isLoading;
  final String? error;
  final String searchQuery;

  const PatientListState({
    this.appointments = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
  });

  PatientListState copyWith({
    List<AppointmentWithPatientModel>? appointments,
    bool? isLoading,
    String? error,
    String? searchQuery,
  }) {
    return PatientListState(
      appointments: appointments ?? this.appointments,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
