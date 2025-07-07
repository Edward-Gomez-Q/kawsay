import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/common/sign_up_notifier.dart';
import 'package:project_3_kawsay/model/common/person_model.dart';

class SignUpPersonalState {
  final TextEditingController namesController;
  final TextEditingController firstLastNameController;
  final TextEditingController secondLastNameController;
  final TextEditingController documentIdController;
  final TextEditingController personalPhoneNumberController;

  final String genderController;
  final Map<String, String> genderOptions;

  final DateTime birthDate;

  final String countryController;
  final List<String> countries;

  final TextEditingController cityController;
  final TextEditingController neighborhoodController;
  final TextEditingController addressController;

  final GlobalKey<FormState> formKey;

  SignUpPersonalState({
    required this.namesController,
    required this.firstLastNameController,
    required this.secondLastNameController,
    required this.documentIdController,
    required this.personalPhoneNumberController,
    required this.genderController,
    required this.genderOptions,
    required this.birthDate,
    required this.countryController,
    required this.countries,
    required this.cityController,
    required this.neighborhoodController,
    required this.addressController,
    required this.formKey,
  });

  factory SignUpPersonalState.empty(PersonModel? personalData) {
    return SignUpPersonalState(
      namesController: TextEditingController(text: personalData?.names ?? ''),
      firstLastNameController: TextEditingController(
        text: personalData?.firstLastName ?? '',
      ),
      secondLastNameController: TextEditingController(
        text: personalData?.secondLastName ?? '',
      ),
      documentIdController: TextEditingController(
        text: personalData?.documentId ?? '',
      ),
      personalPhoneNumberController: TextEditingController(
        text: personalData?.personalPhoneNumber ?? '',
      ),
      genderController: personalData?.gender ?? 'M',
      genderOptions: {'M': 'Masculino', 'F': 'Femenino', 'O': 'Otro'},
      birthDate:
          personalData?.birthDate ??
          DateTime.now().subtract(const Duration(days: 365 * 25)),
      countryController: personalData?.country ?? 'Bolivia',
      countries: [
        'Afganistán',
        'Alemania',
        'Arabia Saudita',
        'Argentina',
        'Australia',
        'Austria',
        'Bélgica',
        'Bolivia',
        'Brasil',
        'Canadá',
        'Chile',
        'China',
        'Colombia',
        'Corea del Sur',
        'Costa Rica',
        'Cuba',
        'Dinamarca',
        'Ecuador',
        'Egipto',
        'El Salvador',
        'Emiratos Árabes Unidos',
        'España',
        'Estados Unidos',
        'Estonia',
        'Filipinas',
        'Finlandia',
        'Francia',
        'Grecia',
        'Guatemala',
        'Honduras',
        'Hungría',
        'India',
        'Indonesia',
        'Irlanda',
        'Islandia',
        'Israel',
        'Italia',
        'Japón',
        'Kazajistán',
        'Letonia',
        'Lituania',
        'Malasia',
        'México',
        'Mónaco',
        'Nicaragua',
        'Noruega',
        'Nueva Zelanda',
        'Países Bajos',
        'Panamá',
        'Paraguay',
        'Perú',
        'Polonia',
        'Portugal',
        'Puerto Rico',
        'Qatar',
        'Reino Unido',
        'República Checa',
        'República Dominicana',
        'Rumania',
        'Rusia',
        'Singapur',
        'Sudáfrica',
        'Suecia',
        'Suiza',
        'Tailandia',
        'Turquía',
        'Ucrania',
        'Uruguay',
        'Venezuela',
        'Vietnam',
      ],
      cityController: TextEditingController(text: personalData?.city ?? ''),
      neighborhoodController: TextEditingController(
        text: personalData?.neighborhood ?? '',
      ),
      addressController: TextEditingController(
        text: personalData?.address ?? '',
      ),
      formKey: GlobalKey<FormState>(),
    );
  }

  SignUpPersonalState copyWith({
    TextEditingController? namesController,
    TextEditingController? firstLastNameController,
    TextEditingController? secondLastNameController,
    TextEditingController? documentIdController,
    TextEditingController? personalPhoneNumberController,
    String? genderController,
    Map<String, String>? genderOptions,
    DateTime? birthDate,
    String? countryController,
    List<String>? countries,
    TextEditingController? cityController,
    TextEditingController? neighborhoodController,
    TextEditingController? addressController,
    GlobalKey<FormState>? formKey,
  }) {
    return SignUpPersonalState(
      namesController: namesController ?? this.namesController,
      firstLastNameController:
          firstLastNameController ?? this.firstLastNameController,
      secondLastNameController:
          secondLastNameController ?? this.secondLastNameController,
      documentIdController: documentIdController ?? this.documentIdController,
      personalPhoneNumberController:
          personalPhoneNumberController ?? this.personalPhoneNumberController,
      genderController: genderController ?? this.genderController,
      genderOptions: genderOptions ?? this.genderOptions,
      birthDate: birthDate ?? this.birthDate,
      countryController: countryController ?? this.countryController,
      countries: countries ?? this.countries,
      cityController: cityController ?? this.cityController,
      neighborhoodController:
          neighborhoodController ?? this.neighborhoodController,
      addressController: addressController ?? this.addressController,
      formKey: formKey ?? this.formKey,
    );
  }

  void dispose() {
    namesController.dispose();
    firstLastNameController.dispose();
    secondLastNameController.dispose();
    documentIdController.dispose();
    personalPhoneNumberController.dispose();
    cityController.dispose();
    neighborhoodController.dispose();
    addressController.dispose();
  }
}

final signUpPersonalProvider = StateProvider<SignUpPersonalState>((ref) {
  final personalData = ref.watch(signUpProvider).registrationData?.personalData;
  return SignUpPersonalState.empty(personalData);
});
