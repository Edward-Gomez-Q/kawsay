import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project_3_kawsay/application/patient/surgical_history_notifier.dart';
import 'package:project_3_kawsay/model/patient/surgical_history.dart';

class SurgicalHistoryPatient extends ConsumerStatefulWidget {
  final int patientId;

  const SurgicalHistoryPatient({super.key, required this.patientId});

  @override
  ConsumerState<SurgicalHistoryPatient> createState() =>
      _SurgicalHistoryPatientState();
}

class _SurgicalHistoryPatientState
    extends ConsumerState<SurgicalHistoryPatient> {
  final _formKey = GlobalKey<FormState>();
  final _surgeryController = TextEditingController();
  final _noteComplicationsController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyyy');

  DateTime? _selectedDate;
  bool _hasComplications = false;
  bool _showForm = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(surgicalHistoryProvider.notifier)
          .loadSurgicalHistory(widget.patientId);
    });
  }

  @override
  void dispose() {
    _surgeryController.dispose();
    _noteComplicationsController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _surgeryController.clear();
    _noteComplicationsController.clear();
    _selectedDate = null;
    _hasComplications = false;
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final newSurgery = SurgicalHistory(
        patientId: widget.patientId,
        surgery: _surgeryController.text.trim(),
        surgeryDate: _selectedDate!,
        complications: _hasComplications,
        noteComplications:
            _hasComplications &&
                _noteComplicationsController.text.trim().isNotEmpty
            ? _noteComplicationsController.text.trim()
            : null,
      );

      ref
          .read(surgicalHistoryProvider.notifier)
          .createSurgicalHistory(newSurgery);
      _clearForm();
      setState(() {
        _showForm = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(surgicalHistoryProvider);

    if (state.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error!),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        ref.read(surgicalHistoryProvider.notifier).clearError();
      });
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Historial Quirúrgico',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              ElevatedButton.icon(
                onPressed: state.isCreating
                    ? null
                    : () {
                        setState(() {
                          _showForm = !_showForm;
                        });
                      },
                icon: Icon(_showForm ? Icons.close : Icons.add),
                label: Text(_showForm ? 'Cancelar' : 'Agregar'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_showForm) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _surgeryController,
                        decoration: const InputDecoration(
                          labelText: 'Cirugía',
                          hintText: 'Ej: Apendicectomía, Colecistectomía...',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El nombre de la cirugía es requerido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _selectDate,
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Fecha de cirugía',
                            suffixIcon: const Icon(Icons.calendar_today),
                            errorText: _selectedDate == null
                                ? 'Seleccione una fecha'
                                : null,
                          ),
                          child: Text(
                            _selectedDate != null
                                ? _dateFormat.format(_selectedDate!)
                                : 'Seleccionar fecha',
                            style: _selectedDate != null
                                ? null
                                : TextStyle(color: Theme.of(context).hintColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Switch(
                            value: _hasComplications,
                            onChanged: (value) {
                              setState(() {
                                _hasComplications = value;
                                if (!value) {
                                  _noteComplicationsController.clear();
                                }
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Hubo complicaciones',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),

                      // Campo de notas si hay complicaciones
                      if (_hasComplications) ...[
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _noteComplicationsController,
                          decoration: const InputDecoration(
                            labelText: 'Notas sobre complicaciones',
                            hintText: 'Describa las complicaciones...',
                          ),
                          validator: (value) {
                            if (_hasComplications &&
                                (value == null || value.trim().isEmpty)) {
                              return 'Debe describir las complicaciones';
                            }
                            return null;
                          },
                        ),
                      ],

                      const SizedBox(height: 8),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state.isCreating ? null : _submitForm,
                          child: state.isCreating
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Guardar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Lista de historial quirúrgico
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.surgicalHistoryList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.medical_services,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay historial quirúrgico registrado',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: state.surgicalHistoryList.length,
                    itemBuilder: (context, index) {
                      final surgery = state.surgicalHistoryList[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: surgery.complications
                                ? Theme.of(context).colorScheme.errorContainer
                                : Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                            child: Icon(
                              Icons.medical_services,
                              color: surgery.complications
                                  ? Theme.of(context).colorScheme.error
                                  : Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          title: Text(
                            surgery.surgery,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fecha: ${_dateFormat.format(surgery.surgeryDate)}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              if (surgery.complications) ...[
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.warning,
                                      size: 16,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Con complicaciones',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.error,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            onPressed: () => _showDeleteConfirmation(surgery),
                          ),
                          children: [
                            if (surgery.complications &&
                                surgery.noteComplications != null) ...[
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Complicaciones:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.error,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      surgery.noteComplications!,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(SurgicalHistory surgery) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
          '¿Está seguro de eliminar la cirugía "${surgery.surgery}" del ${_dateFormat.format(surgery.surgeryDate)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref
                  .read(surgicalHistoryProvider.notifier)
                  .deleteSurgicalHistory(surgery.id!, widget.patientId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
