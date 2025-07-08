class PatientScreensState {
  final int currentStep;
  final List<int> steps = [0, 1, 2, 3, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];
  final bool isLoading;
  final DateTime? medicalHistoryLastUpdated; // Inicializar con base de datos
  final int percentageCompleted; // Inicializar con base de datos

  PatientScreensState({
    this.currentStep = 0,
    this.isLoading = false,
    this.medicalHistoryLastUpdated,
    this.percentageCompleted = 0,
  });
  PatientScreensState copyWith({
    int? currentStep,
    bool? isLoading,
    DateTime? medicalHistoryLastUpdated,
    int? percentageCompleted,
  }) {
    return PatientScreensState(
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      medicalHistoryLastUpdated:
          medicalHistoryLastUpdated ?? this.medicalHistoryLastUpdated,
      percentageCompleted: percentageCompleted ?? this.percentageCompleted,
    );
  }
}
