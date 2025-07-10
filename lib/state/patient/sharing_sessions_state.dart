import 'package:project_3_kawsay/model/common/sharing_session_model.dart';

class SharingSessionsState {
  final List<SharingSessionModel> sessions;
  final bool isLoading;
  final bool isDeleting;
  final String? error;
  final String? deletingSessionId;

  SharingSessionsState({
    this.sessions = const [],
    this.isLoading = false,
    this.isDeleting = false,
    this.error,
    this.deletingSessionId,
  });
  SharingSessionsState copyWith({
    List<SharingSessionModel>? sessions,
    bool? isLoading,
    bool? isDeleting,
    String? error,
    String? deletingSessionId,
  }) {
    return SharingSessionsState(
      sessions: sessions ?? this.sessions,
      isLoading: isLoading ?? this.isLoading,
      isDeleting: isDeleting ?? this.isDeleting,
      error: error ?? this.error,
      deletingSessionId: deletingSessionId ?? this.deletingSessionId,
    );
  }
}
