import 'package:project_3_kawsay/model/patient/chronic_condition.dart';

class ChronicConditionState {
  final List<ChronicCondition> conditions;
  final bool isLoading;
  final bool isCreating;
  final String? error;

  ChronicConditionState({
    this.conditions = const [],
    this.isLoading = false,
    this.isCreating = false,
    this.error,
  });
  ChronicConditionState copyWith({
    List<ChronicCondition>? conditions,
    bool? isLoading,
    bool? isCreating,
    String? error,
  }) {
    return ChronicConditionState(
      conditions: conditions ?? this.conditions,
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      error: error,
    );
  }
}
