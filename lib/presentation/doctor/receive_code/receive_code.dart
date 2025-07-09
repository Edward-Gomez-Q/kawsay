import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/common/auth_notifier.dart';
import 'package:project_3_kawsay/application/common/navigation_service.dart';
import 'package:project_3_kawsay/application/doctor/receive_code_notifier.dart';
import 'package:project_3_kawsay/model/common/medical_consultation_model.dart';
import 'package:project_3_kawsay/model/patient/chronic_condition.dart';
import 'package:project_3_kawsay/model/patient/emergency_contact.dart';
import 'package:project_3_kawsay/model/patient/family_history.dart';
import 'package:project_3_kawsay/model/patient/hospitalization.dart';
import 'package:project_3_kawsay/model/patient/insurance.dart';
import 'package:project_3_kawsay/model/patient/lifestyle.dart';
import 'package:project_3_kawsay/model/patient/medical_allergy.dart';
import 'package:project_3_kawsay/model/patient/surgical_history.dart';
import 'package:project_3_kawsay/model/patient/vaccination.dart';
import 'package:project_3_kawsay/presentation/doctor/receive_code/create_consultation_dialog.dart';
import 'package:project_3_kawsay/state/doctor/receive_code_state.dart';

class ReceiveCode extends ConsumerStatefulWidget {
  const ReceiveCode({super.key});

  @override
  ConsumerState<ReceiveCode> createState() => _ReceiveCodeState();
}

class _ReceiveCodeState extends ConsumerState<ReceiveCode> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(receiveCodeProvider);
    final notifier = ref.read(receiveCodeProvider.notifier);
    final navigation = ref.read(navigationServiceProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (state.status == ReceiveCodeStatus.initial ||
                  state.status == ReceiveCodeStatus.loading ||
                  state.status == ReceiveCodeStatus.error)
                _buildCodeInput(context, ref, state, notifier, navigation),

              if (state.status == ReceiveCodeStatus.success)
                Expanded(
                  child: _buildMedicalDataView(
                    context,
                    ref,
                    state,
                    notifier,
                    navigation,
                  ),
                ),

              if (state.status == ReceiveCodeStatus.expired)
                _buildExpiredView(context, state, notifier, navigation),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCodeInput(
    BuildContext context,
    WidgetRef ref,
    ReceiveCodeState state,
    ReceiveCodeNotifier notifier,
    NavigationService navigation,
  ) {
    final themeData = Theme.of(context);
    final authState = ref.watch(authProvider);
    final codeController = TextEditingController();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: themeData.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'Ingresa el código compartido por el paciente',
                  style: themeData.textTheme.titleLarge?.copyWith(
                    color: themeData.colorScheme.onPrimaryContainer,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'El código te dará acceso temporal al historial médico',
                  style: themeData.textTheme.bodyMedium?.copyWith(
                    color: themeData.colorScheme.onPrimaryContainer.withValues(
                      alpha: 0.8,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: codeController,
            decoration: InputDecoration(
              labelText: 'Código de acceso',
              hintText: 'Ej: ABC123DEF',
              prefixIcon: const Icon(Icons.vpn_key),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            textCapitalization: TextCapitalization.characters,
            enabled: state.status != ReceiveCodeStatus.loading,
          ),

          if (state.status == ReceiveCodeStatus.error)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: themeData.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: themeData.colorScheme.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      state.errorMessage ?? 'Error desconocido',
                      style: TextStyle(color: themeData.colorScheme.error),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: state.status == ReceiveCodeStatus.loading
                    ? null
                    : () => notifier.verifyAndAccessCode(
                        authState.doctor!.id,
                        codeController.text.trim(),
                      ),
                child: state.status == ReceiveCodeStatus.loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Acceder'),
              ),
              OutlinedButton(
                onPressed: () {
                  navigation.goToHomeDoctor();
                  notifier.reset();
                },
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalDataView(
    BuildContext context,
    WidgetRef ref,
    ReceiveCodeState state,
    ReceiveCodeNotifier notifier,
    NavigationService navigation,
  ) {
    final themeData = Theme.of(context);

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: themeData.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.exit_to_app),
                    color: themeData.colorScheme.onPrimaryContainer,
                    onPressed: () {
                      notifier.reset();
                      navigation.goToHomeDoctor();
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${state.medicalHistory?.person.names} ${state.medicalHistory?.person.firstLastName}',
                          style: themeData.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: themeData.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          'Sesión activa',
                          style: themeData.textTheme.bodyMedium?.copyWith(
                            color: themeData.colorScheme.onPrimaryContainer
                                .withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (state.timeRemaining != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: themeData.colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${state.timeRemaining!.inSeconds}s restantes',
                        style: TextStyle(
                          color: themeData.colorScheme.onPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Expanded(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(
                      icon: const Icon(Icons.medical_information),
                      text: 'Historial Médico',
                    ),
                    Tab(
                      icon: const Icon(Icons.assignment),
                      text: 'Consultas (${state.consultations.length})',
                    ),
                  ],
                ),

                Expanded(
                  child: TabBarView(
                    children: [
                      _buildMedicalHistoryTab(context, state),
                      _buildConsultationsTab(context, ref, state, notifier),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicalHistoryTab(BuildContext context, ReceiveCodeState state) {
    final medicalHistory = state.medicalHistory!;

    return ListView(
      padding: const EdgeInsets.all(16),

      children: [
        _buildInfoCard(context, 'Información Personal', [
          InfoRow('Nombres', medicalHistory.person.names),
          InfoRow(
            'Apellidos',
            '${medicalHistory.person.firstLastName} ${medicalHistory.person.secondLastName}',
          ),
          InfoRow('Documento', medicalHistory.person.documentId),
          InfoRow(
            'Fecha de Nacimiento',
            _formatDate(medicalHistory.person.birthDate),
          ),
          InfoRow('Teléfono', medicalHistory.person.personalPhoneNumber),
          InfoRow(
            'Género',
            medicalHistory.person.gender == 'M' ? 'Masculino' : 'Femenino',
          ),
          InfoRow('País', medicalHistory.person.country),
          InfoRow('Ciudad', medicalHistory.person.city),
          InfoRow('Barrio', medicalHistory.person.neighborhood),
          InfoRow('Dirección', medicalHistory.person.address),
        ]),

        if (medicalHistory.medicalCriticalInfo != null)
          _buildInfoCard(context, 'Información Crítica', [
            InfoRow(
              'Tipo de Sangre',
              medicalHistory.medicalCriticalInfo!.bloodType,
            ),
            if (medicalHistory.person.gender == 'F')
              InfoRow(
                'Embarazada',
                medicalHistory.medicalCriticalInfo!.pregnant ? 'Sí' : 'No',
              ),
            InfoRow(
              'Tiene Implantes',
              medicalHistory.medicalCriticalInfo!.hasImplants ? 'Sí' : 'No',
            ),
            if (medicalHistory.medicalCriticalInfo!.notes?.isNotEmpty == true)
              InfoRow('Notas', medicalHistory.medicalCriticalInfo!.notes!),
          ]),

        if (medicalHistory.medicalAllergies?.isNotEmpty == true)
          _buildAllergyCard(context, medicalHistory.medicalAllergies!),

        if (medicalHistory.chronicConditions?.isNotEmpty == true)
          _buildChronicConditionsCard(
            context,
            medicalHistory.chronicConditions!,
          ),

        if (medicalHistory.vaccinations?.isNotEmpty == true)
          _buildVaccinationsCard(context, medicalHistory.vaccinations!),

        if (medicalHistory.surgicalHistories?.isNotEmpty == true)
          _buildSurgicalHistoryCard(context, medicalHistory.surgicalHistories!),

        if (medicalHistory.hospitalizations?.isNotEmpty == true)
          _buildHospitalizationsCard(context, medicalHistory.hospitalizations!),

        if (medicalHistory.familyHistories?.isNotEmpty == true)
          _buildFamilyHistoryCard(context, medicalHistory.familyHistories!),

        if (medicalHistory.lifestyles != null)
          _buildLifestyleCard(context, medicalHistory.lifestyles!),

        if (medicalHistory.insurances?.isNotEmpty == true)
          _buildInsurancesCard(context, medicalHistory.insurances!),

        if (medicalHistory.emergencyContacts?.isNotEmpty == true)
          _buildEmergencyContactsCard(
            context,
            medicalHistory.emergencyContacts!,
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _buildAllergyCard(
    BuildContext context,
    List<MedicalAllergy> allergies,
  ) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Alergias Médicas',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...allergies.map(
              (allergy) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      allergy.allergen,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Origen: ${allergy.allergenFrom}'),
                    if (allergy.reaction?.isNotEmpty == true)
                      Text('Reacción: ${allergy.reaction}'),
                    if (allergy.severity?.isNotEmpty == true)
                      Text(
                        'Severidad: ${allergy.severity}',
                        style: TextStyle(
                          color: allergy.severity?.toLowerCase() == 'alta'
                              ? Colors.red
                              : Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Card para condiciones crónicas
  Widget _buildChronicConditionsCard(
    BuildContext context,
    List<ChronicCondition> conditions,
  ) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.medical_services, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Condiciones Crónicas',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...conditions.map(
              (condition) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            condition.condition,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (condition.diagnosisDate != null)
                            Text(
                              'Diagnóstico: ${_formatDate(condition.diagnosisDate!)}',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: condition.controlled
                            ? Colors.green
                            : Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        condition.controlled ? 'Controlada' : 'No Controlada',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Card para vacunas
  Widget _buildVaccinationsCard(
    BuildContext context,
    List<Vaccination> vaccinations,
  ) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.vaccines, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Vacunas',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...vaccinations.map(
              (vaccine) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vaccine.vaccine,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Dosis: ${vaccine.dose}'),
                    Text('Fecha: ${_formatDate(vaccine.dateVaccine)}'),
                    Text('Institución: ${vaccine.institution}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Card para historial quirúrgico
  Widget _buildSurgicalHistoryCard(
    BuildContext context,
    List<SurgicalHistory> surgeries,
  ) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_hospital, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Historial Quirúrgico',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...surgeries.map(
              (surgery) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surgery.surgery,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Fecha: ${_formatDate(surgery.surgeryDate)}'),
                    if (surgery.complications)
                      Text(
                        'Complicaciones: ${surgery.noteComplications ?? 'Sí'}',
                        style: const TextStyle(color: Colors.red),
                      )
                    else
                      const Text(
                        'Sin complicaciones',
                        style: TextStyle(color: Colors.green),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Card para hospitalizaciones
  Widget _buildHospitalizationsCard(
    BuildContext context,
    List<Hospitalization> hospitalizations,
  ) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.hotel, color: Colors.purple, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Hospitalizaciones',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...hospitalizations.map(
              (hospitalization) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hospitalization.reason,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ingreso: ${_formatDate(hospitalization.admissionDate)}',
                    ),
                    Text('Alta: ${_formatDate(hospitalization.dischargeDate)}'),
                    Text(
                      'Duración: ${hospitalization.dischargeDate.difference(hospitalization.admissionDate).inDays} días',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Card para historial familiar
  Widget _buildFamilyHistoryCard(
    BuildContext context,
    List<FamilyHistory> familyHistories,
  ) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.family_restroom, color: Colors.brown, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Historial Familiar',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...familyHistories.map(
              (history) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.brown.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      history.condition,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Parentesco: ${history.relationship}'),
                    Text('Edad de inicio: ${history.ageOfOnset} años'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLifestyleCard(BuildContext context, Lifestyle lifestyle) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.directions_run, color: Colors.teal, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Estilo de Vida',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildInfoCard(context, 'Información Personal', [
                    InfoRow('Fuma', lifestyle.smokes ? 'Sí' : 'No'),
                    InfoRow(
                      'Consume Alcohol',
                      lifestyle.drinksAlcohol ? 'Sí' : 'No',
                    ),
                    if (lifestyle.drinksAlcohol)
                      InfoRow(
                        'Frecuencia Alcohol',
                        '${lifestyle.drinksAlcoholFrequencyPerMonth} veces/mes',
                      ),
                    InfoRow(
                      'Hace Ejercicio',
                      lifestyle.exercises ? 'Sí' : 'No',
                    ),
                    if (lifestyle.exercises)
                      InfoRow(
                        'Frecuencia Ejercicio',
                        '${lifestyle.exercisesFrequencyPerWeek} veces/semana',
                      ),
                    InfoRow('Horas de Sueño', '${lifestyle.sleepHours} horas'),
                    InfoRow('Tipo de Dieta', lifestyle.dietType),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Card para seguros
  Widget _buildInsurancesCard(
    BuildContext context,
    List<Insurance> insurances,
  ) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.security, color: Colors.indigo, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Seguros Médicos',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...insurances.map(
              (insurance) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      insurance.provider,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Póliza: ${insurance.policyNumber}'),
                    Text('Inicio: ${_formatDate(insurance.startDate)}'),
                    Text('Fin: ${_formatDate(insurance.endDate)}'),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: insurance.endDate.isAfter(DateTime.now())
                            ? Colors.green
                            : Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        insurance.endDate.isAfter(DateTime.now())
                            ? 'Activo'
                            : 'Expirado',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContactsCard(
    BuildContext context,
    List<EmergencyContact> contacts,
  ) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.contact_phone, color: Colors.pink, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Contactos de Emergencia',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...contacts.map(
              (contact) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            contact.fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (contact.isFamilyDoctor)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Médico de Familia',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Parentesco: ${contact.relationship}'),
                    Text('Teléfono: ${contact.phone}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultationsTab(
    BuildContext context,
    WidgetRef ref,
    ReceiveCodeState state,
    ReceiveCodeNotifier notifier,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () {
              _showCreateConsultationDialog(context, notifier);
            },
            icon: state.isCreatingConsultation
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.add),
            label: const Text('Nueva Consulta'),
          ),
        ),

        Expanded(
          child: state.consultations.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hay consultas registradas',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: state.consultations.length,
                  itemBuilder: (context, index) {
                    final consultation = state.consultations[index];
                    return _buildConsultationCard(context, consultation);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildConsultationCard(
    BuildContext context,
    MedicalConsultationModel consultation,
  ) {
    final themeData = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.medical_services,
                  color: themeData.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Consulta #${consultation.id}',
                    style: themeData.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildConsultationInfo(
              'Motivo de consulta',
              consultation.chiefComplaint,
            ),
            _buildConsultationInfo('Diagnóstico', consultation.diagnosis),
            _buildConsultationInfo(
              'Plan de tratamiento',
              consultation.treatmentPlan,
            ),
            if (consultation.observations.isNotEmpty)
              _buildConsultationInfo(
                'Observaciones',
                consultation.observations,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultationInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    List<InfoRow> rows,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...rows.map(
              (row) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        row.label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        row.value,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpiredView(
    BuildContext context,
    ReceiveCodeState state,
    ReceiveCodeNotifier notifier,
    NavigationService navigation,
  ) {
    final themeData = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.access_time, size: 64, color: themeData.colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'Código Expirado',
            style: themeData.textTheme.headlineSmall?.copyWith(
              color: themeData.colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'El código de acceso ha expirado. Solicita uno nuevo al paciente.',
            style: themeData.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              notifier.reset();
            },
            child: const Text('Volver'),
          ),
        ],
      ),
    );
  }

  void _showCreateConsultationDialog(
    BuildContext context,
    ReceiveCodeNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => CreateConsultationDialog(notifier: notifier),
    );
  }
}

class InfoRow {
  final String label;
  final String value;

  InfoRow(this.label, this.value);
}
