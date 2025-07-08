import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/patient/medical_critical_info_notifier.dart';
import 'package:project_3_kawsay/model/patient/medical_critical_info.dart';
import 'package:project_3_kawsay/state/patient/medical_critical_info_state.dart';

class MedicalCriticalInfoPatient extends ConsumerStatefulWidget {
  final int patientId;

  const MedicalCriticalInfoPatient({super.key, required this.patientId});

  @override
  ConsumerState<MedicalCriticalInfoPatient> createState() =>
      _MedicalCriticalInfoPatientState();
}

class _MedicalCriticalInfoPatientState
    extends ConsumerState<MedicalCriticalInfoPatient> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _notesController;

  String _selectedBloodType = 'O+';
  bool _isPregnant = false;
  bool _hasImplants = false;

  final List<String> _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(medicalCriticalInfoProvider.notifier)
          .loadMedicalInfo(widget.patientId);
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _updateFormFromMedicalInfo(MedicalCriticalInfo? medicalInfo) {
    if (medicalInfo != null) {
      _selectedBloodType = medicalInfo.bloodType;
      _isPregnant = medicalInfo.pregnant;
      _hasImplants = medicalInfo.hasImplants;
      _notesController.text = medicalInfo.notes ?? '';
    }
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final currentInfo = ref
          .read(medicalCriticalInfoProvider)
          .medicalCriticalInfo;

      final updatedInfo = MedicalCriticalInfo(
        id: currentInfo?.id,
        patientId: widget.patientId,
        bloodType: _selectedBloodType,
        pregnant: _isPregnant,
        hasImplants: _hasImplants,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      );

      ref
          .read(medicalCriticalInfoProvider.notifier)
          .updateMedicalInfo(updatedInfo);
    }
  }

  void _handleCancel() {
    final currentInfo = ref
        .read(medicalCriticalInfoProvider)
        .medicalCriticalInfo;
    _updateFormFromMedicalInfo(currentInfo);
    ref.read(medicalCriticalInfoProvider.notifier).cancelEditing();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(medicalCriticalInfoProvider);

    ref.listen<MedicalCriticalInfoState>(medicalCriticalInfoProvider, (
      previous,
      next,
    ) {
      if (next.medicalCriticalInfo != null && !next.isEditing) {
        _updateFormFromMedicalInfo(next.medicalCriticalInfo);
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (state.medicalCriticalInfo != null && !state.isEditing)
                ElevatedButton(
                  child: const Text('Editar Información'),
                  onPressed: () {
                    ref
                        .read(medicalCriticalInfoProvider.notifier)
                        .toggleEditing();
                  },
                ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Información Crítica del Paciente',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          // Mostrar error si existe
          if (state.error != null)
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        ref
                            .read(medicalCriticalInfoProvider.notifier)
                            .clearError();
                      },
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Contenido principal
          if (state.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (state.medicalCriticalInfo == null)
            const Center(
              child: Text('No se encontró información médica crítica'),
            )
          else
            _buildMedicalInfoContent(state),
        ],
      ),
    );
  }

  Widget _buildMedicalInfoContent(MedicalCriticalInfoState state) {
    if (state.isEditing) {
      return _buildEditForm();
    } else {
      return _buildDisplayCard(state.medicalCriticalInfo!);
    }
  }

  Widget _buildDisplayCard(MedicalCriticalInfo medicalInfo) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              icon: Icons.bloodtype,
              label: 'Tipo de Sangre',
              value: medicalInfo.bloodType,
              color: Colors.red,
            ),

            const SizedBox(height: 16),

            _buildInfoRow(
              icon: Icons.pregnant_woman,
              label: 'Embarazo',
              value: medicalInfo.pregnant ? 'Sí' : 'No',
              color: medicalInfo.pregnant ? Colors.pink : Colors.grey,
            ),

            const SizedBox(height: 16),

            _buildInfoRow(
              icon: Icons.medical_services,
              label: 'Implantes',
              value: medicalInfo.hasImplants ? 'Sí' : 'No',
              color: medicalInfo.hasImplants ? Colors.orange : Colors.grey,
            ),

            if (medicalInfo.notes != null && medicalInfo.notes!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildInfoRow(
                icon: Icons.notes,
                label: 'Notas',
                value: medicalInfo.notes!,
                color: Colors.blue,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEditForm() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Editar Información Crítica',
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              const SizedBox(height: 24),
              Text(
                'Tipo de Sangre',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedBloodType,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.bloodtype),
                ),
                items: _bloodTypes.map((String bloodType) {
                  return DropdownMenuItem<String>(
                    value: bloodType,
                    child: Text(bloodType),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedBloodType = newValue;
                    });
                  }
                },
              ),

              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text('Embarazo'),
                subtitle: Text(_isPregnant ? 'Sí' : 'No'),
                value: _isPregnant,
                onChanged: (bool value) {
                  setState(() {
                    _isPregnant = value;
                  });
                },
                secondary: const Icon(Icons.pregnant_woman),
              ),

              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Implantes'),
                subtitle: Text(_hasImplants ? 'Sí' : 'No'),
                value: _hasImplants,
                onChanged: (bool value) {
                  setState(() {
                    _hasImplants = value;
                  });
                },
                secondary: const Icon(Icons.medical_services),
              ),

              const SizedBox(height: 20),

              // Notas
              Text(
                'Notas Adicionales',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.notes),
                  hintText: 'Información adicional relevante...',
                ),
                maxLines: 3,
                maxLength: 500,
              ),

              const SizedBox(height: 24),

              // Botones de acción
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _handleCancel,
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: ref.watch(medicalCriticalInfoProvider).isLoading
                        ? null
                        : _handleSave,
                    child: ref.watch(medicalCriticalInfoProvider).isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Guardar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
