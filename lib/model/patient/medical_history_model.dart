import 'package:project_3_kawsay/model/common/person_model.dart';
import 'package:project_3_kawsay/model/patient/chronic_condition.dart';
import 'package:project_3_kawsay/model/patient/emergency_contact.dart';
import 'package:project_3_kawsay/model/patient/family_history.dart';
import 'package:project_3_kawsay/model/patient/hospitalization.dart';
import 'package:project_3_kawsay/model/patient/insurance.dart';
import 'package:project_3_kawsay/model/patient/lifestyle.dart';
import 'package:project_3_kawsay/model/patient/medical_allergy.dart';
import 'package:project_3_kawsay/model/patient/medical_critical_info.dart';
import 'package:project_3_kawsay/model/patient/surgical_history.dart';
import 'package:project_3_kawsay/model/patient/vaccination.dart';

class MedicalHistoryModel {
  final PersonModel person;
  final int patientId;
  final DateTime timeAccess;
  final String? shareCode;
  final String? sharedData;
  final List<ChronicCondition>? chronicConditions;
  final List<EmergencyContact>? emergencyContacts;
  final List<FamilyHistory>? familyHistories;
  final List<Hospitalization>? hospitalizations;
  final List<Insurance>? insurances;
  final Lifestyle? lifestyles;
  final List<MedicalAllergy>? medicalAllergies;
  final MedicalCriticalInfo? medicalCriticalInfo;
  final List<SurgicalHistory>? surgicalHistories;
  final List<Vaccination>? vaccinations;

  MedicalHistoryModel({
    required this.person,
    required this.patientId,
    required this.timeAccess,
    this.shareCode,
    this.sharedData,
    this.chronicConditions,
    this.emergencyContacts,
    this.familyHistories,
    this.hospitalizations,
    this.insurances,
    this.lifestyles,
    this.medicalAllergies,
    this.medicalCriticalInfo,
    this.surgicalHistories,
    this.vaccinations,
  });

  Map<String, dynamic> toMap() {
    return {
      'person': person.toMap(),
      'patientId': patientId,
      'timeAccess': timeAccess.toIso8601String(),
      'shareCode': shareCode,
      'sharedData': sharedData,
      'chronicConditions': chronicConditions?.map((e) => e.toMap()).toList(),
      'emergencyContacts': emergencyContacts?.map((e) => e.toMap()).toList(),
      'familyHistories': familyHistories?.map((e) => e.toMap()).toList(),
      'hospitalizations': hospitalizations?.map((e) => e.toMap()).toList(),
      'insurances': insurances?.map((e) => e.toMap()).toList(),
      'lifestyles': lifestyles?.toMap(),
      'medicalAllergies': medicalAllergies?.map((e) => e.toMap()).toList(),
      'medicalCriticalInfo': medicalCriticalInfo?.toMap(),
      'surgicalHistories': surgicalHistories?.map((e) => e.toMap()).toList(),
      'vaccinations': vaccinations?.map((e) => e.toMap()).toList(),
    };
  }

  static MedicalHistoryModel fromMap(Map<String, dynamic> map) {
    return MedicalHistoryModel(
      person: PersonModel.fromMap(map['person']),
      patientId: map['patientId'],
      timeAccess: DateTime.parse(map['timeAccess']),
      shareCode: map['shareCode'],
      sharedData: map['sharedData'],
      chronicConditions: (map['chronicConditions'] as List?)
          ?.map((e) => ChronicCondition.fromMap(e))
          .toList(),
      emergencyContacts: (map['emergencyContacts'] as List?)
          ?.map((e) => EmergencyContact.fromMap(e))
          .toList(),
      familyHistories: (map['familyHistories'] as List?)
          ?.map((e) => FamilyHistory.fromMap(e))
          .toList(),
      hospitalizations: (map['hospitalizations'] as List?)
          ?.map((e) => Hospitalization.fromMap(e))
          .toList(),
      insurances: (map['insurances'] as List?)
          ?.map((e) => Insurance.fromMap(e))
          .toList(),
      lifestyles: map['lifestyles'] != null
          ? Lifestyle.fromMap(map['lifestyles'])
          : null,
      medicalAllergies: (map['medicalAllergies'] as List?)
          ?.map((e) => MedicalAllergy.fromMap(e))
          .toList(),
      medicalCriticalInfo: map['medicalCriticalInfo'] != null
          ? MedicalCriticalInfo.fromMap(map['medicalCriticalInfo'])
          : null,
      surgicalHistories: (map['surgicalHistories'] as List?)
          ?.map((e) => SurgicalHistory.fromMap(e))
          .toList(),
      vaccinations: (map['vaccinations'] as List?)
          ?.map((e) => Vaccination.fromMap(e))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'MedicalHistoryModel{person: $person, patientId: $patientId, timeAccess: $timeAccess, shareCode: $shareCode, sharedData: $sharedData, chronicConditions: $chronicConditions, emergencyContacts: $emergencyContacts, familyHistories: $familyHistories, hospitalizations: $hospitalizations, insurances: $insurances, lifestyles: $lifestyles, medicalAllergies: $medicalAllergies, medicalCriticalInfo: $medicalCriticalInfo, surgicalHistories: $surgicalHistories, vaccinations: $vaccinations}';
  }
}
