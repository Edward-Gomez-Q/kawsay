import 'package:flutter/material.dart';
import 'package:project_3_kawsay/model/common/appointment_model.dart';
import 'package:project_3_kawsay/model/common/medical_consultation_model.dart';
import 'package:project_3_kawsay/model/common/sharing_session_model.dart';
import 'package:project_3_kawsay/model/patient/medical_history_model.dart';

enum ReceiveCodeStatus { initial, loading, success, error, expired }

class ReceiveCodeState {
  final ReceiveCodeStatus status;
  final String? errorMessage;
  final SharingSessionModel? sharingSession;
  final MedicalHistoryModel? medicalHistory;
  final AppointmentModel? appointment;
  final String shareCode;
  final List<MedicalConsultationModel> consultations;
  final bool isCreatingConsultation;
  final DateTime? lastUpdated;

  ReceiveCodeState({
    required this.status,
    this.errorMessage,
    this.sharingSession,
    this.medicalHistory,
    this.appointment,
    required this.shareCode,
    required this.consultations,
    this.isCreatingConsultation = false,
    this.lastUpdated,
  });

  ReceiveCodeState copyWith({
    ReceiveCodeStatus? status,
    String? errorMessage,
    SharingSessionModel? sharingSession,
    MedicalHistoryModel? medicalHistory,
    AppointmentModel? appointment,
    String? shareCode,
    List<MedicalConsultationModel>? consultations,
    bool? isCreatingConsultation,
    DateTime? lastUpdated,
  }) {
    return ReceiveCodeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      sharingSession: sharingSession ?? this.sharingSession,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      appointment: appointment ?? this.appointment,
      shareCode: shareCode ?? this.shareCode,
      consultations: consultations ?? this.consultations,
      isCreatingConsultation:
          isCreatingConsultation ?? this.isCreatingConsultation,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  bool get isSessionActive {
    if (sharingSession == null) return false;
    final now = DateTime.now();
    return sharingSession!.isActive && now.isBefore(sharingSession!.expiresAt);
  }

  Duration? get timeRemaining {
    if (sharingSession == null) return null;
    final now = DateTime.now();
    if (now.isAfter(sharingSession!.expiresAt)) return null;
    return sharingSession!.expiresAt.difference(now);
  }
}

String formatTimeRemaining(Duration duration) {
  int minutes = duration.inMinutes;
  int seconds = duration.inSeconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}

Color getTimerColor(Duration timeRemaining) {
  if (timeRemaining.inSeconds <= 60) {
    return Colors.red;
  } else if (timeRemaining.inSeconds <= 300) {
    return Colors.orange;
  } else {
    return Colors.green;
  }
}
