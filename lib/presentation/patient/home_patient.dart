import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/common/auth_notifier.dart';
import 'package:project_3_kawsay/application/common/navigation_service.dart';
import 'package:project_3_kawsay/application/core/theme_notifier.dart';
import 'package:project_3_kawsay/application/patient/patient_screens_notifier.dart';
import 'package:project_3_kawsay/data/sqflite/patient/db/database_helper.dart';
import 'package:project_3_kawsay/model/common/person_model.dart';
import 'package:project_3_kawsay/presentation/patient/medical_history/chronic_condition_patient.dart';
import 'package:project_3_kawsay/presentation/patient/medical_history/emergency_contact_patient.dart';
import 'package:project_3_kawsay/presentation/patient/medical_history/family_history_patient.dart';
import 'package:project_3_kawsay/presentation/patient/medical_history/hospitalization_patient.dart';
import 'package:project_3_kawsay/presentation/patient/medical_history/insurance_patient.dart';
import 'package:project_3_kawsay/presentation/patient/medical_history/lifestyle_patient.dart';
import 'package:project_3_kawsay/presentation/patient/medical_history/medical_allergy_patient.dart';
import 'package:project_3_kawsay/presentation/patient/medical_history/medical_critical_info_patient.dart';
import 'package:project_3_kawsay/presentation/patient/medical_history/surgical_history_patient.dart';
import 'package:project_3_kawsay/presentation/patient/medical_history/vaccination_patient.dart';
import 'package:project_3_kawsay/presentation/patient/screens/diagnostics_patient_screen.dart';
import 'package:project_3_kawsay/presentation/patient/screens/home_screen_patient.dart';
import 'package:project_3_kawsay/presentation/patient/screens/medical_history_patient.dart';
import 'package:project_3_kawsay/presentation/patient/screens/profile_patient.dart';
import 'package:project_3_kawsay/presentation/patient/screens/share_codes_patient_screen.dart';
import 'package:project_3_kawsay/presentation/patient/screens/share_data_patient.dart';
import 'package:project_3_kawsay/state/patient/patient_screens_state.dart';

class HomePatient extends ConsumerStatefulWidget {
  const HomePatient({super.key});

  @override
  ConsumerState<HomePatient> createState() => _HomePatientState();
}

class _HomePatientState extends ConsumerState<HomePatient> {
  late final int patientId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final id = ref.read(
        authProvider.select((state) => state.patientId?.id ?? 0),
      );
      if (id != 0) {
        patientId = id;
        await DatabaseHelper().syncPatientIfNeeded(patientId);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigation = ref.read(navigationServiceProvider);
    final authMethods = ref.read(authProvider.notifier);
    final themeNotifier = ref.read(themeProvider.notifier);
    final PersonModel? personModel = ref.watch(
      authProvider.select((state) => state.person),
    );
    final int patientId = ref.watch(
      authProvider.select((state) => state.patientId?.id ?? 0),
    );
    final int personId = ref.watch(
      authProvider.select((state) => state.person?.id ?? 0),
    );

    final patientScreensState = ref.watch(patientScreensProvider);

    return Scaffold(
      appBar: _buildAppBar(
        context,
        authMethods,
        navigation,
        personModel,
        themeNotifier,
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: _buildCurrentStep(patientScreensState, patientId, personId),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBottomNavItem(
                  context,
                  Icons.home,
                  'Inicio',
                  patientScreensState,
                  onTap: () {
                    ref.read(patientScreensProvider.notifier).goToStep(0);
                  },
                ),
                _buildBottomNavItem(
                  context,
                  Icons.medical_information,
                  'Historial médico',
                  patientScreensState,
                  onTap: () {
                    ref.read(patientScreensProvider.notifier).goToStep(1);
                  },
                ),
                _buildBottomNavItem(
                  context,
                  Icons.share_outlined,
                  'Compartir con médico',
                  patientScreensState,
                  onTap: () {
                    ref.read(patientScreensProvider.notifier).goToStep(2);
                  },
                ),
                _buildBottomNavItem(
                  context,
                  Icons.person_outline,
                  'Perfil',
                  patientScreensState,
                  onTap: () {
                    ref.read(patientScreensProvider.notifier).goToStep(3);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    AuthNotifier authMethods,
    NavigationService navigation,
    PersonModel? personModel,
    ThemeNotifier themeNotifier,
  ) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      title: Row(
        children: [
          const Text('☀️'),
          const SizedBox(width: 8),
          Text(
            'Bienvenido, ${personModel?.names ?? 'Paciente'}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.brightness_6),
          onPressed: () {
            themeNotifier.toggleTheme();
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            authMethods.logout();
            navigation.goToWelcome();
          },
        ),
      ],
    );
  }

  // Widget para el contenido de la pantalla
  Widget _buildCurrentStep(
    PatientScreensState state,
    int patientId,
    int personId,
  ) {
    switch (state.currentStep) {
      case 0:
        return const HomeScreenPatient();
      case 1:
        return const MedicalHistoryPatient();
      case 2:
        return ShareDataPatient(patientId: patientId, personId: personId);
      case 3:
        return const ProfilePatient();
      case 11:
        return MedicalCriticalInfoPatient(patientId: patientId);
      case 12:
        return MedicalAllergyPatient(patientId: patientId);
      case 13:
        return ChronicConditionPatient(patientId: patientId);
      case 14:
        return SurgicalHistoryPatient(patientId: patientId);
      case 15:
        return HospitalizationPatient(patientId: patientId);
      case 16:
        return VaccinationPatient(patientId: patientId);
      case 17:
        return FamilyHistoryPatient(patientId: patientId);
      case 18:
        return LifestylePatient(patientId: patientId);
      case 19:
        return InsurancePatient(patientId: patientId);
      case 20:
        return EmergencyContactPatient(patientId: patientId);
      case 21:
        return const ShareCodesPatientScreen();
      case 22:
        return const DiagnosticsPatientScreen();
      default:
        return HomeScreenPatient();
    }
  }

  // Widget para el bottom navigation
  Widget _buildBottomNavItem(
    BuildContext context,
    IconData icon,
    String label,
    PatientScreensState patientScreensState, {
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.secondary, size: 32),
        ],
      ),
    );
  }
}
