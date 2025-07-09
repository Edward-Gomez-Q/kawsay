import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/common/sign_up_notifier.dart';
import 'package:project_3_kawsay/presentation/common/widgets/custom_form_fields.dart';
import 'package:project_3_kawsay/state/common/sign_up_personal_state.dart';

class PersonalDataStep extends ConsumerWidget {
  const PersonalDataStep({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personForm = ref.watch(signUpPersonalProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: personForm.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        CustomFormFields.buildTextField(
                          context: context,
                          controller: personForm.namesController,
                          label: 'Nombres',
                          icon: Icons.person,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tus nombres';
                            }
                            return null;
                          },
                          isNumeric: false,
                        ),
                        CustomFormFields.buildTextField(
                          context: context,
                          controller: personForm.firstLastNameController,
                          label: 'Primer Apellido',
                          icon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu primer apellido';
                            }
                            return null;
                          },
                          isNumeric: false,
                        ),
                        CustomFormFields.buildTextField(
                          context: context,
                          controller: personForm.secondLastNameController,
                          label: 'Segundo Apellido',
                          icon: Icons.person_outline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu segundo apellido';
                            }
                            return null;
                          },
                          isNumeric: false,
                        ),
                        CustomFormFields.buildTextField(
                          context: context,
                          controller: personForm.documentIdController,
                          label: 'Cédula de Identidad',
                          icon: Icons.credit_card,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu cédula de identidad';
                            }
                            return null;
                          },
                          isNumeric: true,
                        ),
                        CustomFormFields.buildTextField(
                          context: context,
                          controller: personForm.personalPhoneNumberController,
                          label: 'Teléfono Personal',
                          icon: Icons.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu teléfono personal';
                            }
                            return null;
                          },
                          isNumeric: true,
                        ),
                        CustomFormFields.buildDropdownFromMap(
                          context: context,
                          selectedKey: personForm.genderController,
                          items: personForm.genderOptions,
                          label: 'Género',
                          icon: Icons.person_2_outlined,
                          onChanged: (value) {
                            personForm.copyWith(genderController: value);
                          },
                        ),

                        CustomFormFields.buildDateField(
                          context: context,
                          selectedDate: personForm.birthDate,
                          label: 'Fecha de Nacimiento',
                          icon: Icons.calendar_today,
                          onTap: () => _selectBirthDate(context, ref),
                        ),
                        CustomFormFields.buildDropdownFromList(
                          context: context,
                          selectedValue: personForm.countryController,
                          items: personForm.countries,
                          label: 'País',
                          icon: Icons.flag,
                          onChanged: (value) {
                            personForm.copyWith(countryController: value);
                          },
                        ),

                        CustomFormFields.buildTextField(
                          context: context,
                          controller: personForm.cityController,
                          label: 'Ciudad',
                          icon: Icons.location_city,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu ciudad';
                            }
                            return null;
                          },
                        ),
                        CustomFormFields.buildTextField(
                          context: context,
                          controller: personForm.neighborhoodController,
                          label: 'Zona',
                          icon: Icons.home,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu Zona';
                            }
                            return null;
                          },
                        ),
                        CustomFormFields.buildTextField(
                          context: context,
                          controller: personForm.addressController,
                          label: 'Dirección',
                          icon: Icons.map,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu dirección';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (personForm.formKey.currentState!.validate()) {
                  final personalData = personForm.copyWith(
                    namesController: personForm.namesController,
                    firstLastNameController: personForm.firstLastNameController,
                    secondLastNameController:
                        personForm.secondLastNameController,
                    documentIdController: personForm.documentIdController,
                    personalPhoneNumberController:
                        personForm.personalPhoneNumberController,
                    genderController: personForm.genderController,
                    birthDate: personForm.birthDate,
                    countryController: personForm.countryController,
                    cityController: personForm.cityController,
                    neighborhoodController: personForm.neighborhoodController,
                    addressController: personForm.addressController,
                  );
                  ref
                      .read(signUpProvider.notifier)
                      .updatePersonalDataFromPersonState(personalData);
                  ref.read(signUpProvider.notifier).nextStep();
                }
              },
              child: const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectBirthDate(BuildContext context, WidgetRef ref) async {
    final currentBirthDate = ref.read(signUpPersonalProvider).birthDate;
    final personForm = ref.watch(signUpPersonalProvider);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentBirthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != currentBirthDate) {
      ref.read(signUpPersonalProvider.notifier).state = personForm.copyWith(
        birthDate: picked,
      );
    }
  }
}
