import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/data/supabase/common/auth_user_repository_sp.dart';
import 'package:project_3_kawsay/data/supabase/common/doctor_repository_sp.dart';
import 'package:project_3_kawsay/data/supabase/common/person_repository_sp.dart';
import 'package:project_3_kawsay/data/supabase/common/role_user_reposiotry_sp.dart';
import 'package:project_3_kawsay/data/supabase/patient/patient_repository_sp.dart';
import 'package:project_3_kawsay/model/common/person_model.dart';
import 'package:project_3_kawsay/model/common/user_model.dart';
import 'package:project_3_kawsay/model/doctor/doctor_model.dart';
import 'package:project_3_kawsay/model/patient/patient.dart';
import 'package:project_3_kawsay/state/common/sign_up_personal_state.dart';
import 'package:project_3_kawsay/state/common/user_sign_up_data_state.dart';
import 'package:project_3_kawsay/state/common/sign_up_state.dart';

class SignUpNotifier extends StateNotifier<SignUpState> {
  final PersonRepositorySp _personRepository = PersonRepositorySp();
  final AuthUserRepositorySp _authUserRepository = AuthUserRepositorySp();
  final DoctorRepositorySp _doctorRepository = DoctorRepositorySp();
  final RoleUserReposiotrySp _roleUserRepository = RoleUserReposiotrySp();
  final PatientRepositorySp _patientRepository = PatientRepositorySp();
  SignUpNotifier() : super(SignUpState());
  void setUserType(UserType userType) {
    state = state.copyWith(
      registrationData: UserSignUpData(
        userType: userType,
        personalData: PersonModel(
          id: 0,
          names: '',
          firstLastName: '',
          secondLastName: '',
          documentId: '',
          personalPhoneNumber: '',
          accessTypeId: 4,
          gender: 'M',
          birthDate: DateTime.now(),
          country: 'Bolivia',
          city: '',
          neighborhood: '',
          address: '',
        ),
        userCredentials: UserModel(id: 0, email: '', password: '', personId: 0),
        medicalData: userType == UserType.doctor
            ? DoctorModel(
                id: 0,
                personId: 0,
                specialization: '',
                medicalCollege: '',
                yearsExperience: 0,
              )
            : null,
      ),
      currentStep: 0,
      isLoading: false,
      error: null,
    );
  }

  void updatePersonalData(PersonModel personalData) {
    if (state.registrationData != null) {
      state = state.copyWith(
        registrationData: state.registrationData!.copyWith(
          personalData: personalData,
        ),
      );
    }
  }

  void updatePersonalDataFromPersonState(SignUpPersonalState personalData) {
    if (state.registrationData != null) {
      state = state.copyWith(
        registrationData: state.registrationData!.copyWith(
          personalData: PersonModel(
            id: 0,
            names: personalData.namesController.text,
            firstLastName: personalData.firstLastNameController.text,
            secondLastName: personalData.secondLastNameController.text,
            documentId: personalData.documentIdController.text,
            personalPhoneNumber:
                personalData.personalPhoneNumberController.text,
            accessTypeId: 4,
            gender: personalData.genderController,
            birthDate: personalData.birthDate,
            country: personalData.countryController,
            city: personalData.cityController.text,
            neighborhood: personalData.neighborhoodController.text,
            address: personalData.addressController.text,
          ),
        ),
      );
    }
  }

  void updateMedicalData(DoctorModel medicalData) {
    if (state.registrationData != null) {
      state = state.copyWith(
        registrationData: state.registrationData!.copyWith(
          medicalData: medicalData,
        ),
      );
    }
  }

  void updateUserCredentials(UserModel userCredentials) {
    if (state.registrationData != null) {
      state = state.copyWith(
        registrationData: state.registrationData!.copyWith(
          userCredentials: userCredentials,
        ),
      );
    }
  }

  void nextStep() {
    if (state.currentStep < _getMaxSteps()) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= _getMaxSteps()) {
      state = state.copyWith(currentStep: step);
    }
  }

  int _getMaxSteps() {
    if (state.registrationData?.userType == UserType.doctor) {
      return 3;
    }
    return 2;
  }

  Future<void> completeRegistration() async {
    if (state.registrationData == null) {
      throw Exception('No hay datos de registro disponibles');
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      await _createUser(state.registrationData!);
      state = state.copyWith(isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> _createUser(UserSignUpData data) async {
    // Validaciones de negocio
    if (data.userCredentials.email.isEmpty ||
        data.userCredentials.password.isEmpty) {
      throw Exception('Email y contraseña son requeridos');
    }

    // Crear persona asociada al usuario
    final person = await createPerson(data.personalData);

    // Crear usuario en la base de datos
    final user = await _authUserRepository.createUser(
      data.userCredentials,
      person.id,
    );
    if (user == null) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al crear el usuario',
      );
    } else {
      if (data.userType == UserType.doctor && data.medicalData != null) {
        await _doctorRepository.createDoctor(data.medicalData!, person.id);
        await _roleUserRepository.createRoleUser(1, user.id);
      } else {
        final newPatient = Patient(id: 0, personId: person.id);
        await _patientRepository.createPatient(newPatient);
        await _roleUserRepository.createRoleUser(2, user.id);
      }
      state = state.copyWith(
        isLoading: false,
        error: null,
        registrationData: data.copyWith(
          userCredentials: user,
          personalData: person,
        ),
      );
    }
  }

  Future<PersonModel> createPerson(PersonModel person) async {
    _validatePersonData(person);
    final existingPerson = await _personRepository.getPersonByDocumentId(
      person.documentId,
    );
    if (existingPerson != null) {
      throw Exception(
        'Ya existe una persona con el documento: ${person.documentId}',
      );
    }
    return await _personRepository.createPerson(person);
  }

  void _validatePersonData(PersonModel person) {
    if (person.names.trim().isEmpty) {
      throw Exception('El nombre es requerido');
    }
    if (person.firstLastName.trim().isEmpty) {
      throw Exception('El primer apellido es requerido');
    }
    if (person.documentId.trim().isEmpty) {
      throw Exception('El documento es requerido');
    }
    if (person.personalPhoneNumber.trim().isEmpty) {
      throw Exception('El teléfono es requerido');
    }
    if (person.gender.trim().isEmpty) {
      throw Exception('El género es requerido');
    }
    if (person.country.trim().isEmpty) {
      throw Exception('El país es requerido');
    }
    if (person.city.trim().isEmpty) {
      throw Exception('La ciudad es requerida');
    }
    if (person.address.trim().isEmpty) {
      throw Exception('La dirección es requerida');
    }
    if (!_isValidPhoneNumber(person.personalPhoneNumber)) {
      throw Exception('Formato de teléfono inválido');
    }
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    return phoneNumber.length >= 7 && phoneNumber.length <= 15;
  }

  void resetRegistration() {
    state = SignUpState();
  }
}

final signUpProvider = StateNotifierProvider<SignUpNotifier, SignUpState>(
  (ref) => SignUpNotifier(),
);
