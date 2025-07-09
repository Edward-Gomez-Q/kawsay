import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/common/encryption_service.dart';
import 'package:project_3_kawsay/data/sqflite/patient/repositories/chronic_condition_repository.dart';
import 'package:project_3_kawsay/data/sqflite/patient/repositories/emergency_contact_repository.dart';
import 'package:project_3_kawsay/data/sqflite/patient/repositories/family_history_repository.dart';
import 'package:project_3_kawsay/data/sqflite/patient/repositories/hospitalization_repository.dart';
import 'package:project_3_kawsay/data/sqflite/patient/repositories/insurance_repository.dart';
import 'package:project_3_kawsay/data/sqflite/patient/repositories/lifestyle_repository.dart';
import 'package:project_3_kawsay/data/sqflite/patient/repositories/medical_allergy_repository.dart';
import 'package:project_3_kawsay/data/sqflite/patient/repositories/medical_critical_info_repository.dart';
import 'package:project_3_kawsay/data/sqflite/patient/repositories/surgical_history_repository.dart';
import 'package:project_3_kawsay/data/sqflite/patient/repositories/vaccination_repository.dart';
import 'package:project_3_kawsay/data/supabase/common/person_repository_sp.dart';
import 'package:project_3_kawsay/data/supabase/common/sharing_session_repository_sp.dart';
import 'package:project_3_kawsay/model/common/sharing_session_model.dart';
import 'package:project_3_kawsay/model/patient/medical_history_model.dart';
import 'package:project_3_kawsay/state/patient/share_data_patient_state.dart';

class ShareDataNotifier extends StateNotifier<ShareDataState> {
  final ChronicConditionRepository _chronicConditionRepository =
      ChronicConditionRepository();
  final EmergencyContactRepository _emergencyContactRepository =
      EmergencyContactRepository();
  final FamilyHistoryRepository _familyHistoryRepository =
      FamilyHistoryRepository();
  final HospitalizationRepository _hospitalizationRepository =
      HospitalizationRepository();
  final InsuranceRepository _insuranceRepository = InsuranceRepository();
  final LifestyleRepository _lifestyleRepository = LifestyleRepository();
  final MedicalAllergyRepository _medicalAllergyRepository =
      MedicalAllergyRepository();
  final MedicalCriticalInfoRepository _medicalCriticalInfoRepository =
      MedicalCriticalInfoRepository();
  final SurgicalHistoryRepository _surgicalHistoryRepository =
      SurgicalHistoryRepository();
  final VaccinationRepository _vaccinationRepository = VaccinationRepository();
  final PersonRepositorySp _personRepository = PersonRepositorySp();
  final int patientId;
  final int personId;

  final SharingSessionRepositorySp _sharingSessionRepository =
      SharingSessionRepositorySp();

  ShareDataNotifier(this.patientId, this.personId)
    : super(
        ShareDataState(
          selectedData: {
            'personalData': true,
            'chronicConditions': false,
            'emergencyContacts': false,
            'familyHistories': false,
            'hospitalizations': false,
            'insurances': false,
            'lifestyles': false,
            'medicalAllergies': false,
            'medicalCriticalInfo': false,
            'surgicalHistories': false,
            'vaccinations': false,
          },
        ),
      );

  void toggleDataSelection(String key) {
    if (key == 'personalData') return;

    final newSelectedData = Map<String, bool>.from(state.selectedData);
    newSelectedData[key] = !newSelectedData[key]!;

    state = state.copyWith(selectedData: newSelectedData, error: null);
  }

  void setTimeType(TimeType type) {
    int defaultValue;
    switch (type) {
      case TimeType.minutes:
        defaultValue = 20;
        break;
      case TimeType.hours:
        defaultValue = 1;
        break;
      case TimeType.days:
        defaultValue = 1;
        break;
      case TimeType.weeks:
        defaultValue = 1;
        break;
    }

    state = state.copyWith(
      selectedTimeType: type,
      selectedTimeValue: defaultValue,
      error: null,
    );
  }

  void setTimeValue(int value) {
    state = state.copyWith(selectedTimeValue: value, error: null);
  }

  String _generateUniqueCode() {
    final random = Random();

    final letters = List.generate(
      3,
      (_) => String.fromCharCode(65 + random.nextInt(26)),
    ).join();

    final numbers = random.nextInt(1000).toString().padLeft(3, '0');

    return '$letters$numbers';
  }

  DateTime _calculateExpirationTime() {
    final now = DateTime.now().toUtc();
    switch (state.selectedTimeType) {
      case TimeType.minutes:
        return now.add(Duration(minutes: state.selectedTimeValue));
      case TimeType.hours:
        return now.add(Duration(hours: state.selectedTimeValue));
      case TimeType.days:
        return now.add(Duration(days: state.selectedTimeValue));
      case TimeType.weeks:
        return now.add(Duration(days: state.selectedTimeValue * 7));
    }
  }

  Future<void> shareData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final shareCode = _generateUniqueCode();
      final expiresAt = _calculateExpirationTime();
      final medicalData = await _fetchMedicalData();
      final encodedData = await _encodeDataWithPrivateKey(medicalData);
      await _uploadToCloud(shareCode, encodedData, expiresAt);
      state = state.copyWith(
        generatedCode: shareCode,
        isLoading: false,
        isSuccess: true,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<MedicalHistoryModel> _fetchMedicalData() async {
    final person = await _personRepository.getPersonById(personId);
    if (person == null) {
      throw Exception('Persona no encontrada');
    }
    final chronicConditions = state.selectedData['chronicConditions']!
        ? await _chronicConditionRepository.getAllByPatientId(patientId)
        : null;
    final emergencyContacts = state.selectedData['emergencyContacts']!
        ? await _emergencyContactRepository.getAllByPatientId(patientId)
        : null;
    final familyHistories = state.selectedData['familyHistories']!
        ? await _familyHistoryRepository.getAllByPatientId(patientId)
        : null;
    final hospitalizations = state.selectedData['hospitalizations']!
        ? await _hospitalizationRepository.getAllByPatientId(patientId)
        : null;
    final insurances = state.selectedData['insurances']!
        ? await _insuranceRepository.getAllByPatientId(patientId)
        : null;
    final lifestyles = state.selectedData['lifestyles']!
        ? await _lifestyleRepository.getByPatientId(patientId)
        : null;
    final medicalAllergies = state.selectedData['medicalAllergies']!
        ? await _medicalAllergyRepository.getAllByPatientId(patientId)
        : null;
    final medicalCriticalInfo = state.selectedData['medicalCriticalInfo']!
        ? await _medicalCriticalInfoRepository.getByPatientId(patientId)
        : null;
    final surgicalHistories = state.selectedData['surgicalHistories']!
        ? await _surgicalHistoryRepository.getAllByPatientId(patientId)
        : null;
    final vaccinations = state.selectedData['vaccinations']!
        ? await _vaccinationRepository.getAllByPatientId(patientId)
        : null;
    return MedicalHistoryModel(
      person: person,
      patientId: patientId,
      timeAccess: _calculateExpirationTime(),
      shareCode: state.generatedCode,
      sharedData: null,
      chronicConditions: state.selectedData['chronicConditions']!
          ? chronicConditions
          : null,
      emergencyContacts: state.selectedData['emergencyContacts']!
          ? emergencyContacts
          : null,
      familyHistories: state.selectedData['familyHistories']!
          ? familyHistories
          : null,
      hospitalizations: state.selectedData['hospitalizations']!
          ? hospitalizations
          : null,
      insurances: state.selectedData['insurances']! ? insurances : null,
      lifestyles: state.selectedData['lifestyles']! ? lifestyles : null,
      medicalAllergies: state.selectedData['medicalAllergies']!
          ? medicalAllergies
          : null,
      medicalCriticalInfo: state.selectedData['medicalCriticalInfo']!
          ? medicalCriticalInfo
          : null,
      surgicalHistories: state.selectedData['surgicalHistories']!
          ? surgicalHistories
          : null,
      vaccinations: state.selectedData['vaccinations']! ? vaccinations : null,
    );
  }

  Future<String> _encodeDataWithPrivateKey(MedicalHistoryModel data) async {
    return EncryptionService.encodeDataWithPrivateKey(data);
  }

  Future<void> _uploadToCloud(
    String shareCode,
    String encodedData,
    DateTime expiresAt,
  ) async {
    try {
      final session = SharingSessionModel(
        id: 0,
        patientId: patientId,
        shareCode: shareCode,
        sharedData: encodedData,
        expiresAt: expiresAt,
        createdAt: DateTime.now().toUtc(),
        isActive: true,
      );
      await _sharingSessionRepository.createSharingSession(session);
    } catch (e) {
      throw Exception('Error al subir datos al servidor: $e');
    }
  }

  void reset() {
    state = ShareDataState(
      selectedData: {
        'personalData': true,
        'chronicConditions': false,
        'emergencyContacts': false,
        'familyHistories': false,
        'hospitalizations': false,
        'insurances': false,
        'lifestyles': false,
        'medicalAllergies': false,
        'medicalCriticalInfo': false,
        'surgicalHistories': false,
        'vaccinations': false,
      },
    );
  }
}

final shareDataProvider =
    StateNotifierProvider.family<
      ShareDataNotifier,
      ShareDataState,
      PatientPersonKey
    >((ref, key) {
      return ShareDataNotifier(key.patientId, key.personId);
    });

class PatientPersonKey {
  final int patientId;
  final int personId;

  const PatientPersonKey(this.patientId, this.personId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientPersonKey &&
          runtimeType == other.runtimeType &&
          patientId == other.patientId &&
          personId == other.personId;

  @override
  int get hashCode => patientId.hashCode ^ personId.hashCode;
}
