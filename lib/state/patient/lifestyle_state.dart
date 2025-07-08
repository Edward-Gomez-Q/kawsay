import 'package:project_3_kawsay/model/patient/lifestyle.dart';

class LifestyleState {
  final Lifestyle? lifestyle;
  final bool isLoading;
  final bool isEditing;
  final String? error;

  LifestyleState({
    this.lifestyle,
    this.isLoading = false,
    this.isEditing = false,
    this.error,
  });

  LifestyleState copyWith({
    Lifestyle? lifestyle,
    bool? isLoading,
    bool? isEditing,
    String? error,
  }) {
    return LifestyleState(
      lifestyle: lifestyle ?? this.lifestyle,
      isLoading: isLoading ?? this.isLoading,
      isEditing: isEditing ?? this.isEditing,
      error: error,
    );
  }
}
