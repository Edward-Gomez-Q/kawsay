import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/common/encryption_service.dart';
import 'package:project_3_kawsay/data/supabase/common/appointment_repository_sp.dart';
import 'package:project_3_kawsay/data/supabase/common/medical_consultation_repository_sp.dart';
import 'package:project_3_kawsay/data/supabase/common/sharing_session_repository_sp.dart';
import 'package:project_3_kawsay/model/common/appointment_model.dart';
import 'package:project_3_kawsay/model/common/medical_consultation_model.dart';
import 'package:project_3_kawsay/state/doctor/receive_code_state.dart';

class ReceiveCodeNotifier extends StateNotifier<ReceiveCodeState> {
  final SharingSessionRepositorySp _sharingRepo = SharingSessionRepositorySp();
  final AppointmentRepositorySp _appointmentRepo = AppointmentRepositorySp();
  final MedicalConsultationRepositorySp _consultationRepo =
      MedicalConsultationRepositorySp();
  Timer? _timer;

  ReceiveCodeNotifier()
    : super(
        ReceiveCodeState(
          status: ReceiveCodeStatus.initial,
          shareCode: '',
          consultations: [],
        ),
      );

  void updateShareCode(String code) {
    state = state.copyWith(shareCode: code);
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.sharingSession == null) {
        timer.cancel();
        return;
      }

      final now = DateTime.now();

      if (now.isAfter(state.sharingSession!.expiresAt)) {
        timer.cancel();
        state = state.copyWith(
          status: ReceiveCodeStatus.expired,
          errorMessage: 'La sesión ha expirado',
        );
        return;
      }
      state = state.copyWith(lastUpdated: DateTime.now());
    });
  }

  Future<void> verifyAndAccessCode(int doctorId, String shareCode) async {
    if (shareCode.isEmpty) {
      state = state.copyWith(
        status: ReceiveCodeStatus.error,
        errorMessage: 'Por favor ingresa un código válido',
      );
      return;
    }

    state = state.copyWith(status: ReceiveCodeStatus.loading);

    try {
      final sharingSession = await _sharingRepo.getSharingSessionByShareCode(
        shareCode,
      );

      if (sharingSession == null) {
        state = state.copyWith(
          status: ReceiveCodeStatus.error,
          errorMessage: 'Código no válido o expirado',
        );
        return;
      }
      final now = DateTime.now();
      if (now.isAfter(sharingSession.expiresAt)) {
        state = state.copyWith(
          status: ReceiveCodeStatus.expired,
          errorMessage: 'El código ha expirado',
          sharingSession: sharingSession,
        );
        return;
      }
      final medicalHistory = EncryptionService.decryptModel(
        sharingSession.sharedData,
      );
      print('Medical History: $medicalHistory');

      final appointmentModel = AppointmentModel(
        id: 0,
        sharingSessionId: sharingSession.id,
        appointmentDate: DateTime.now(),
        appointmentStatus: 'active',
        consultationType: 'remote_access',
        patientId: sharingSession.patientId,
        doctorId: doctorId,
      );

      final createdAppointment = await _appointmentRepo.createAppointment(
        appointmentModel,
      );

      if (createdAppointment == null) {
        state = state.copyWith(
          status: ReceiveCodeStatus.error,
          errorMessage: 'Error al crear la cita médica',
        );
        return;
      }

      state = state.copyWith(
        status: ReceiveCodeStatus.success,
        sharingSession: sharingSession,
        medicalHistory: medicalHistory,
        appointment: createdAppointment,
      );
      _startTimer();
    } catch (e) {
      state = state.copyWith(
        status: ReceiveCodeStatus.error,
        errorMessage: 'Error al procesar el código: $e',
      );
    }
  }

  Future<void> createConsultation({
    required String chiefComplaint,
    required String physicalExamination,
    required String vitalSigns,
    required String diagnosis,
    required String treatmentPlan,
    required String observations,
    required String followUpInstructions,
    required bool nextAppointmentRecommended,
    required DateTime followUpDate,
  }) async {
    if (state.appointment == null) return;

    state = state.copyWith(isCreatingConsultation: true);

    try {
      final consultation = MedicalConsultationModel(
        id: 0,
        appointmentId: state.appointment!.id,
        chiefComplaint: chiefComplaint,
        physicalExamination: physicalExamination,
        vitalSigns: vitalSigns,
        diagnosis: diagnosis,
        treatmentPlan: treatmentPlan,
        observations: observations,
        followUpInstructions: followUpInstructions,
        nextAppointmentRecommended: nextAppointmentRecommended,
        followUpDate: followUpDate,
      );

      final createdConsultation = await _consultationRepo
          .createMedicalConsultation(consultation);

      final updatedConsultations = [
        ...state.consultations,
        createdConsultation,
      ];

      state = state.copyWith(
        consultations: updatedConsultations,
        isCreatingConsultation: false,
      );
    } catch (e) {
      state = state.copyWith(
        isCreatingConsultation: false,
        errorMessage: 'Error al crear consulta: $e',
      );
    }
  }

  void reset() {
    _timer?.cancel();
    state = ReceiveCodeState(
      status: ReceiveCodeStatus.initial,
      shareCode: '',
      consultations: [],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final receiveCodeProvider =
    StateNotifierProvider<ReceiveCodeNotifier, ReceiveCodeState>((ref) {
      return ReceiveCodeNotifier();
    });
