import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/data/supabase/common/sharing_session_repository_sp.dart';
import 'package:project_3_kawsay/state/patient/sharing_sessions_state.dart';

class SharingSessionsNotifier extends StateNotifier<SharingSessionsState> {
  final SharingSessionRepositorySp _repository = SharingSessionRepositorySp();

  SharingSessionsNotifier() : super(SharingSessionsState());

  Future<void> loadSessions(int patientId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final sessions = await _repository.getSharingSessionsByPatientId(
        patientId.toString(),
      );

      state = state.copyWith(sessions: sessions, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> deleteSession(String sessionId) async {
    state = state.copyWith(
      isDeleting: true,
      deletingSessionId: sessionId,
      error: null,
    );

    try {
      await _repository.deleteSharingSession(sessionId);
      final updatedSessions = state.sessions
          .where((session) => session.id.toString() != sessionId)
          .toList();

      state = state.copyWith(
        sessions: updatedSessions,
        isDeleting: false,
        deletingSessionId: null,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isDeleting: false,
        deletingSessionId: null,
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void reset() {
    state = SharingSessionsState();
  }
}

final sharingSessionsProvider =
    StateNotifierProvider<SharingSessionsNotifier, SharingSessionsState>(
      (ref) => SharingSessionsNotifier(),
    );
