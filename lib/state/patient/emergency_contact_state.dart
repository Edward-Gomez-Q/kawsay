import 'package:project_3_kawsay/model/patient/emergency_contact.dart';

class EmergencyContactState {
  final List<EmergencyContact> contacts;
  final bool isLoading;
  final String? error;

  EmergencyContactState({
    this.contacts = const [],
    this.isLoading = false,
    this.error,
  });

  EmergencyContactState copyWith({
    List<EmergencyContact>? contacts,
    bool? isLoading,
    String? error,
  }) {
    return EmergencyContactState(
      contacts: contacts ?? this.contacts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
