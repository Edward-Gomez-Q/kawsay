import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/common/sign_up_notifier.dart';
import 'package:project_3_kawsay/model/doctor/doctor_model.dart';
import 'package:project_3_kawsay/presentation/common/widgets/custom_form_fields.dart';
import 'package:project_3_kawsay/state/common/sign_up_doctor_state.dart';

class DoctorDataStep extends ConsumerWidget {
  const DoctorDataStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorForm = ref.watch(signUpDoctorProvider);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: doctorForm.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Datos del Doctor',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 16,
                      children: [
                        CustomFormFields.buildTextField(
                          context: context,
                          controller: doctorForm.specialization,
                          label: 'Especialización',
                          icon: Icons.medical_services,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa tu especialización';
                            }
                            return null;
                          },
                        ),
                        CustomFormFields.buildTextField(
                          context: context,
                          controller: doctorForm.medicalCollege,
                          label: 'Colegio Médico',
                          icon: Icons.school,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa el nombre de tu colegio médico';
                            }
                            return null;
                          },
                        ),
                        CustomFormFields.buildTextField(
                          context: context,
                          controller: doctorForm.yearsExperience,
                          label: 'Años de Experiencia',
                          icon: Icons.work,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa tus años de experiencia';
                            }
                            final years = int.tryParse(value);
                            if (years == null || years < 0) {
                              return 'Por favor, ingresa un número válido de años';
                            }
                            return null;
                          },
                          isNumeric: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (doctorForm.formKey.currentState!.validate()) {
                  final medicalData = DoctorModel(
                    id: 0,
                    personId: 0,
                    specialization: doctorForm.specialization.text,
                    medicalCollege: doctorForm.medicalCollege.text,
                    yearsExperience: int.parse(doctorForm.yearsExperience.text),
                  );
                  ref
                      .read(signUpProvider.notifier)
                      .updateMedicalData(medicalData);
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
}
