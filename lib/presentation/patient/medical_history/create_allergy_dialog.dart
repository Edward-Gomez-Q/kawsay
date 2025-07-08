import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/patient/medical_allergy_notifier.dart';
import 'package:project_3_kawsay/model/patient/medical_allergy.dart';

class CreateAllergyDialog extends ConsumerStatefulWidget {
  final int patientId;

  const CreateAllergyDialog({super.key, required this.patientId});

  @override
  ConsumerState<CreateAllergyDialog> createState() =>
      _CreateAllergyDialogState();
}

class _CreateAllergyDialogState extends ConsumerState<CreateAllergyDialog> {
  final _formKey = GlobalKey<FormState>();
  final _allergenController = TextEditingController();
  final _reactionController = TextEditingController();

  String _selectedAllergenFrom = 'Medicamento';
  String _selectedSeverity = 'Leve';

  final List<String> _allergenFromOptions = [
    'Medicamento',
    'Alimento',
    'Ambiental',
    'Contacto',
    'Insecto',
    'Otro',
  ];

  final List<String> _severityOptions = ['Leve', 'Moderada', 'Severa'];

  @override
  void dispose() {
    _allergenController.dispose();
    _reactionController.dispose();
    super.dispose();
  }

  void _handleCreate() {
    if (_formKey.currentState?.validate() ?? false) {
      final allergy = MedicalAllergy(
        patientId: widget.patientId,
        allergenFrom: _selectedAllergenFrom,
        allergen: _allergenController.text.trim(),
        reaction: _reactionController.text.trim().isEmpty
            ? null
            : _reactionController.text.trim(),
        severity: _selectedSeverity,
      );

      ref.read(medicalAllergyProvider.notifier).createAllergy(allergy);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCreating = ref.watch(
      medicalAllergyProvider.select((state) => state.isCreating),
    );

    return AlertDialog(
      title: const Text('Agregar Nueva Alergia'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Origen del alérgeno
              DropdownButtonFormField<String>(
                value: _selectedAllergenFrom,
                decoration: const InputDecoration(
                  labelText: 'Origen del Alérgeno',
                  border: OutlineInputBorder(),
                ),
                items: _allergenFromOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedAllergenFrom = newValue;
                    });
                  }
                },
              ),

              const SizedBox(height: 16),

              // Alérgeno
              TextFormField(
                controller: _allergenController,
                decoration: const InputDecoration(
                  labelText: 'Alérgeno *',
                  border: OutlineInputBorder(),
                  hintText: 'Ej: Penicilina, Maní, Polen...',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El alérgeno es requerido';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Reacción
              TextFormField(
                controller: _reactionController,
                decoration: const InputDecoration(
                  labelText: 'Reacción',
                  border: OutlineInputBorder(),
                  hintText: 'Ej: Erupciones, Dificultad respiratoria...',
                ),
                maxLines: 2,
              ),

              const SizedBox(height: 16),

              // Severidad
              DropdownButtonFormField<String>(
                value: _selectedSeverity,
                decoration: const InputDecoration(
                  labelText: 'Severidad',
                  border: OutlineInputBorder(),
                ),
                items: _severityOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedSeverity = newValue;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: isCreating ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: isCreating ? null : _handleCreate,
          child: isCreating
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Crear'),
        ),
      ],
    );
  }
}
