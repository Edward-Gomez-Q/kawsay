enum TimeType { minutes, hours, days, weeks }

class ShareDataState {
  final Map<String, bool> selectedData;
  final TimeType selectedTimeType;
  final int selectedTimeValue;
  final String? generatedCode;
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  ShareDataState({
    required this.selectedData,
    this.selectedTimeType = TimeType.minutes,
    this.selectedTimeValue = 20,
    this.generatedCode,
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  ShareDataState copyWith({
    Map<String, bool>? selectedData,
    TimeType? selectedTimeType,
    int? selectedTimeValue,
    String? generatedCode,
    bool? isLoading,
    String? error,
    bool? isSuccess,
  }) {
    return ShareDataState(
      selectedData: selectedData ?? this.selectedData,
      selectedTimeType: selectedTimeType ?? this.selectedTimeType,
      selectedTimeValue: selectedTimeValue ?? this.selectedTimeValue,
      generatedCode: generatedCode ?? this.generatedCode,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
