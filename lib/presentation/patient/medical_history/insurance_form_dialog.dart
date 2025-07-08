import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/model/patient/insurance.dart';

class InsuranceFormDialog extends ConsumerStatefulWidget {
  final Function(Insurance) onSubmit;
  final int patientId;

  const InsuranceFormDialog({
    super.key,
    required this.onSubmit,
    required this.patientId,
  });

  @override
  ConsumerState<InsuranceFormDialog> createState() =>
      _InsuranceFormDialogState();
}

class _InsuranceFormDialogState extends ConsumerState<InsuranceFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _providerController = TextEditingController();
  final _policyNumberController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 365));

  @override
  void dispose() {
    _providerController.dispose();
    _policyNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.shield, color: colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            'Nuevo Seguro',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _providerController,
                decoration: InputDecoration(
                  labelText: 'Proveedor de seguro',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.business),
                  labelStyle: TextStyle(color: colorScheme.onSurface),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingrese el proveedor';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _policyNumberController,
                decoration: InputDecoration(
                  labelText: 'Número de póliza',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.badge),
                  labelStyle: TextStyle(color: colorScheme.onSurface),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingrese el número de póliza';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: Icon(Icons.play_arrow, color: colorScheme.primary),
                  title: const Text('Fecha de inicio'),
                  subtitle: Text(_formatDate(_startDate)),
                  onTap: () => _selectDate(context, true),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: Icon(Icons.stop, color: colorScheme.error),
                  title: const Text('Fecha de vencimiento'),
                  subtitle: Text(_formatDate(_endDate)),
                  onTap: () => _selectDate(context, false),
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
        FilledButton(
          onPressed: _submitForm,
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
          ),
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        if (isStart) {
          _startDate = selectedDate;
          if (_startDate.isAfter(_endDate)) {
            _endDate = _startDate.add(const Duration(days: 365));
          }
        } else {
          _endDate = selectedDate;
          if (_endDate.isBefore(_startDate)) {
            _startDate = _endDate.subtract(const Duration(days: 365));
          }
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final insurance = Insurance(
        patientId: widget.patientId,
        provider: _providerController.text.trim(),
        policyNumber: _policyNumberController.text.trim(),
        startDate: _startDate,
        endDate: _endDate,
      );
      widget.onSubmit(insurance);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
