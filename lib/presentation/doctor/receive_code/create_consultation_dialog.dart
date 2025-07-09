import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_3_kawsay/application/doctor/receive_code_notifier.dart';

class CreateConsultationDialog extends ConsumerStatefulWidget {
  final ReceiveCodeNotifier notifier;

  const CreateConsultationDialog({super.key, required this.notifier});

  @override
  ConsumerState<CreateConsultationDialog> createState() =>
      _CreateConsultationDialogState();
}

class _CreateConsultationDialogState
    extends ConsumerState<CreateConsultationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _chiefComplaintController = TextEditingController();
  final _physicalExaminationController = TextEditingController();
  final _vitalSignsController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _treatmentPlanController = TextEditingController();
  final _observationsController = TextEditingController();
  final _followUpInstructionsController = TextEditingController();
  bool _nextAppointmentRecommended = false;
  final DateTime _followUpDate = DateTime.now().add(const Duration(days: 7));

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Nueva Consulta',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _chiefComplaintController,
                    decoration: const InputDecoration(
                      labelText: 'Motivo de consulta',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value?.isEmpty == true ? 'Campo requerido' : null,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _physicalExaminationController,
                    decoration: const InputDecoration(
                      labelText: 'Examen físico',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value?.isEmpty == true ? 'Campo requerido' : null,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _vitalSignsController,
                    decoration: const InputDecoration(
                      labelText: 'Signos vitales',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value?.isEmpty == true ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _diagnosisController,
                    decoration: const InputDecoration(
                      labelText: 'Diagnóstico',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value?.isEmpty == true ? 'Campo requerido' : null,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _treatmentPlanController,
                    decoration: const InputDecoration(
                      labelText: 'Plan de tratamiento',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value?.isEmpty == true ? 'Campo requerido' : null,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _observationsController,
                    decoration: const InputDecoration(
                      labelText: 'Observaciones',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _followUpInstructionsController,
                    decoration: const InputDecoration(
                      labelText: 'Instrucciones de seguimiento',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value?.isEmpty == true ? 'Campo requerido' : null,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    title: const Text('Recomendar próxima cita'),
                    value: _nextAppointmentRecommended,
                    onChanged: (value) => setState(
                      () => _nextAppointmentRecommended = value ?? false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await widget.notifier.createConsultation(
                chiefComplaint: _chiefComplaintController.text,
                physicalExamination: _physicalExaminationController.text,
                vitalSigns: _vitalSignsController.text,
                diagnosis: _diagnosisController.text,
                treatmentPlan: _treatmentPlanController.text,
                observations: _observationsController.text,
                followUpInstructions: _followUpInstructionsController.text,
                nextAppointmentRecommended: _nextAppointmentRecommended,
                followUpDate: _followUpDate,
              );

              if (context.mounted) {
                Navigator.of(context).pop();
              }
            }
          },
          child: const Text('Crear Consulta'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _chiefComplaintController.dispose();
    _physicalExaminationController.dispose();
    _vitalSignsController.dispose();
    _diagnosisController.dispose();
    _treatmentPlanController.dispose();
    _observationsController.dispose();
    _followUpInstructionsController.dispose();
    super.dispose();
  }
}
