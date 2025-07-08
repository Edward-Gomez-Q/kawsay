import 'package:project_3_kawsay/model/patient/family_history.dart';

class FamilyHistoryState {
  final List<FamilyHistory> familyHistoryList;
  final bool isLoading;
  final bool isCreating;
  final String? error;

  FamilyHistoryState({
    this.familyHistoryList = const [],
    this.isLoading = false,
    this.isCreating = false,
    this.error,
  });

  FamilyHistoryState copyWith({
    List<FamilyHistory>? familyHistoryList,
    bool? isLoading,
    bool? isCreating,
    String? error,
  }) {
    return FamilyHistoryState(
      familyHistoryList: familyHistoryList ?? this.familyHistoryList,
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      error: error,
    );
  }
}
