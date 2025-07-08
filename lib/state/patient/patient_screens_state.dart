class PatientScreensState {
  final int currentStep;
  // 0: Home, 1: Medical History, 2: Share Data, 3: Patient Profile
  // 11: Información critica
  // 12: Alergias Médicas
  // 13: Condiciones Crónicas
  // 14: Historial Quirúrgico
  // 15: Hospitalizaciones
  // 16: Vacunas
  // 17: Antecedentes Familiares
  // 18: Estilo de Vida
  // 19: Seguro Médico
  // 20: Contactos de Emergencia
  final List<int> steps = [0, 1, 2, 3, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];
  final bool isLoading;
  PatientScreensState({this.currentStep = 0, this.isLoading = false});
  PatientScreensState copyWith({int? currentStep, bool? isLoading}) {
    return PatientScreensState(
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
