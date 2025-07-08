import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/model/patient/hospitalization.dart';

class HospitalizationFormDialog extends ConsumerStatefulWidget {
  final Function(Hospitalization) onSubmit;
  final int patientId;

  const HospitalizationFormDialog({
    super.key,
    required this.onSubmit,
    required this.patientId,
  });

  @override
  ConsumerState<HospitalizationFormDialog> createState() =>
      _HospitalizationFormDialogState();
}

class _HospitalizationFormDialogState
    extends ConsumerState<HospitalizationFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  DateTime _admissionDate = DateTime.now();
  DateTime _dischargeDate = DateTime.now();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nueva Hospitalización'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: 'Motivo de hospitalización',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingrese el motivo';
                  }
                  return null;
                },
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.login),
                title: const Text('Fecha de ingreso'),
                subtitle: Text(_formatDate(_admissionDate)),
                onTap: () => _selectDate(context, true),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Fecha de alta'),
                subtitle: Text(_formatDate(_dischargeDate)),
                onTap: () => _selectDate(context, false),
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
        ElevatedButton(onPressed: _submitForm, child: const Text('Guardar')),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, bool isAdmission) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: isAdmission ? _admissionDate : _dischargeDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        if (isAdmission) {
          _admissionDate = selectedDate;
          if (_admissionDate.isAfter(_dischargeDate)) {
            _dischargeDate = _admissionDate;
          }
        } else {
          _dischargeDate = selectedDate;
          if (_dischargeDate.isBefore(_admissionDate)) {
            _admissionDate = _dischargeDate;
          }
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final hospitalization = Hospitalization(
        patientId: widget.patientId,
        reason: _reasonController.text.trim(),
        admissionDate: _admissionDate,
        dischargeDate: _dischargeDate,
      );
      widget.onSubmit(hospitalization);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
