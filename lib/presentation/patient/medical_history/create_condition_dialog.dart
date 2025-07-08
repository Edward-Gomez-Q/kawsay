import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/patient/chronic_condition_notifier.dart';
import 'package:project_3_kawsay/model/patient/chronic_condition.dart';

class CreateConditionDialog extends ConsumerStatefulWidget {
  final int patientId;

  const CreateConditionDialog({super.key, required this.patientId});

  @override
  ConsumerState<CreateConditionDialog> createState() =>
      _CreateConditionDialogState();
}

class _CreateConditionDialogState extends ConsumerState<CreateConditionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _conditionController = TextEditingController();

  DateTime? _selectedDate;
  bool _isControlled = false;

  @override
  void dispose() {
    _conditionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Seleccionar fecha de diagnóstico',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _handleCreate() {
    if (_formKey.currentState?.validate() ?? false) {
      final condition = ChronicCondition(
        patientId: widget.patientId,
        condition: _conditionController.text.trim(),
        diagnosisDate: _selectedDate,
        controlled: _isControlled,
      );

      ref.read(chronicConditionProvider.notifier).createCondition(condition);
      Navigator.of(context).pop();
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isCreating = ref.watch(
      chronicConditionProvider.select((state) => state.isCreating),
    );

    return AlertDialog(
      title: const Text('Agregar Condición Crónica'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Condición
              TextFormField(
                controller: _conditionController,
                decoration: const InputDecoration(
                  labelText: 'Condición Crónica *',
                  border: OutlineInputBorder(),
                  hintText: 'Ej: Diabetes tipo 2, Hipertensión...',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La condición es requerida';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Fecha de diagnóstico
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Fecha de diagnóstico',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _selectedDate != null
                        ? _formatDate(_selectedDate!)
                        : 'Seleccionar fecha (opcional)',
                    style: TextStyle(
                      color: _selectedDate != null
                          ? Theme.of(context).textTheme.bodyLarge?.color
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Estado controlado
              SwitchListTile(
                title: const Text('Condición controlada'),
                subtitle: Text(_isControlled ? 'Sí' : 'No'),
                value: _isControlled,
                onChanged: (bool value) {
                  setState(() {
                    _isControlled = value;
                  });
                },
                secondary: Icon(
                  _isControlled ? Icons.check_circle : Icons.warning,
                  color: _isControlled ? Colors.green : Colors.orange,
                ),
                contentPadding: EdgeInsets.zero,
              ),

              if (_selectedDate != null) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedDate = null;
                        });
                      },
                      child: const Text('Quitar fecha'),
                    ),
                  ],
                ),
              ],
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
