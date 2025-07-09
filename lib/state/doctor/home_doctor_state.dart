class HomeDoctorState {
  final int appointmentCount;
  final int diagnosticsCount;

  const HomeDoctorState({this.appointmentCount = 0, this.diagnosticsCount = 0});
  HomeDoctorState copyWith({int? appointmentCount, int? diagnosticsCount}) {
    return HomeDoctorState(
      appointmentCount: appointmentCount ?? this.appointmentCount,
      diagnosticsCount: diagnosticsCount ?? this.diagnosticsCount,
    );
  }
}
