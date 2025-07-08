import 'package:project_3_kawsay/model/patient/surgical_history.dart';

class SurgicalHistoryState {
  final List<SurgicalHistory> surgicalHistoryList;
  final bool isLoading;
  final bool isCreating;
  final String? error;

  const SurgicalHistoryState({
    this.surgicalHistoryList = const [],
    this.isLoading = false,
    this.isCreating = false,
    this.error,
  });

  SurgicalHistoryState copyWith({
    List<SurgicalHistory>? surgicalHistoryList,
    bool? isLoading,
    bool? isCreating,
    String? error,
  }) {
    return SurgicalHistoryState(
      surgicalHistoryList: surgicalHistoryList ?? this.surgicalHistoryList,
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      error: error,
    );
  }
}
