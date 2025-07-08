class PatientScreensState {
  final int currentStep;
  final List<int> steps = [0, 1, 2, 3];
  final bool isLoading;

  //Constructor
  PatientScreensState({this.currentStep = 0, this.isLoading = false});
  //Método para copiar el estado actual y modificarlo
  PatientScreensState copyWith({int? currentStep, bool? isLoading}) {
    return PatientScreensState(
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
