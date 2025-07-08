import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/model/patient/vaccination.dart';

class VaccinationFormDialog extends ConsumerStatefulWidget {
  final Function(Vaccination) onSubmit;
  final int patientId;

  const VaccinationFormDialog({
    super.key,
    required this.onSubmit,
    required this.patientId,
  });

  @override
  ConsumerState<VaccinationFormDialog> createState() =>
      _VaccinationFormDialogState();
}

class _VaccinationFormDialogState extends ConsumerState<VaccinationFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _vaccineController = TextEditingController();
  final _doseController = TextEditingController();
  final _institutionController = TextEditingController();
  DateTime _dateVaccine = DateTime.now();

  // Vacunas comunes
  final List<String> _commonVaccines = [
    'COVID-19',
    'Influenza',
    'Hepatitis A',
    'Hepatitis B',
    'Sarampión',
    'Polio',
    'Tétanos',
    'Varicela',
    'Meningitis',
    'Neumococo',
    'Rotavirus',
  ];

  @override
  void dispose() {
    _vaccineController.dispose();
    _doseController.dispose();
    _institutionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: const Row(
          children: [
            Icon(Icons.vaccines, color: Colors.white, size: 28),
            SizedBox(width: 12),
            Text(
              'Nueva Vacuna',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      titlePadding: EdgeInsets.zero,
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              // Dropdown para vacunas comunes
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Vacuna',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.vaccines),
                ),
                items: [
                  const DropdownMenuItem(
                    value: '',
                    child: Text('Seleccionar vacuna'),
                  ),
                  ..._commonVaccines.map(
                    (vaccine) =>
                        DropdownMenuItem(value: vaccine, child: Text(vaccine)),
                  ),
                  const DropdownMenuItem(
                    value: 'other',
                    child: Text('Otra...'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null && value != 'other' && value.isNotEmpty) {
                    _vaccineController.text = value;
                  } else if (value == 'other') {
                    _vaccineController.clear();
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione una vacuna';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Campo de texto para vacuna personalizada
              TextFormField(
                controller: _vaccineController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la vacuna',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.edit),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingrese el nombre de la vacuna';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _doseController,
                decoration: const InputDecoration(
                  labelText: 'Dosis (ej: 1ra dosis, Refuerzo)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.medical_services),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingrese la dosis';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _institutionController,
                decoration: const InputDecoration(
                  labelText: 'Institución',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.local_hospital),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingrese la institución';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF4CAF50),
                ),
                title: const Text('Fecha de vacunación'),
                subtitle: Text(_formatDate(_dateVaccine)),
                onTap: () => _selectDate(context),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _dateVaccine,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        _dateVaccine = selectedDate;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final vaccination = Vaccination(
        patientId: widget.patientId,
        vaccine: _vaccineController.text.trim(),
        dose: _doseController.text.trim(),
        dateVaccine: _dateVaccine,
        institution: _institutionController.text.trim(),
      );
      widget.onSubmit(vaccination);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
