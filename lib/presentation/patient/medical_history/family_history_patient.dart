import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/patient/family_history_notifier.dart';
import 'package:project_3_kawsay/model/patient/family_history.dart';

class FamilyHistoryPatient extends ConsumerStatefulWidget {
  final int patientId;

  const FamilyHistoryPatient({super.key, required this.patientId});

  @override
  ConsumerState<FamilyHistoryPatient> createState() =>
      _FamilyHistoryPatientState();
}

class _FamilyHistoryPatientState extends ConsumerState<FamilyHistoryPatient> {
  final _formKey = GlobalKey<FormState>();
  final _relationshipController = TextEditingController();
  final _conditionController = TextEditingController();
  final _ageController = TextEditingController();
  bool _showForm = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(familyHistoryProvider.notifier)
          .loadFamilyHistory(widget.patientId);
    });
  }

  @override
  void dispose() {
    _relationshipController.dispose();
    _conditionController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _relationshipController.clear();
    _conditionController.clear();
    _ageController.clear();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final newHistory = FamilyHistory(
        patientId: widget.patientId,
        relationship: _relationshipController.text.trim(),
        condition: _conditionController.text.trim(),
        ageOfOnset: int.parse(_ageController.text.trim()),
      );

      ref.read(familyHistoryProvider.notifier).createFamilyHistory(newHistory);
      _clearForm();
      setState(() {
        _showForm = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(familyHistoryProvider);

    if (state.error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error!),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        ref.read(familyHistoryProvider.notifier).clearError();
      });
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Historial Familiar',
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
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _relationshipController,
                        decoration: const InputDecoration(
                          labelText: 'Parentesco',
                          hintText: 'Ej: Padre, Madre, Hermano, Tío...',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'El parentesco es requerido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _conditionController,
                        decoration: const InputDecoration(
                          labelText: 'Condición/Enfermedad',
                          hintText: 'Ej: Diabetes, Hipertensión, Cáncer...',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'La condición es requerida';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Edad de inicio',
                          hintText: 'Edad cuando comenzó la condición',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'La edad es requerida';
                          }
                          final age = int.tryParse(value.trim());
                          if (age == null || age < 0 || age > 120) {
                            return 'Ingrese una edad válida (0-120)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
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
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.familyHistoryList.isEmpty
                ? SingleChildScrollView(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.family_restroom,
                            size: 64,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No hay historial familiar registrado',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: state.familyHistoryList.length,
                    itemBuilder: (context, index) {
                      final history = state.familyHistoryList[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            child: Icon(
                              Icons.person,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                          title: Text(
                            history.relationship,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                history.condition,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Edad de inicio: ${history.ageOfOnset} años',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.outline,
                                    ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            onPressed: () => _showDeleteConfirmation(history),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(FamilyHistory history) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
          '¿Está seguro de eliminar el historial de ${history.relationship} con ${history.condition}?',
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
                  .read(familyHistoryProvider.notifier)
                  .deleteFamilyHistory(history.id!, widget.patientId);
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
